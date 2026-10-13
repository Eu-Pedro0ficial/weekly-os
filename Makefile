SHELL := /bin/bash

.PHONY: bootstrap deploy status ui export backup diff

bootstrap:
	./scripts/bootstrap.sh

deploy:
	kubectl apply -k k8s/base

status:
	kubectl -n automation get pods,pvc,svc
	@echo
	kubectl -n automation get events --sort-by=.lastTimestamp | tail -20

ui:
	kubectl -n automation port-forward svc/n8n 5678:5678

export:
	./scripts/export-workflows.sh

backup:
	./scripts/backup.sh

diff:
	kubectl diff -k k8s/base || true
