#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [[ ! -f "$ROOT/.env" ]]; then
  echo "ERRO: $ROOT/.env não existe."
  echo "Execute: cp .env.example .env"
  exit 1
fi

kubectl apply -f "$ROOT/k8s/base/namespace.yaml"

kubectl \
  -n automation \
  create secret generic n8n-secrets \
  --from-env-file="$ROOT/.env" \
  --dry-run=client \
  -o yaml |
kubectl apply -f -

echo "Secret n8n-secrets aplicado."
