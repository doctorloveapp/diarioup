import importlib.util
import os
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch


MODULE_PATH = Path(__file__).with_name("monitor_didup.py")
SPEC = importlib.util.spec_from_file_location("monitor_didup", MODULE_PATH)
if SPEC is None or SPEC.loader is None:
    raise RuntimeError("Impossibile caricare monitor_didup.py")
monitor = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = monitor
SPEC.loader.exec_module(monitor)


class FakeClient:
    def __init__(self, responses):
        self.responses = responses

    def get_json(self, url):
        for marker, response in self.responses.items():
            if marker in url:
                return response
        raise AssertionError(f"URL inatteso: {url}")


class MonitorDidupTest(unittest.TestCase):
    def test_issue_login_is_critical(self):
        issue = {
            "title": "Login non funzionante",
            "body": "Il server richiede l'ultima versione negli store.",
        }
        self.assertEqual(
            monitor.issue_severity(issue),
            monitor.Severity.CRITICAL,
        )

    def test_dashboard_issue_is_high(self):
        issue = {
            "title": "Dashboard vuota",
            "body": "La struttura dei compiti è cambiata.",
        }
        self.assertEqual(monitor.issue_severity(issue), monitor.Severity.HIGH)

    def test_repository_paths_have_expected_priority(self):
        rule = monitor.REPOSITORIES[0]
        self.assertEqual(
            monitor.path_severity("didupwrapper/auth.py", rule),
            monitor.Severity.CRITICAL,
        )
        self.assertEqual(
            monitor.path_severity("didupwrapper/models.py", rule),
            monitor.Severity.HIGH,
        )
        self.assertEqual(
            monitor.path_severity("README.md", rule),
            monitor.Severity.INFO,
        )

    def test_official_version_is_read_from_apple_payload(self):
        client = FakeClient(
            {
                "itunes.apple.com": {
                    "resultCount": 1,
                    "results": [{"version": "1.31.0"}],
                }
            }
        )
        self.assertEqual(monitor.fetch_official_app_version(client), "1.31.0")

    def test_email_body_contains_only_relevant_findings(self):
        findings = [
            monitor.Finding(
                severity=monitor.Severity.CRITICAL,
                source="Apple App Store",
                title="Versione cambiata",
                details="1.30.2 -> 1.31.0",
                url="https://example.test/critical",
            ),
            monitor.Finding(
                severity=monitor.Severity.INFO,
                source="Repository",
                title="README modificato",
                details="Nessun impatto.",
                url="https://example.test/info",
            ),
        ]
        body = monitor.build_email_body(findings, "2026-09-29T12:00:00Z")
        self.assertIn("CRITICO", body)
        self.assertIn("1.31.0", body)
        self.assertNotIn("README modificato", body)

    def test_smtp_configuration_requires_environment(self):
        with patch.dict(os.environ, {}, clear=True):
            with self.assertRaises(monitor.MonitorError):
                monitor.send_email("report")

    def test_write_and_load_baseline(self):
        baseline = {
            "schemaVersion": 1,
            "checkedAt": "2026-09-29T00:00:00Z",
            "officialAppVersion": "1.30.2",
            "repositories": {},
        }
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "baseline.json"
            monitor.write_baseline(path, baseline)
            self.assertEqual(monitor.load_baseline(path), baseline)


if __name__ == "__main__":
    unittest.main()
