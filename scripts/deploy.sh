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
#   LADOCK_WEB_HOST=user@example.com
#   LADOCK_WEB_PATH=/var/www/ladock
#
set -euo pipefail

AKAR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[ -f "$AKAR/deploy.conf" ] && . "$AKAR/deploy.conf"

: "${LADOCK_WEB_HOST:?set LADOCK_WEB_HOST, e.g. user@host}"
: "${LADOCK_WEB_PATH:?set LADOCK_WEB_PATH, e.g. /var/www/ladock}"

# --delete keeps the server identical to the repository, but downloads/ is
# excluded so the installers already on the server are never removed.
rsync -avz --delete \
  --exclude 'downloads/' \
  --exclude '.git/' \
  --exclude 'scripts/' \
  --exclude 'CLAUDE.md' \
  --exclude 'STATE.md' \
  --exclude 'README.md' \
  --exclude '.gitignore' \
  --exclude '.gitattributes' \
  --exclude 'deploy.conf' \
  "$AKAR/" "$LADOCK_WEB_HOST:$LADOCK_WEB_PATH/"

echo "Deployed to $LADOCK_WEB_HOST:$LADOCK_WEB_PATH"
