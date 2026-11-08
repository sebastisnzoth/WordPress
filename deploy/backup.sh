#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
set -a
# shellcheck disable=SC1091
source .env
set +a
umask 077
mkdir -p backups
timestamp="$(date -u +%Y%m%dT%H%M%SZ)"
file="backups/wordpress-${timestamp}.sql.gz"
docker compose exec -T database sh -c 'exec mariadb-dump --single-transaction --quick -u root -p"$MARIADB_ROOT_PASSWORD" wordpress' | gzip > "$file"
test -s "$file"
printf 'Database backup created: %s\n' "$file"
printf 'IMPORTANT: back up the WordPress uploads volume separately and copy both off-server.\n'
