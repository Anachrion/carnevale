# TODO / Roadmap / Leftovers

## Auth

- P3 (low priority): open password reset emails directly in the native
  Android/iOS app instead of a browser tab.
  Password reset emails link to `FRONTEND_URL/reset-password?reset_password_token=...`
  (see `lib/main.dart`'s `_handleDeepLink`, which matches on `uri.path`).
  This works everywhere today: on web it loads the Flutter web build
  directly, and on Android/iOS it opens the link in the phone's browser. To
  make Android/iOS jump straight into the installed app instead, the link
  needs to become a verified Android App Link / iOS Universal Link, which
  requires a real production domain (`FRONTEND_URL` is still `localhost`,
  see `carnevale-backend`'s `TODO.md`) hosting `assetlinks.json` /
  `apple-app-site-association`.
