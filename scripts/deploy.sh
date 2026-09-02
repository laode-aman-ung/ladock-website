#!/usr/bin/env bash
# Deploy the site to the nginx host.
#
# One-way on purpose: this repository is the source of truth, the server is
# only a copy. Never edit files directly on the server — that is how docs.html
# drifted ahead of git before this repository existed.
#
# Configure once, either as environment variables or in deploy.conf
# (git-ignored):
#
#   LADOCK_WEB_HOST=root@148.230.103.166
#   LADOCK_WEB_PATH=/var/www/ladock
#
# Usage:
#   scripts/deploy.sh -n     dry run — show what would change, touch nothing
#   scripts/deploy.sh        deploy for real (asks to confirm)
#
set -euo pipefail

AKAR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[ -f "$AKAR/deploy.conf" ] && . "$AKAR/deploy.conf"

: "${LADOCK_WEB_HOST:?set LADOCK_WEB_HOST, e.g. root@148.230.103.166}"
: "${LADOCK_WEB_PATH:?set LADOCK_WEB_PATH, e.g. /var/www/ladock}"

DRY=""
[ "${1:-}" = "-n" ] && DRY="--dry-run"

EXCLUDES=(
  --exclude 'downloads/'         # installers live on the server, never here
  --exclude '.snapshot-server/'  # local copy OF the server — never push it back
  --exclude '.git/'
  --exclude 'scripts/'
  --exclude 'CLAUDE.md'
  --exclude 'STATE.md'
  --exclude 'README.md'
  --exclude '.gitignore'
  --exclude '.gitattributes'
  --exclude 'deploy.conf'
)

# ── Guard ────────────────────────────────────────────────────────────────
# --delete as root against a mistyped path would wipe an unrelated directory.
# Refuse unless the target already looks like this site.
echo "Checking $LADOCK_WEB_HOST:$LADOCK_WEB_PATH ..."
if ! ssh "$LADOCK_WEB_HOST" "test -f '$LADOCK_WEB_PATH/index.html'"; then
  cat >&2 <<MSG
REFUSING TO DEPLOY.

  $LADOCK_WEB_PATH/index.html was not found on $LADOCK_WEB_HOST.

Either LADOCK_WEB_PATH is wrong, or this is a first deploy into an empty
directory. Because this script runs rsync --delete, it will not touch a
directory it cannot recognise as the site.

Find the real document root on the server with:

  grep -r 'root ' /etc/nginx/sites-enabled/

For a genuine first deploy, upload once without --delete:

  rsync -rlptDvz ${EXCLUDES[*]} "$AKAR/" "$LADOCK_WEB_HOST:$LADOCK_WEB_PATH/"
MSG
  exit 1
fi

# ── Preview, then confirm ────────────────────────────────────────────────
echo "Changes to be applied:"
rsync -rlptDz --delete --itemize-changes --dry-run "${EXCLUDES[@]}" \
  "$AKAR/" "$LADOCK_WEB_HOST:$LADOCK_WEB_PATH/" | sed 's/^/  /'

if [ -n "$DRY" ]; then
  echo "Dry run only — nothing was changed."
  exit 0
fi

read -rp "Apply these changes to $LADOCK_WEB_HOST:$LADOCK_WEB_PATH ? [y/N] " ans
[ "$ans" = "y" ] || { echo "Cancelled."; exit 0; }

rsync -rlptDvz --delete "${EXCLUDES[@]}" "$AKAR/" "$LADOCK_WEB_HOST:$LADOCK_WEB_PATH/"
echo "Deployed to $LADOCK_WEB_HOST:$LADOCK_WEB_PATH"
