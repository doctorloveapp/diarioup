#!/usr/bin/env python3
"""Send one manual watchdog test email using GitHub Actions SMTP secrets."""

from __future__ import annotations

import os
import smtplib
import sys
from datetime import datetime, timezone

from monitor_didup import MonitorError, send_email


TEST_RECIPIENT = "doctorloveapp@gmail.com"
TEST_SUBJECT = "Test Watchdog DiarioUp"


def main() -> int:
    os.environ["SMTP_TO"] = TEST_RECIPIENT
    os.environ["SMTP_SUBJECT"] = TEST_SUBJECT
    timestamp = datetime.now(timezone.utc).replace(microsecond=0).isoformat()
    body = (
        "Questa è una mail di prova del watchdog DiarioUp.\n\n"
        f"Invio eseguito: {timestamp}\n"
        "Se hai ricevuto questo messaggio, la configurazione SMTP dei "
        "GitHub Actions Secrets è valida.\n"
    )
    try:
        send_email(body)
    except (MonitorError, smtplib.SMTPException, OSError) as error:
        print(f"Invio della mail di prova non riuscito: {error}", file=sys.stderr)
        return 1

    print(f"Mail di prova inviata correttamente a {TEST_RECIPIENT}.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
