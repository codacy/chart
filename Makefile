.PHONY: setup_helm_repos
setup_helm_repos:
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo add stable https://charts.helm.sh/stable
	helm repo add codacy-stable https://charts.codacy.com/stable
	helm repo add codacy-unstable https://charts.codacy.com/unstable
	helm repo add codacy-incubator https://charts.codacy.com/incubator
	helm repo add codacy-external https://charts.codacy.com/external
	helm repo update

.PHONY: create_version_file
create_version_file:
	@if [ ! -e .version ]; \
	then echo "Creating .version file based on the most recent tag..."; \
	git tag --sort creatordate | grep -E "^([0-9]+\.[0-9]+\.[0-9]+)-RC.*" | tail -n -1 > .version; \
	cat .version; \
	else echo ".version file already exists..."; \
	fi

.PHONY: update_internals_versions
update_internals_versions:
	$(eval ENGINE_VERSION=$(shell grep "engine" -A 2 codacy/requirements.lock | grep version | cut -d : -f 2 | tr -d '[:blank:]'))
	@echo "Engine version: ${ENGINE_VERSION}"
	ytool -f "./codacy/values.yaml" -s global.workerManager.workers.config.imageVersion "${ENGINE_VERSION}" -e

.PHONY: update_docs_versions
update_docs_versions:
	$(eval CODACY_VERSION_NUMBER=$(shell sed -e 's/.*/v&/g' .version || echo "development"))
	$(eval DOCUMENTATION_VERSION_NUMBER=$(shell sed -e 's/.*/v&/g' .version | grep -Eoh "^v([0-9]+\.[0-9]+)" || echo "development"))
	@echo "Codacy version: ${CODACY_VERSION_NUMBER}"
	@echo "Documentation version: ${DOCUMENTATION_VERSION_NUMBER}"
	ytool -f "./codacy/values.yaml" -s global.codacy.installation.version "${CODACY_VERSION_NUMBER}" -e
	ytool -f "./codacy/values.yaml" -s global.codacy.documentation.version "${DOCUMENTATION_VERSION_NUMBER}" -e

.PHONY: helm_dep_up
helm_dep_up:
	helm dependency update codacy/
	ls -l codacy/charts/

.PHONY: update_dependencies
update_dependencies: setup_helm_repos helm_dep_up update_internals_versions update_docs_versions

.PHONY: get_release_notes
get_release_notes:
	# Obtain current and previous chart versions from the chart release branches
	$(eval VERSION_NEW=$(shell git branch --remote --sort version:refname | grep -Eo "release-[0-9]+\.[0-9]+\.[0-9]+$$" | tail -n 1 | cut -d - -f 2))
	$(eval VERSION_OLD=$(shell git branch --remote --sort version:refname | grep -Eo "release-[0-9]+\.[0-9]+\.[0-9]+$$" | tail -n 2 | head -n 1 | cut -d - -f 2))
	if [ -z "${VERSION_NEW}" ] || [ -z "${VERSION_OLD}" ]; then echo "Can't find the current or previous chart version from the release branches."; exit 1; fi
	# Clone codacy/release-notes-tools
	if [ -d release-notes-tools ]; then rm -rf release-notes-tools; fi
	git clone git@github.com:codacy/release-notes-tools.git
	# Fetch updated codacy/chart tags
	git fetch --all --tags --force
	# Generate release notes and create pull request on codacy/docs
	release-notes-tools/run.sh selfhosted ${VERSION_NEW} ${VERSION_OLD} --push
