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
get_release_notes: create_version_file
	# Fetch updated codacy/chart tags
	git fetch --all --tags --force
	# Cleanup codacy-tools-release-notes if it exists
	if [ -d codacy-tools-release-notes ]; then rm -rf codacy-tools-release-notes; fi
	# Clone codacy/codacy-tools-release-notes and generate the changelog and release notes
	git clone git@github.com:codacy/codacy-tools-release-notes.git
	# Install dependencies
	pip3 install -r codacy-tools-release-notes/requirements.pip --user
	# Generate changelogs and release notes
	codacy-tools-release-notes/getChangelogs.sh \
		$(shell cat .version | grep -Eoh "^([0-9]+\.[0-9]+\.[0-9]+)") \
		${CURDIR}/codacy/requirements.yaml \
		${CURDIR}/codacy/requirements.lock
