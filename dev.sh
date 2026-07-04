#!/bin/bash
# Dev server with auto hot-reload on file changes in lib/

PIPE=/tmp/flutter_carnevale_in

rm -f "$PIPE"
mkfifo "$PIPE"

# Keep the pipe open so flutter run doesn't exit when watcher writes to it
exec 3<>"$PIPE"

flutter run -d chrome --web-port=56569 <"$PIPE" &
FLUTTER_PID=$!

# Watch lib/ and assets/ for changes, send hot restart (R, not r — hot reload alone doesn't
# reliably pick up const-constructor/widget-tree-shape changes)
fswatch -o lib/ assets/ | while read; do
  echo "R" > "$PIPE"
done &
WATCHER_PID=$!

trap "kill $FLUTTER_PID $WATCHER_PID 2>/dev/null; rm -f $PIPE" EXIT
wait $FLUTTER_PID
