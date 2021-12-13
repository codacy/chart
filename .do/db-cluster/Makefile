# terraform setup
TF_RC ?= ./terraformrc
TF_EXTRA_OPTS ?= TF_IN_AUTOMATION=1 AWS_SDK_LOAD_CONFIG=1 TF_CLI_CONFIG_FILE=$(TF_RC)
TF_PARALLELISM ?= 30
TF ?= $(TF_EXTRA_OPTS) terraform
WORKSPACE_PREFIX ?= postgres
VARS_FILE ?= deploy.tfvars
K8S_CLUSTER_REGION ?= fra1
K8S_CLUSTER_ID ?= $(shell cat ../k8s-cluster/terraform_outputs.json | jq -r '.cluster_id.value')
INSTANCE_TYPE ?= db-s-6vcpu-16gb
ENVIRONMENT ?= dev

.PHONY: create_terraformrc
create_terraformrc:
	@echo -e "credentials \"app.terraform.io\" { \n  token = \"$$TF_AUTH_TOKEN\" \n}" > $(TF_RC)

.PHONY: setup_vars
setup_vars:
	@echo "Appending variables to VARS_FILE..."

	@echo "digital_ocean_token = \"$(DO_TOKEN)\"" > $(VARS_FILE)
	@echo "region = \"$(K8S_CLUSTER_REGION)\"" >> $(VARS_FILE)
	@echo "k8s_cluster_id = \"$(K8S_CLUSTER_ID)\"" >> $(VARS_FILE)
	@echo "postgres_instance_type = \"$(INSTANCE_TYPE)\"" >> $(VARS_FILE)
	@echo "environment = \"$(ENVIRONMENT)\"" >> $(VARS_FILE)

.PHONY: start_cluster
start_cluster: initialize_terrafom terraform_logistics save_outputs replace_db_values
	echo "DB cluster(s) provisioned."

.PHONY: destroy_cluster
destroy_cluster: initialize_terrafom
	$(TF) destroy -parallelism=$(TF_PARALLELISM) -var-file=$(VARS_FILE) -input=false --auto-approve

.PHONY: initialize_terrafom
initialize_terrafom: setup_vars create_terraformrc tf_init tf_validate
	$(TF) workspace select $(WORKSPACE_PREFIX)-$(ENVIRONMENT)

.PHONY: terraform_logistics
terraform_logistics:
	$(TF) apply -parallelism=$(TF_PARALLELISM) -var-file=$(VARS_FILE) -input=false --auto-approve

.PHONY: save_outputs
save_outputs:
	$(TF) output -json > terraform_outputs.json

.PHONY: replace_db_values
replace_db_values:
	$(eval host=$(shell cat terraform_outputs.json | jq -r '.db_cluster_host | .value'))
	$(eval port=$(shell cat terraform_outputs.json | jq -r '.db_cluster_port | .value'))
	$(eval username=$(shell cat terraform_outputs.json | jq -r '.db_cluster_username | .value'))
	$(eval password=$(shell cat terraform_outputs.json | jq -r '.db_cluster_password | .value'))
	@echo "DB Host: ${host}"
	@sed -i "s/<--- codacy-db-username --->/$(username)/g; s/<--- codacy-db-password --->/$(password)/g; s/<--- codacy-db-host --->/$(host)/g; s/<--- codacy-db-port --->/$(port)/g;" ../../codacy/values-production.yaml
	@sed -i "s/postgresqlDatabase: crow/postgresqlDatabase: \"crow?sslmode=require\"/g" ../../codacy/values-production.yaml
	@sed -i "s/<--- codacy-db-username --->/$(username)/g; s/<--- codacy-db-password --->/$(password)/g; s/<--- codacy-db-host --->/$(host)/g; s/<--- codacy-db-port --->/$(port)/g;" ../values.yaml
	@sed -i "s/postgresqlDatabase: crow/postgresqlDatabase: \"crow?sslmode=require\"/g" ../values.yaml
	@echo "Replaced template values for db connections"

.PHONY: tf_init
tf_init:
	echo '1' | $(TF) init -input=false -reconfigure

.PHONY: tf_validate
tf_validate:
	$(TF) validate