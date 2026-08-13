# Carnevale Companion

A fan-made companion app for [Carnevale](https://ttcombat.com/collections/carnevale), TT Combat's
tabletop skirmish game set in a flooded, monster-haunted Venice.

The app carries the parts of a game that are tedious on paper: browsing the card catalog,
building a gang within a Ducat limit, and tracking a live two-player game — hit points, will,
command points and secret agendas — synchronised between both players' devices in real time.
The tabletop stays on the table; this handles the bookkeeping.

This repository is the **Flutter client** for iOS, Android and web. The Rails server it talks to
lives in [`carnevale-backend`](https://github.com/Anachrion/carnevale-backend).

> **Disclaimer:** This is an unofficial fan project, not affiliated with or endorsed by
> TT Combat.

---

## Links

| | |
|---|---|
| 🎬 **Walkthrough video** | [Carnevale App Walkthrough](https://www.youtube.com/watch?v=z1iAEC28lCA) — the fastest way to see what it does |
| 🌐 **Web app** | [carnevale-app.com](https://carnevale-app.com) |
| 📱 **Android** | [Google Play](https://play.google.com/store/apps/details?id=app.carnevale.mobile) — currently in **closed testing**, so the listing isn't public yet |
| ⚙️ **Backend repo** | [Anachrion/carnevale-backend](https://github.com/Anachrion/carnevale-backend) — Rails API, WebSockets, card catalog |
| 🎲 **The game itself** | [Carnevale by TT Combat](https://ttcombat.com/collections/carnevale) |

---

## What it does

**Cards browser** — every profile, weapon, special rule and spell, filterable by faction, with
full card faces front and back.

**Gang builder** — build a gang against a faction and a Ducat limit, with the list validated as
you go. Gangs sync across all your devices through the backend.

**Live game session** — one player creates a game and shares a join code. Both pick a gang, draw
their agendas privately, and play. State changes are pushed over WebSocket to both devices, so
neither player has to relay numbers to the other. Close the app or switch devices mid-game and
sign back in — the server holds the state, so you resume exactly where you were.

---

## Getting started

**Requirements:** the Flutter SDK, and a running backend (see the
[backend README](https://github.com/Anachrion/carnevale-backend) to bring one up locally).

```bash
flutter pub get
flutter run
```

By default the app talks to `localhost:3000`. Point it elsewhere with `--dart-define`:

```bash
flutter run \
  --dart-define=API_HOST=carnevale-app.com \
  --dart-define=API_USE_TLS=true \
  --dart-define=API_KEY=<key>
```

`API_KEY` identifies a build as an official client. The production backend rejects requests
without an `X-Api-Key` header, so a build made without it gets 401 on every request. It is not
per-user auth — that's the JWT the app obtains at sign-in.

`SHARE_SITE_ORIGIN` is the odd one out: it sets the site that links handed to *other
people* point at — a game-join link, a shared game setup — and it defaults to
`https://carnevale-app.com` rather than to a local server. The settings above say where this
build fetches from, so defaulting them to localhost is what makes `flutter run` work with no
flags; a shared link is opened on someone else's phone, where `http://localhost:3000/join?code=…`
resolves to nothing. Override it only for a deployment that serves its own copy of the app:

```bash
flutter run --dart-define=SHARE_SITE_ORIGIN=https://staging.example.com
```

Whatever you set must be a host the Android manifest claims as an App Link and that the
backend serves the SPA at, or the links open a browser instead of the app (see "Enabling
Android App Links" in the backend's `docs/DEPLOYMENT.md`).

### Development

```bash
flutter analyze      # static analysis
dart format .        # formatting
flutter test         # test suite
./dev.sh             # web dev server on http://localhost:56569
```

`lib/api_client/` is **generated** from the backend's OpenAPI schema by
`scripts/generate_api.sh` — change the schema in the backend and regenerate, rather than editing
those files by hand.

#### Two-player login helper

Testing the two-player flow normally means logging into two browsers by hand.
`scripts/two_player_login.py` drives the real login form in two isolated Chrome windows (no auth
bypass, no app changes) and leaves both signed in.

Requires the backend seeded with dev accounts (`rails db:seed` there), `./dev.sh` running, and
`pip install selenium`. Then:

```bash
python3 scripts/two_player_login.py       # --url if your dev server is on another port
```

---

## Releasing

Android builds are signed and published through `bin/publish-play`, which pulls the upload
keystore and the Play service account from Infisical, builds a release App Bundle pointed at
production, and uploads it to a Play track:

```bash
infisical run --env=prod --recursive -- bin/publish-play
# --track NAME   Play track (default: alpha = closed testing)
# --dry-run      build and sign only, no upload
```

`--recursive` matters — the script needs both the `/android` secrets and the root `API_KEY`.
`versionCode` comes from the git commit count, so every commit yields a strictly higher, gap-free
code with no manual bookkeeping.

The **web** build is released from the backend repo (`bin/release-web`), which compiles this app
with the production API baked in and ships it inside the backend's Docker image.

### Android App Links

The Android build claims `https://carnevale-app.com/join` and `/reset-password` (see the
`autoVerify` intent-filter in `AndroidManifest.xml`), so a shared game link or a password-reset
email opens the app instead of the browser. Android only honours that claim if the backend serves
a matching certificate fingerprint at `/.well-known/assetlinks.json`.

Two things worth knowing before a release:

- The fingerprint is the one from Play Console → *App integrity* → **App signing** — **not** the
  upload key. Releases go up as an `.aab`, so Google re-signs them and the certificate on a user's
  phone is Google's. Using the upload fingerprint fails silently: the file serves fine and the
  links simply keep opening the browser.
- **Deploy the backend before publishing the app.** Verification runs at install time, so anyone
  installing while the backend serves no fingerprint stays unverified until they reinstall.

Setup is one-time — the app signing key does not change between releases. Full procedure, including
how to verify it worked, is in the backend repo: `docs/DEPLOYMENT.md` → *Enabling Android App
Links*.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) — in particular the section on third-party intellectual
property, which is the rule that matters most here.

---

## License

The **source code** in this repository is licensed under the
[GNU Affero General Public License v3.0](LICENSE), matching the backend.

This app bundles faction symbols, iconography, and other content that is the intellectual
property of **TT Combat** ("Carnevale"). That content is **not** covered by the AGPL — it is
included with TT Combat's permission and remains © TT Combat, all rights reserved. See
[NOTICE](NOTICE) for the full carve-out. If you reuse this code, you are responsible for removing
that content or obtaining your own permission from TT Combat.

This is an unofficial fan project, not affiliated with or endorsed by TT Combat.
