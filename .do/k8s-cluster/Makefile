# terraform setup
TF_RC ?= ./terraformrc
TF_EXTRA_OPTS ?= TF_IN_AUTOMATION=1 AWS_SDK_LOAD_CONFIG=1 TF_CLI_CONFIG_FILE=$(TF_RC)
TF_PARALLELISM ?= 30
TF ?= $(TF_EXTRA_OPTS) terraform
NAMESPACE ?= codacy
WORKSPACE ?= ${DO_TF_WORKSPACE}
VARS_FILE ?= deploy.tfvars
NGINX_INGRESS_VERSION ?= 1.17.1
# variables
K8S_VERSION ?= 1.14
DO_K8S_SLUG ?= $(shell doctl kubernetes options versions | grep $(K8S_VERSION) | awk '{print $$1}')
NODE_TYPE ?= s-20vcpu-96gb

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
	@echo "cluster_name = \"$(DOKS_CLUSTER_NAME)\"">> $(VARS_FILE)
	@echo "main_namespace = \"$(NAMESPACE)\"">> $(VARS_FILE)

.PHONY: start_cluster
start_cluster: set_cluster_context provision_cluster helm_init_upgrade install_nginx

.PHONY: provision_cluster
provision_cluster: setup_vars create_terraformrc
	echo '1' | $(TF) init -input=false -reconfigure
	$(TF) workspace select $(WORKSPACE)
	$(TF) apply -parallelism=$(TF_PARALLELISM) -var-file=$(VARS_FILE) -input=false --auto-approve
	$(TF) output -json > terraform_outputs.json

.PHONY: set_cluster_context
set_cluster_context:
	echo '1' | doctl kubernetes cluster kubeconfig save ${DOKS_CLUSTER_NAME} --set-current-context

.PHONY: helm_init_upgrade
helm_init_upgrade:
	helm init --upgrade

.PHONY: install_nginx
install_nginx:
	helm upgrade --install nginx-ingress --version ${NGINX_INGRESS_VERSION} --namespace kube-system stable/nginx-ingress \
	--set controller.publishService.enabled=true

.PHONY: destroy_cluster
destroy_cluster: setup_vars create_terraformrc set_cluster_context
	echo '1' | $(TF) init -input=false -reconfigure
	$(TF) workspace select $(WORKSPACE)
	$(TF) destroy -parallelism=$(TF_PARALLELISM) -var-file=$(VARS_FILE) -input=false --auto-approve
