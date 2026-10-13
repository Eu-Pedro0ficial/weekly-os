#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
POD="$(kubectl -n automation get pod -l app=n8n -o jsonpath='{.items[0].metadata.name}')"

rm -rf "$ROOT/workflows"/*
mkdir -p "$ROOT/workflows"

kubectl exec -n automation "$POD" -- \
  rm -rf /tmp/n8n-workflows

kubectl exec -n automation "$POD" -- \
  mkdir -p /tmp/n8n-workflows

kubectl exec -n automation "$POD" -- \
  n8n export:workflow \
    --backup \
    --output=/tmp/n8n-workflows/

kubectl cp \
  "automation/$POD:/tmp/n8n-workflows/." \
  "$ROOT/workflows/"

echo
echo "Workflows exportados:"
find "$ROOT/workflows" -type f -name '*.json' -print
