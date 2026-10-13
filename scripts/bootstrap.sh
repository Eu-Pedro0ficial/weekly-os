#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Applying namespace/secrets"
"$ROOT/scripts/apply-secrets.sh"

echo "==> Applying Kubernetes manifests"
kubectl apply -k "$ROOT/k8s/base"

echo "==> Waiting for PostgreSQL"
kubectl -n automation rollout status statefulset/postgres --timeout=180s

echo "==> Waiting for n8n"
kubectl -n automation rollout status deployment/n8n --timeout=300s

echo
echo "==> Status"
kubectl -n automation get pods,pvc,svc

echo
echo "n8n deployed."
echo "Use: make ui"
