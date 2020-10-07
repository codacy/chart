RELEASE_VERSION_NUMBER?=$(shell sed -e 's/.*/v&/g' .version | cut -d- -f 1 || echo "development")
DOCUMENTATION_VERSION_NUMBER?=$(shell sed -e 's/.*/v&/g' .version | grep -Eoh "^v([0-9]+\.[0-9]+)" || echo "development")

.PHONY: setup_version_from_git_tag
setup_version_from_git_tag:
	git tag --sort creatordate | grep -E "^([0-9]+\.[0-9]+\.[0-9]+)-RC.*" | tail -n -1 > .version

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
	@echo ${RELEASE_VERSION_NUMBER}
	# Values used by codacy-api
	ytool -f "./codacy/values.yaml" -s global.codacy.installation.version "${RELEASE_VERSION_NUMBER}" -e
	ytool -f "./codacy/values.yaml" -s global.codacy.documentation.version "${DOCUMENTATION_VERSION_NUMBER}" -e
	ytool -f "./codacy/values.yaml" -s global.workerManager.workers.config.imageVersion "${ENGINE_VERSION}" -e

.PHONY: helm_dep_up
helm_dep_up:
	helm dependency update codacy/
	ls -l codacy/charts/

.PHONY: update_dependencies
update_dependencies: setup_helm_repos helm_dep_up update_versions

.PHONY: prepare_release
prepare_release: setup_version_from_git_tag update_dependencies

.PHONY: get_release_notes
get_release_notes: setup_helm_repos helm_dep_up
	git fetch --all --tags
	git clone git@github.com:codacy/release-notes-tools.git
	pip3 install -r release-notes-tools/requirements.pip --user
	changelogs/getChangelogs.sh
	rm -rf release-notes-tools
