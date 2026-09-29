#!/usr/bin/env python3
"""Monitor public DidUP compatibility signals and prepare an email report.

The script intentionally performs no authenticated DidUP login.  It reads the
public Apple lookup endpoint and the public GitHub API, compares their current
state with ``baseline.json`` and reports only critical/high-priority changes.

GitHub and SMTP credentials, when needed, are read exclusively from environment
variables. Run ``python scripts/monitor_didup.py --help`` for usage details.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import smtplib
import ssl
import sys
import time
from dataclasses import dataclass
from datetime import UTC, datetime
from email.message import EmailMessage
from enum import IntEnum
from pathlib import Path
from typing import Any, Iterable, Mapping
from urllib.error import HTTPError, URLError
from urllib.parse import quote, urlencode
from urllib.request import Request, urlopen


APPLE_LOOKUP_URL = "https://itunes.apple.com/lookup"
APP_BUNDLE_ID = "it.argosoft.didup.famiglia.new"
GITHUB_API_URL = "https://api.github.com"
DEFAULT_BASELINE = Path(__file__).with_name("baseline.json")
DEFAULT_TIMEOUT_SECONDS = 20
USER_AGENT = "DiarioUp-DidUP-Monitor/1.0"


class Severity(IntEnum):
    INFO = 1
    HIGH = 2
    CRITICAL = 3

    @property
    def label(self) -> str:
        return {
            Severity.INFO: "Informativo",
            Severity.HIGH: "Alto",
            Severity.CRITICAL: "Critico",
        }[self]


@dataclass(frozen=True)
class Finding:
    severity: Severity
    source: str
    title: str
    details: str
    url: str


@dataclass(frozen=True)
class RepositoryRule:
    slug: str
    critical_paths: tuple[str, ...]
    high_paths: tuple[str, ...]


REPOSITORIES: tuple[RepositoryRule, ...] = (
    RepositoryRule(
        slug="Rocciadura/didupAPI-wrapper",
        critical_paths=(
            "didupwrapper/auth.py",
            "didupwrapper/client.py",
        ),
        high_paths=(
            "didupwrapper/endpoints/registro.py",
            "didupwrapper/models.py",
            "didupwrapper/exceptions.py",
            "tests/test_client.py",
            "tests/test_models.py",
        ),
    ),
    RepositoryRule(
        slug="DTrombett/portaleargo-api",
        critical_paths=(
            "src/BaseClient.ts",
            "src/Client.ts",
            "src/util/Constants.ts",
            "src/util/generateLoginLink.ts",
            "src/util/getCode.ts",
            "src/util/getToken.ts",
        ),
        high_paths=(
            "src/types/apiTypes.ts",
            "src/types/general.ts",
            "src/schemas/",
            "src/util/handleOperation.ts",
        ),
    ),
    RepositoryRule(
        slug="fcaloro-beep/argo-family-dashboard",
        critical_paths=(
            "custom_components/argo_family_dashboard/argo_client.py",
        ),
        high_paths=(
            "custom_components/argo_family_dashboard/coordinator.py",
            "custom_components/argo_family_dashboard/config_flow.py",
            "custom_components/argo_family_dashboard/sensor.py",
            "custom_components/argo_family_dashboard/manifest.json",
        ),
    ),
)


CRITICAL_ISSUE_PATTERNS = tuple(
    re.compile(pattern, re.IGNORECASE)
    for pattern in (
        r"\blogin\b",
        r"oauth",
        r"pkce",
        r"login[_ -]?challenge",
        r"redirect",
        r"\btoken\b",
        r"\b401\b",
        r"\b410\b",
        r"ultima versione",
        r"aggiorna(?:re|mento)? (?:l['’]?)?app",
        r"versione (?:presente )?negli store",
        r"credenzial",
        r"argo-client-version",
    )
)

HIGH_ISSUE_PATTERNS = tuple(
    re.compile(pattern, re.IGNORECASE)
    for pattern in (
        r"profilo",
        r"alunno",
        r"dashboard",
        r"compit",
        r"codmin",
        r"x-auth",
        r"opzioni",
        r"session",
        r"registro",
    )
)


class MonitorError(RuntimeError):
    """Raised when a remote response cannot safely be interpreted."""


class JsonHttpClient:
    def __init__(self, *, github_token: str | None = None) -> None:
        self._github_token = github_token

    def get_json(self, url: str) -> Any:
        headers = {
            "Accept": "application/vnd.github+json",
            "User-Agent": USER_AGENT,
            "X-GitHub-Api-Version": "2022-11-28",
        }
        if self._github_token and url.startswith(GITHUB_API_URL):
            headers["Authorization"] = f"Bearer {self._github_token}"
        request = Request(url, headers=headers)

        for attempt in range(3):
            try:
                with urlopen(
                    request,
                    timeout=DEFAULT_TIMEOUT_SECONDS,
                ) as response:
                    charset = response.headers.get_content_charset() or "utf-8"
                    return json.loads(response.read().decode(charset))
            except HTTPError as error:
                retryable = error.code == 429 or 500 <= error.code < 600
                if not retryable or attempt == 2:
                    raise MonitorError(
                        f"HTTP {error.code} durante la richiesta a {url}"
                    ) from error
            except (URLError, TimeoutError, json.JSONDecodeError) as error:
                if attempt == 2:
                    raise MonitorError(
                        f"Risposta non disponibile o non valida da {url}"
                    ) from error
            time.sleep(2**attempt)

        raise AssertionError("retry loop terminato senza risultato")


def load_baseline(path: Path) -> dict[str, Any]:
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError as error:
        raise MonitorError(
            f"Baseline non trovata: {path}. Crearla prima del monitoraggio."
        ) from error
    except json.JSONDecodeError as error:
        raise MonitorError(f"Baseline JSON non valida: {path}") from error

    if not isinstance(data, dict) or data.get("schemaVersion") != 1:
        raise MonitorError("Schema baseline non supportato.")
    if not isinstance(data.get("repositories"), dict):
        raise MonitorError("La baseline non contiene repositories.")
    return data


def fetch_official_app_version(client: JsonHttpClient) -> str:
    query = urlencode({"bundleId": APP_BUNDLE_ID})
    payload = client.get_json(f"{APPLE_LOOKUP_URL}?{query}")
    if not isinstance(payload, dict):
        raise MonitorError("Risposta Apple non valida.")
    results = payload.get("results")
    if not isinstance(results, list) or not results:
        raise MonitorError("L'app DidUP non è presente nella risposta Apple.")
    first = results[0]
    version = first.get("version") if isinstance(first, dict) else None
    if not isinstance(version, str) or not version.strip():
        raise MonitorError("Versione DidUP assente nella risposta Apple.")
    return version.strip()


def github_json(client: JsonHttpClient, path: str) -> Any:
    return client.get_json(f"{GITHUB_API_URL}{path}")


def fetch_repository_head(client: JsonHttpClient, repository: str) -> str:
    encoded = quote(repository, safe="/")
    repository_data = github_json(client, f"/repos/{encoded}")
    if not isinstance(repository_data, dict):
        raise MonitorError(f"Metadati GitHub non validi per {repository}.")
    default_branch = repository_data.get("default_branch")
    if not isinstance(default_branch, str) or not default_branch:
        raise MonitorError(f"Branch predefinito assente per {repository}.")
    commit = github_json(
        client,
        f"/repos/{encoded}/commits/{quote(default_branch, safe='')}",
    )
    sha = commit.get("sha") if isinstance(commit, dict) else None
    if not isinstance(sha, str) or not sha:
        raise MonitorError(f"SHA di testa assente per {repository}.")
    return sha


def fetch_changed_files(
    client: JsonHttpClient,
    repository: str,
    baseline_sha: str,
    current_sha: str,
) -> tuple[list[str], str]:
    if baseline_sha == current_sha:
        return [], "identical"
    encoded = quote(repository, safe="/")
    comparison = github_json(
        client,
        f"/repos/{encoded}/compare/{quote(baseline_sha, safe='')}..."
        f"{quote(current_sha, safe='')}",
    )
    if not isinstance(comparison, dict):
        raise MonitorError(f"Confronto GitHub non valido per {repository}.")
    status = comparison.get("status")
    files = comparison.get("files")
    if status not in {"ahead", "identical"}:
        raise MonitorError(
            f"Baseline {repository} non confrontabile con HEAD: {status}."
        )
    if not isinstance(files, list):
        files = []
    paths = [
        item["filename"]
        for item in files
        if isinstance(item, dict) and isinstance(item.get("filename"), str)
    ]
    return paths, str(status)


def path_severity(path: str, rule: RepositoryRule) -> Severity:
    if any(path == prefix or path.startswith(prefix) for prefix in rule.critical_paths):
        return Severity.CRITICAL
    if any(path == prefix or path.startswith(prefix) for prefix in rule.high_paths):
        return Severity.HIGH
    return Severity.INFO


def fetch_changed_issues(
    client: JsonHttpClient,
    repository: str,
    since: str,
) -> list[dict[str, Any]]:
    encoded = quote(repository, safe="/")
    query = urlencode(
        {
            "state": "all",
            "sort": "updated",
            "direction": "desc",
            "since": since,
            "per_page": "100",
        }
    )
    payload = github_json(client, f"/repos/{encoded}/issues?{query}")
    if not isinstance(payload, list):
        raise MonitorError(f"Elenco issue GitHub non valido per {repository}.")
    return [
        issue
        for issue in payload
        if isinstance(issue, dict) and "pull_request" not in issue
    ]


def issue_severity(issue: Mapping[str, Any]) -> Severity:
    text = f"{issue.get('title', '')}\n{issue.get('body', '')}"
    if any(pattern.search(text) for pattern in CRITICAL_ISSUE_PATTERNS):
        return Severity.CRITICAL
    if any(pattern.search(text) for pattern in HIGH_ISSUE_PATTERNS):
        return Severity.HIGH
    return Severity.INFO


def check_repository(
    client: JsonHttpClient,
    rule: RepositoryRule,
    baseline: Mapping[str, Any],
    checked_at: str,
) -> tuple[list[Finding], str]:
    repository_baseline = baseline.get(rule.slug)
    if not isinstance(repository_baseline, dict):
        raise MonitorError(f"Baseline repository assente: {rule.slug}.")
    baseline_sha = repository_baseline.get("headSha")
    if not isinstance(baseline_sha, str) or not baseline_sha:
        raise MonitorError(f"headSha baseline assente: {rule.slug}.")

    head_sha = fetch_repository_head(client, rule.slug)
    changed_files, _ = fetch_changed_files(
        client,
        rule.slug,
        baseline_sha,
        head_sha,
    )
    findings: list[Finding] = []
    for path in changed_files:
        severity = path_severity(path, rule)
        if severity < Severity.HIGH:
            continue
        findings.append(
            Finding(
                severity=severity,
                source=rule.slug,
                title=f"File {severity.label.lower()} modificato",
                details=f"È cambiato {path}.",
                url=(
                    f"https://github.com/{rule.slug}/compare/"
                    f"{baseline_sha}...{head_sha}"
                ),
            )
        )

    for issue in fetch_changed_issues(client, rule.slug, checked_at):
        severity = issue_severity(issue)
        if severity < Severity.HIGH:
            continue
        number = issue.get("number", "?")
        title = str(issue.get("title") or "Issue senza titolo")
        findings.append(
            Finding(
                severity=severity,
                source=rule.slug,
                title=f"Issue #{number}: {title}",
                details=f"Issue aggiornata: {issue.get('updated_at', 'data sconosciuta')}.",
                url=str(issue.get("html_url") or f"https://github.com/{rule.slug}/issues"),
            )
        )
    return findings, head_sha


def monitor(
    client: JsonHttpClient,
    baseline: Mapping[str, Any],
) -> tuple[list[Finding], dict[str, Any]]:
    checked_at = baseline.get("checkedAt")
    if not isinstance(checked_at, str) or not checked_at:
        raise MonitorError("checkedAt assente dalla baseline.")

    findings: list[Finding] = []
    official_version = fetch_official_app_version(client)
    baseline_version = baseline.get("officialAppVersion")
    if not isinstance(baseline_version, str) or not baseline_version:
        raise MonitorError("officialAppVersion assente dalla baseline.")
    if official_version != baseline_version:
        findings.append(
            Finding(
                severity=Severity.CRITICAL,
                source="Apple App Store",
                title="Versione ufficiale DidUP cambiata",
                details=f"Versione precedente: {baseline_version}; nuova: {official_version}.",
                url=f"{APPLE_LOOKUP_URL}?{urlencode({'bundleId': APP_BUNDLE_ID})}",
            )
        )

    repository_baseline = baseline["repositories"]
    current_heads: dict[str, dict[str, str]] = {}
    for rule in REPOSITORIES:
        repository_findings, head_sha = check_repository(
            client,
            rule,
            repository_baseline,
            checked_at,
        )
        findings.extend(repository_findings)
        current_heads[rule.slug] = {"headSha": head_sha}

    new_baseline: dict[str, Any] = {
        "schemaVersion": 1,
        "checkedAt": datetime.now(UTC).replace(microsecond=0).isoformat().replace(
            "+00:00",
            "Z",
        ),
        "officialAppVersion": official_version,
        "repositories": current_heads,
    }
    findings.sort(key=lambda finding: (-finding.severity, finding.source, finding.title))
    return findings, new_baseline


def build_email_body(findings: Iterable[Finding], checked_at: str) -> str:
    relevant = [finding for finding in findings if finding.severity >= Severity.HIGH]
    if not relevant:
        return ""

    lines = [
        "Monitoraggio compatibilità DidUP",
        f"Controllo eseguito: {checked_at}",
        "",
        f"Rilevati {len(relevant)} cambiamenti critici/alti.",
        "",
    ]
    for finding in relevant:
        lines.extend(
            (
                f"[{finding.severity.label.upper()}] {finding.source}",
                finding.title,
                finding.details,
                finding.url,
                "",
            )
        )
    lines.append(
        "Verificare manualmente il diff prima di modificare configurazione o protocollo."
    )
    return "\n".join(lines)


def _required_environment(name: str) -> str:
    value = os.environ.get(name, "").strip()
    if not value:
        raise MonitorError(f"Variabile d'ambiente SMTP obbligatoria mancante: {name}")
    return value


def send_email(body: str) -> None:
    host = _required_environment("SMTP_HOST")
    sender = _required_environment("SMTP_FROM")
    recipients = [
        item.strip()
        for item in _required_environment("SMTP_TO").split(",")
        if item.strip()
    ]
    if not recipients:
        raise MonitorError("SMTP_TO non contiene destinatari validi.")

    try:
        port = int(os.environ.get("SMTP_PORT") or "587")
    except ValueError as error:
        raise MonitorError("SMTP_PORT deve essere un numero intero.") from error
    username = os.environ.get("SMTP_USERNAME", "").strip()
    password = os.environ.get("SMTP_PASSWORD", "")
    use_ssl = (os.environ.get("SMTP_USE_SSL") or "false").lower() == "true"
    use_starttls = (
        os.environ.get("SMTP_USE_STARTTLS") or "true"
    ).lower() == "true"

    message = EmailMessage()
    message["Subject"] = os.environ.get(
        "SMTP_SUBJECT",
        "[DiarioUp] Variazioni compatibilità DidUP",
    )
    message["From"] = sender
    message["To"] = ", ".join(recipients)
    message.set_content(body)

    context = ssl.create_default_context()
    if use_ssl:
        smtp: smtplib.SMTP = smtplib.SMTP_SSL(
            host,
            port,
            timeout=DEFAULT_TIMEOUT_SECONDS,
            context=context,
        )
    else:
        smtp = smtplib.SMTP(host, port, timeout=DEFAULT_TIMEOUT_SECONDS)
    with smtp:
        if not use_ssl and use_starttls:
            smtp.starttls(context=context)
        if username:
            if not password:
                raise MonitorError(
                    "SMTP_PASSWORD è obbligatoria quando SMTP_USERNAME è impostata."
                )
            smtp.login(username, password)
        smtp.send_message(message)


def write_baseline(path: Path, baseline: Mapping[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(f"{path.suffix}.tmp")
    temporary.write_text(
        json.dumps(baseline, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    temporary.replace(path)


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Controlla i segnali pubblici di compatibilità DidUP.",
    )
    parser.add_argument(
        "--baseline",
        type=Path,
        default=DEFAULT_BASELINE,
        help="Percorso della baseline JSON.",
    )
    parser.add_argument(
        "--update-baseline",
        action="store_true",
        help="Aggiorna la baseline dopo un controllo completato con successo.",
    )
    parser.add_argument(
        "--send-email",
        action="store_true",
        help="Invia la mail se esistono risultati critici/alti.",
    )
    parser.add_argument(
        "--report-file",
        type=Path,
        help="Salva il testo della mail anche in questo file.",
    )
    parser.add_argument(
        "--fail-on-alert",
        action="store_true",
        help="Termina con codice 2 se vengono rilevati cambiamenti rilevanti.",
    )
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    try:
        baseline = load_baseline(args.baseline)
        client = JsonHttpClient(github_token=os.environ.get("GITHUB_TOKEN"))
        findings, new_baseline = monitor(client, baseline)
        report = build_email_body(findings, new_baseline["checkedAt"])

        if args.report_file is not None:
            args.report_file.parent.mkdir(parents=True, exist_ok=True)
            args.report_file.write_text(report, encoding="utf-8")
        if report:
            print(report)
            if args.send_email:
                send_email(report)
        else:
            print("Nessun cambiamento critico o alto rilevato.")

        if args.update_baseline:
            write_baseline(args.baseline, new_baseline)
        return 2 if report and args.fail_on_alert else 0
    except MonitorError as error:
        print(f"Errore monitor DidUP: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
