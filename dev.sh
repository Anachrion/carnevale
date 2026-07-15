#!/bin/bash
# Dev server with auto hot-reload on file changes in lib/

PIPE=/tmp/flutter_carnevale_in

rm -f "$PIPE"
mkfifo "$PIPE"

# Keep the pipe open so flutter run doesn't exit when watcher writes to it
exec 3<>"$PIPE"

# Give the dev Chrome a stable profile dir. Without this, `flutter run -d chrome` spins up a
# fresh temporary profile each run, so the browser localStorage/IndexedDB backing
# flutter_secure_storage is wiped and you're logged out on every restart. A fixed dir persists
# the auth token across restarts.
CHROME_PROFILE="${CARNEVALE_CHROME_PROFILE:-/tmp/carnevale-chrome-dev}"

flutter run -d chrome --web-port=56569 \
  --web-browser-flag="--user-data-dir=$CHROME_PROFILE" <"$PIPE" &
FLUTTER_PID=$!

# Watch lib/ and assets/ for changes, send hot restart (R, not r — hot reload alone doesn't
# reliably pick up const-constructor/widget-tree-shape changes)
fswatch -o lib/ assets/ | while read; do
  echo "R" > "$PIPE"
done &
WATCHER_PID=$!

trap "kill $FLUTTER_PID $WATCHER_PID 2>/dev/null; rm -f $PIPE" EXIT
wait $FLUTTER_PID
