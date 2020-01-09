ENGINE_VERSION:=$(shell helm dependency list codacy/ | grep engine | awk '{print $$2}')

.PHONY: setup_helm_repos
setup_helm_repos:
	helm repo add codacy-stable https://charts.codacy.com/stable
	helm repo add codacy-unstable https://charts.codacy.com/unstable
	helm repo add codacy-incubator https://charts.codacy.com/incubator
	helm repo add codacy-external https://charts.codacy.com/external

.PHONY: update_worker_version
update_worker_version:
	@echo ${ENGINE_VERSION}
	ytool -f "./codacy/values.yaml" -s worker-manager.config.codacy.worker.image "${ENGINE_VERSION}" -e

.PHONY: update_dependencies
update_dependencies: setup_helm_repos update_worker_version
	helm repo update

	# we explicitly delete the lock file since there is an issue with helm 2.15
	# where if the .lock digest hasn't changed, the versions will not be updated.
	# https://github.com/helm/helm/issues/2731
	rm codacy/requirements.lock

	helm dependency update codacy/
	ls -l codacy/charts/
