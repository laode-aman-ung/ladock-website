#!/usr/bin/env bash
# Pull a read-only snapshot of the live server and compare it with this repo.
#
# Run this BEFORE the first deploy. deploy.sh uses rsync --delete, and this
# repository was seeded by fetching known filenames over HTTP — which cannot
# see files nobody links to. Only a server-side listing proves the repo is
# complete.
#
# Nothing is written to the server. The snapshot lands in .snapshot-server/
# which is git-ignored.
set -euo pipefail

AKAR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[ -f "$AKAR/deploy.conf" ] && . "$AKAR/deploy.conf"

: "${LADOCK_WEB_HOST:?set LADOCK_WEB_HOST, e.g. root@148.230.103.166}"

# If the document root is not configured, list the candidates nginx knows
# about and stop. Guessing it would be reckless: deploy.sh runs rsync --delete
# against whatever this resolves to.
if [ -z "${LADOCK_WEB_PATH:-}" ]; then
  echo "LADOCK_WEB_PATH is not set. Asking nginx on $LADOCK_WEB_HOST ..."
  echo
  ssh "$LADOCK_WEB_HOST" \
    "grep -rhE '^[[:space:]]*(root|server_name)' /etc/nginx/sites-enabled/ /etc/nginx/conf.d/ 2>/dev/null | sed 's/;//' | sed 's/^[[:space:]]*//'" \
    | sed 's/^/  /'
  echo
  echo "Pick the root belonging to ladock.ladeep.id, then record it:"
  echo
  echo "  printf 'LADOCK_WEB_HOST=%s\\nLADOCK_WEB_PATH=/path/you/picked\\n' '$LADOCK_WEB_HOST' > deploy.conf"
  exit 1
fi

SNAP="$AKAR/.snapshot-server"
mkdir -p "$SNAP"

echo "Pulling $LADOCK_WEB_HOST:$LADOCK_WEB_PATH/ -> .snapshot-server/ (read-only)"
rsync -avz --exclude 'downloads/' "$LADOCK_WEB_HOST:$LADOCK_WEB_PATH/" "$SNAP/"

echo
echo "=== On the server but NOT in this repo (deploy --delete would ERASE these) ==="
found=0
while IFS= read -r f; do
  rel="${f#$SNAP/}"
  [ -e "$AKAR/$rel" ] || { echo "  $rel"; found=1; }
done < <(find "$SNAP" -type f)
[ $found -eq 0 ] && echo "  (none — repo covers everything on the server)"

echo
echo "=== In this repo but not on the server (deploy would ADD these) ==="
found=0
for f in $(cd "$AKAR" && git ls-files); do
  case "$f" in
    scripts/*|CLAUDE.md|STATE.md|README.md|.git*) continue ;;
  esac
  [ -e "$SNAP/$f" ] || { echo "  $f"; found=1; }
done
[ $found -eq 0 ] && echo "  (none)"

echo
echo "=== Present in both but DIFFERENT ==="
found=0
while IFS= read -r f; do
  rel="${f#$SNAP/}"
  if [ -e "$AKAR/$rel" ] && ! cmp -s "$f" "$AKAR/$rel"; then
    echo "  $rel  (server $(stat -c%s "$f")B vs repo $(stat -c%s "$AKAR/$rel")B)"
    found=1
  fi
done < <(find "$SNAP" -type f)
[ $found -eq 0 ] && echo "  (none)"

echo
echo "Review the first list carefully. Anything there must be committed to this"
echo "repository before deploy.sh is allowed to run."
