.PHONY: setup_helm_repos
setup_helm_repos:
	helm repo add codacy-stable https://charts.codacy.com/stable
	helm repo add codacy-unstable https://charts.codacy.com/unstable
	helm repo add codacy-incubator https://charts.codacy.com/incubator
	helm repo add codacy-external https://charts.codacy.com/external

.PHONY: update_dependencies
update_dependencies: setup_helm_repos
	helm dependency update codacy/
	ls -l codacy/charts/
