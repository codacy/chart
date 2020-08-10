.PHONY: setup_helm_repos
setup_helm_repos:
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo add stable https://kubernetes-charts.storage.googleapis.com
	helm repo add codacy-stable https://charts.codacy.com/stable
	helm repo add codacy-unstable https://charts.codacy.com/unstable
	helm repo add codacy-incubator https://charts.codacy.com/incubator
	helm repo add codacy-external https://charts.codacy.com/external
	helm repo update

.PHONY: update_worker_version
update_worker_version:
	$(eval ENGINE_VERSION=$(shell grep "engine" -A 2 codacy/requirements.lock | grep version | cut -d : -f 2 | tr -d '[:blank:]'))
	@echo ${ENGINE_VERSION}
	ytool -f "./codacy/values.yaml" -s worker-manager.config.codacy.worker.imageVersion "${ENGINE_VERSION}" -e

.PHONY: helm_dep_up
helm_dep_up:
	helm dependency update codacy/
	ls -l codacy/charts/

.PHONY: update_dependencies
update_dependencies: setup_helm_repos helm_dep_up update_worker_version
