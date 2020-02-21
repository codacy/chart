# terraform setup
TF_RC ?= ./terraformrc
TF_EXTRA_OPTS ?= TF_IN_AUTOMATION=1 AWS_SDK_LOAD_CONFIG=1 TF_CLI_CONFIG_FILE=$(TF_RC)
TF_PARALLELISM ?= 30
TF ?= $(TF_EXTRA_OPTS) terraform
WORKSPACE ?= ${DO_TF_WORKSPACE}
VARS_FILE ?= deploy.tfvars

# variables
K8S_VERSION ?= 1.15
DO_K8S_SLUG ?= $(shell doctl kubernetes options versions | grep $(K8S_VERSION) | awk '{print $$1}')
NODE_TYPE ?= s-6vcpu-16gb
NUM_NODES ?= 4

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

	echo "k8s_version = \"$(DO_K8S_SLUG)\"" >> $(VARS_FILE)
	echo "node_type = \"$(NODE_TYPE)\"" >> $(VARS_FILE)
	echo "num_nodes = $(NUM_NODES)" >> $(VARS_FILE)
	echo "cluster_name = \"$(DOKS_CLUSTER_NAME)\"">> $(VARS_FILE)

.PHONY: set_cluster_context
set_cluster_context:
	echo '1' | doctl kubernetes cluster kubeconfig save ${DOKS_CLUSTER_NAME} --set-current-context

.PHONY: start_cluster
start_cluster: cluster helm_init_upgrade

.PHONY: cluster
cluster: setup_vars create_terraformrc
	echo '1' | $(TF) init -input=false -reconfigure
	$(TF) workspace select $(WORKSPACE)
	$(TF) apply -parallelism=$(TF_PARALLELISM) -var-file=$(VARS_FILE) -input=false --auto-approve
	$(TF) apply -parallelism=$(TF_PARALLELISM) -var-file=$(VARS_FILE) -input=false -var='cluster_only=false' --auto-approve

.PHONY: destroy_cluster
destroy_cluster: setup_vars create_terraformrc set_cluster_context
	echo '1' | $(TF) init -input=false -reconfigure
	$(TF) workspace select $(WORKSPACE)
	$(TF) destroy -parallelism=$(TF_PARALLELISM) -var-file=$(VARS_FILE) -input=false --auto-approve

.PHONY: helm_init_upgrade
helm_init_upgrade:
	$(shell helm init --upgrade)
