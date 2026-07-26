#!/usr/bin/env python3
"""Upload a signed Android App Bundle to a Google Play track via the Play
Developer API.

Non-interactive companion to bin/publish-play: it does only the "talk to Play"
step (create edit -> upload .aab -> assign to track -> commit). Building and
signing the bundle is the wrapper's job.

Auth comes from a Google Play service-account JSON, read from the environment
(never a file on disk) to match the repo's Infisical posture:

    ANDROID_PLAY_SERVICE_ACCOUNT_JSON   the full service-account key, verbatim JSON

The service account must be invited in Play Console (Users & permissions) with
release rights on the package, and the Google Play Android Developer API must be
enabled in its Cloud project. Note: the Play API can only push to a track once
the app has had at least one release created through the console UI.

Dependencies (install once into your pyenv):

    pip install google-api-python-client google-auth

Usage (normally invoked by bin/publish-play, not by hand):

    ANDROID_PLAY_SERVICE_ACCOUNT_JSON=... \\
      python3 scripts/play_upload.py \\
        --aab build/app/outputs/bundle/release/app-release.aab \\
        --package app.carnevale.mobile \\
        --track alpha \\
        --status completed \\
        --release-name 1.0.0 \\
        --notes-file store-assets/whatsnew/en-US.txt
"""

import argparse
import json
import os
import sys


def die(msg: str) -> "NoReturn":  # type: ignore[name-defined]
    print(f"error: {msg}", file=sys.stderr)
    sys.exit(1)


def build_service():
    try:
        from google.oauth2 import service_account
        from googleapiclient.discovery import build
    except ImportError:
        die(
            "google-api-python-client / google-auth not installed.\n"
            "       Run: pip install google-api-python-client google-auth"
        )

    raw = os.environ.get("ANDROID_PLAY_SERVICE_ACCOUNT_JSON")
    if not raw:
        die(
            "ANDROID_PLAY_SERVICE_ACCOUNT_JSON is not set.\n"
            "       Run wrapped in: infisical run --env=prod --recursive -- ..."
        )
    try:
        info = json.loads(raw)
    except json.JSONDecodeError as e:
        die(f"ANDROID_PLAY_SERVICE_ACCOUNT_JSON is not valid JSON: {e}")

    creds = service_account.Credentials.from_service_account_info(
        info, scopes=["https://www.googleapis.com/auth/androidpublisher"]
    )
    # cache_discovery=False avoids a noisy warning and a filesystem write we don't want.
    return build("androidpublisher", "v3", credentials=creds, cache_discovery=False)


def main() -> None:
    p = argparse.ArgumentParser(description="Upload an .aab to a Google Play track.")
    p.add_argument("--aab", required=True, help="path to the signed app bundle")
    p.add_argument("--package", required=True, help="applicationId, e.g. app.carnevale.mobile")
    p.add_argument("--track", default="alpha", help="Play track (default: alpha = built-in closed testing)")
    p.add_argument(
        "--status",
        default="completed",
        choices=["completed", "draft", "halted", "inProgress"],
        help="release status (default: completed = live to that track's testers)",
    )
    p.add_argument("--release-name", default=None, help="human-readable release name shown in the console")
    p.add_argument("--notes-file", default=None, help="what's-new text file (en-US) to attach as release notes")
    args = p.parse_args()

    if not os.path.isfile(args.aab):
        die(f"app bundle not found: {args.aab}")

    from googleapiclient.errors import HttpError
    from googleapiclient.http import MediaFileUpload

    service = build_service()
    edits = service.edits()

    try:
        edit_id = edits.insert(packageName=args.package, body={}).execute()["id"]

        media = MediaFileUpload(args.aab, mimetype="application/octet-stream", resumable=True)
        bundle = edits.bundles().upload(
            packageName=args.package, editId=edit_id, media_body=media
        ).execute()
        version_code = bundle["versionCode"]
        print(f"==> Uploaded bundle, versionCode {version_code}")

        release = {"versionCodes": [str(version_code)], "status": args.status}
        if args.release_name:
            release["name"] = args.release_name
        if args.notes_file:
            with open(args.notes_file, encoding="utf-8") as f:
                text = f.read().strip()
            if text:
                release["releaseNotes"] = [{"language": "en-US", "text": text}]

        edits.tracks().update(
            packageName=args.package,
            editId=edit_id,
            track=args.track,
            body={"track": args.track, "releases": [release]},
        ).execute()
        print(f"==> Assigned versionCode {version_code} to track '{args.track}' ({args.status})")

        edits.commit(packageName=args.package, editId=edit_id).execute()
        print(f"==> Committed. Live on '{args.track}' after Google's review.")
    except HttpError as e:
        # Play's error body is far more useful than the bare status line.
        die(f"Play API rejected the request:\n{e.content.decode('utf-8', 'replace') if e.content else e}")


if __name__ == "__main__":
    main()
