CODACY_VERSION_NUMBER?=$(shell cat .version || echo "development")
DOCUMENTATION_VERSION_NUMBER?=$(shell cat .version | grep -Eoh "^([0-9]+\.[0-9]+)" || echo "development")

.PHONY: setup_helm_repos
setup_helm_repos:
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo add stable https://kubernetes-charts.storage.googleapis.com
	helm repo add codacy-stable https://charts.codacy.com/stable
	helm repo add codacy-unstable https://charts.codacy.com/unstable
	helm repo add codacy-incubator https://charts.codacy.com/incubator
	helm repo add codacy-external https://charts.codacy.com/external
	helm repo update

.PHONY: update_versions
update_versions:
	$(eval ENGINE_VERSION=$(shell grep "engine" -A 2 codacy/requirements.lock | grep version | cut -d : -f 2 | tr -d '[:blank:]'))
	@echo ${ENGINE_VERSION}
	# Values used by codacy-api
	ytool -f "./codacy/values.yaml" -s global.codacy.installation.version "v${CODACY_VERSION_NUMBER}" -e
	ytool -f "./codacy/values.yaml" -s global.codacy.documentation.version "v${DOCUMENTATION_VERSION_NUMBER}" -e
	ytool -f "./codacy/values.yaml" -s global.workerManager.workers.config.imageVersion "${ENGINE_VERSION}" -e

.PHONY: helm_dep_up
helm_dep_up:
	helm dependency update codacy/
	ls -l codacy/charts/

.PHONY: update_dependencies
update_dependencies: setup_helm_repos helm_dep_up update_versions
