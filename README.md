# Weekly OS Automation

Self-hosted automation platform for my personal Weekly OS.

The project provides a reproducible n8n deployment running on Kubernetes/K3s, backed by PostgreSQL and designed around GitOps, portability, and recoverability.

## Architecture

```text
Notion
   │
   ▼
  n8n
   │
   ├── Google Calendar
   ├── Weekly OS metrics
   └── Future personal assistant workflows

Infrastructure:

Git
 │
 ▼
K3s
 └── namespace: automation
      ├── n8n
      ├── PostgreSQL
      ├── Persistent Volumes
      └── Kubernetes Secrets
```

## Principles

- Notion is the source of truth.
- n8n is the orchestration layer.
- Google Calendar is the execution interface.
- Infrastructure is declarative and version controlled.
- Secrets are never committed to Git.
- Persistent state is backed up independently from Git.
- The runtime host should be replaceable.

## Current Stack

- n8n
- PostgreSQL 16
- Kubernetes / K3s
- Kustomize
- Traefik
- ArgoCD
- Bash
- GitHub

## Repository Structure

```text
.
├── argocd/
├── backups/
├── k8s/
│   ├── base/
│   └── overlays/
│       └── k3s/
├── scripts/
├── workflows/
├── .env.example
├── .gitignore
├── Makefile
└── README.md
```

## Bootstrap

Clone the repository:

```bash
git clone <repository-url>
cd weekly-os
```

Create the local environment:

```bash
cp .env.example .env
```

Generate strong local credentials and configure `.env`.

Deploy:

```bash
make bootstrap
```

Check the platform:

```bash
make status
```

Access n8n locally:

```bash
make ui
```

Then open:

```text
http://127.0.0.1:5678
```

## Useful Commands

```bash
make bootstrap
make deploy
make status
make diff
make ui
make export
make backup
```

## Persistence

Git stores the platform definition and exported workflows.

Runtime state is stored separately:

- PostgreSQL database
- `/home/node/.n8n`
- `N8N_ENCRYPTION_KEY`
- Kubernetes/runtime credentials

These assets must be backed up independently.

## Roadmap

- [x] M0 — n8n platform bootstrap
- [ ] M0.1 — Ingress / HTTPS
- [ ] M0.2 — ArgoCD Application
- [ ] M0.3 — Automated off-host backups
- [ ] M1 — Notion → Google Calendar synchronization
- [ ] M2 — Execution metrics
- [ ] M3 — Weekly Review automation
- [ ] M4 — Planning assistant
- [ ] M5 — Personal agent

## Security

This repository intentionally contains no production credentials.

Never commit:

- `.env`
- encryption keys
- OAuth tokens
- API tokens
- database backups
- exported credentials

## Status

The current platform runs n8n and PostgreSQL on K3s using persistent volumes and a reproducible bootstrap process.

The next milestone is GitOps integration through ArgoCD and controlled external access through Traefik.
