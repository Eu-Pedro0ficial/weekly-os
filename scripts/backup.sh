#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TS="$(date +%Y%m%d-%H%M%S)"
DEST="$ROOT/backups/$TS"

mkdir -p "$DEST"

echo "==> PostgreSQL"
kubectl exec -n automation statefulset/postgres -- \
  sh -c 'pg_dump -U "$POSTGRES_USER" "$POSTGRES_DB"' |
  gzip >"$DEST/postgres.sql.gz"

echo "==> /home/node/.n8n"
POD="$(kubectl -n automation get pod -l app=n8n -o jsonpath='{.items[0].metadata.name}')"

kubectl exec -n automation "$POD" -- \
  tar czf - -C /home/node .n8n \
  >"$DEST/n8n-data.tar.gz"

cp "$ROOT/.env" "$DEST/secrets.env"
chmod 600 "$DEST/secrets.env"

sha256sum "$DEST"/* >"$DEST/SHA256SUMS"

echo
echo "Backup criado em:"
echo "$DEST"
