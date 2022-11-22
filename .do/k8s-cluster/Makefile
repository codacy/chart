# terraform setup
TF_RC ?= ./terraformrc
TF_EXTRA_OPTS ?= TF_IN_AUTOMATION=1 AWS_SDK_LOAD_CONFIG=1 TF_CLI_CONFIG_FILE=$(TF_RC)
TF_PARALLELISM ?= 30
TF ?= $(TF_EXTRA_OPTS) terraform
WORKSPACE ?= ${DO_TF_WORKSPACE}
VARS_FILE ?= deploy.tfvars
NGINX_INGRESS_VERSION ?= 4.2.0
CERT_MANAGER_VERSION ?= v1.9.1
K8S_VERSION ?= 1.23
DO_K8S_SLUG ?= $(shell doctl kubernetes options versions | grep $(K8S_VERSION) | awk '{print $$1}')
NODE_TYPE ?= s-8vcpu-32gb
NODES_MIN ?= 7
NODES_MAX ?= 10

.PHONY: create_terraformrc
create_terraformrc:
	@echo -e "credentials \"app.terraform.io\" { \n  token = \"$$TF_AUTH_TOKEN\" \n}" > $(TF_RC)

.PHONY: setup_vars
setup_vars:
	@echo "Appending variables to VARS_FILE..."

	@echo "digital_ocean_token = [REDACTED]"
	@echo "digital_ocean_token = \"$(DO_TOKEN)\"" > $(VARS_FILE)

	@echo "docker_username = [REDACTED]"
	@echo "docker_username = \"$(DOCKER_USERNAME)\"" >> $(VARS_FILE)

	@echo "docker_password = [REDACTED]"
	@echo "docker_password = \"$(DOCKER_PASSWORD)\"" >> $(VARS_FILE)

	@echo "k8s_version = \"$(DO_K8S_SLUG)\"" >> $(VARS_FILE)
	@echo "node_type = \"$(NODE_TYPE)\"" >> $(VARS_FILE)
	@echo "nodes_min = $(NODES_MIN)" >> $(VARS_FILE)
	@echo "nodes_max = $(NODES_MAX)" >> $(VARS_FILE)
	@echo "cluster_name = \"$(DOKS_CLUSTER_NAME)\"">> $(VARS_FILE)

.PHONY: start_cluster
start_cluster: set_cluster_context provision_cluster install_nginx install_certmanager

.PHONY: validate_cluster
validate_cluster: setup_vars create_terraformrc tf_init tf_validate

.PHONY: provision_cluster
provision_cluster: setup_vars create_terraformrc tf_init tf_validate
	$(TF) workspace select $(WORKSPACE)
	$(TF) apply -parallelism=$(TF_PARALLELISM) -var-file=$(VARS_FILE) -input=false --auto-approve
	$(TF) output -json > terraform_outputs.json

.PHONY: set_cluster_context
set_cluster_context:
	echo '1' | doctl kubernetes cluster kubeconfig save ${DOKS_CLUSTER_NAME} --set-current-context

.PHONY: install_nginx
install_nginx:
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	helm repo add stable https://charts.helm.sh/stable
	helm repo update
	helm upgrade --install nginx-ingress --version ${NGINX_INGRESS_VERSION} --namespace kube-system ingress-nginx/ingress-nginx \
	-f values/values-nginx.yaml

.PHONY: install_certmanager
install_certmanager:
	helm repo add jetstack https://charts.jetstack.io
	helm repo update
	helm upgrade --install --version ${CERT_MANAGER_VERSION} codacy-cert-manager jetstack/cert-manager \
			--namespace kube-system \
			--values values/values-cert-manager.yaml \
			--set installCRDs=true
	kubectl label namespace kube-system certmanager.k8s.io/disable-validation="true" --overwrite
	kubectl apply --namespace kube-system -f values/issuer-letsencrypt.yaml

.PHONY: destroy_cluster
destroy_cluster: setup_vars create_terraformrc set_cluster_context tf_init tf_validate
	$(TF) workspace select $(WORKSPACE)
	$(TF) destroy -parallelism=$(TF_PARALLELISM) -var-file=$(VARS_FILE) -input=false --auto-approve

.PHONY: tf_init
tf_init:
	echo '1' | $(TF) init -input=false -reconfigure

.PHONY: tf_validate
tf_validate:
	$(TF) validate
