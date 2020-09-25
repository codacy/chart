CODACY_URL?="https://dev.k8s.dev.codacy.org"
GRAFANA_URL?="https://grafana.k8s.dev.codacy.org"
RELEASE_NAME?="codacy"
NAMESPACE?="codacy"
HELM_REPOSITORY?=codacy-incubator
DEPLOYMENTS?=$(shell kubectl get deployments -n "${NAMESPACE}" | awk '{print $$1}' | tail -n +2 | grep -v minio)
WORKER_VERSION?=$(shell grep "engine" -A 2 ../codacy/requirements.lock | grep version | cut -d : -f 2 | tr -d '[:blank:]')
HELM_INSTALL_EXTRA_FLAGS ?= ""
SHELL := /bin/bash # we need this for the extra args in `call_helm_install`
ENVIRONMENT?=dev

define rotate_pod
  kubectl patch deployment $(strip $(1)) -n $(2) -p '{"spec":{"template":{"metadata":{"annotations":{"date": "'$(shell date +'%Y-%m-%dT%H:%M:%S')'" }}}}}';
  kubectl rollout status "deployment/$(strip $(1))" -n $(2) --watch --timeout=10m &
endef

define call_helm_install
	eval "extra_args=($$HELM_INSTALL_EXTRA_FLAGS)"; \
	helm upgrade --install ${1} ${3} \
	--atomic \
	--timeout=900s \
	-f ../codacy/values-production.yaml \
	-f values.yaml \
	--namespace ${2} \
	--set global.imagePullSecrets[0].name=docker-credentials \
	--set global.play.cryptoSecret=$${SHARED_PLAY_CRYPTO_SECRET} \
	--set global.akka.sessionSecret=$${SHARED_AKKA_SESSION_SECRET} \
	--set global.filestore.contentsSecret=$${SHARED_PLAY_CRYPTO_SECRET} \
	--set global.filestore.uuidSecret=$${SHARED_PLAY_CRYPTO_SECRET} \
	--set global.cacheSecret=$${SHARED_PLAY_CRYPTO_SECRET} \
	--set codacy-api.config.license=$${CODACY_LICENSE} \
	--set global.codacy.url=${4} \
	--set global.codacy.crow.url=${4}/monitoring \
	--set global.codacy.backendUrl=${4} \
	--set listener.nfsserverprovisioner.storageClass.name="${1}-listener-cache-class" \
	--set global.features.cloneSubmodules=true \
	--set global.workerManager.workers.config.imageVersion=${5} \
	--set global.crow.config.passwordAuth.password=$${CROW_PASSWORD} \
	"$${extra_args[@]}"

  $(foreach DEPLOYMENT, $(DEPLOYMENTS),$(call rotate_pod, $(DEPLOYMENT), $(NAMESPACE)))
endef

define call_helm_install_infrastructure
	eval "extra_args=($$HELM_INSTALL_EXTRA_FLAGS)"; \
	helm upgrade --install ${1} ${3} \
	--atomic \
	--timeout=600s \
	-f ../codacy/values-production.yaml \
	-f values.yaml \
	--namespace ${2} \
	--set codacy-ingress.create=false \
	--set portal.create=false \
	--set ragnaros.create=false \
	--set activities.create=false \
	--set remote-provider-service.create=false \
	--set hotspots-api.create=false \
	--set hotspots-worker.create=false \
	--set listener.create=false \
	--set engine.create=false \
	--set codacy-tools.create=false \
	--set codacy-api.create=false \
	--set worker-manager.create=false \
	--set crow.create=false \
	--set codacy-spa.create=false
endef

.PHONY: setup_helm_repos
setup_helm_repos:
	$(MAKE) -C ../ setup_helm_repos

.PHONY: helm_install_infrastructure
helm_install_infrastructure:
	$(call call_helm_install_infrastructure,${RELEASE_NAME},${NAMESPACE},../codacy/,${CODACY_URL},${WORKER_VERSION},${ENVIRONMENT})

.PHONY: helm_install_from_local_dir
helm_install_from_local_dir: update_ingress_values
	$(call call_helm_install,${RELEASE_NAME},${NAMESPACE},../codacy/,${CODACY_URL},${WORKER_VERSION},${ENVIRONMENT})

.PHONY: helm_install_from_chart_museum
helm_install_from_chart_museum: update_ingress_values
	$(call call_helm_install,${RELEASE_NAME},${NAMESPACE},${HELM_REPOSITORY}/codacy --version ${VERSION},${CODACY_URL},${WORKER_VERSION},${ENVIRONMENT})

.PHONY: update_dependencies
update_dependencies:
	$(MAKE) -C ../ update_dependencies

.PHONY: update_ingress_values
update_ingress_values:
	sed -i "s#<codacy-app.dns.internal>#${CODACY_URL}#g; s#<codacy-api.dns.internal>#${CODACY_URL}#g; s#https://##g" values.yaml
	sed -i "s#<environment>#${NAMESPACE}#g" values.yaml

.PHONY: deploy_to_doks_infrastructure
deploy_to_doks_infrastructure: set_cluster_context update_dependencies helm_install_infrastructure

.PHONY: deploy_to_doks_from_local_dir
deploy_to_doks_from_local_dir: set_cluster_context update_dependencies helm_install_from_local_dir

.PHONY: deploy_to_doks_from_chartmuseum
deploy_to_doks_from_chartmuseum: set_cluster_context setup_helm_repos helm_install_from_chart_museum

.PHONY: set_cluster_context
set_cluster_context:
	doctl kubernetes cluster kubeconfig save ${DOKS_CLUSTER_NAME} --set-current-context

.PHONY: remove_codacy
remove_codacy: set_cluster_context
	helm delete --purge ${RELEASE_NAME}
	kubectl delete pods -n ${NAMESPACE} $(shell kubectl get pods -n ${NAMESPACE} -o jsonpath='{.items[*].metadata.name}') --force --grace-period=0 --ignore-not-found=true &
	kubectl delete pvc -n ${NAMESPACE} $(shell kubectl get pvc -n ${NAMESPACE} -o jsonpath='{.items[*].metadata.name}') --force --ignore-not-found=true
	kubectl delete jobs -n ${NAMESPACE} $(shell kubectl get jobs -n ${NAMESPACE} -o jsonpath='{.items[*].metadata.name}') --force --ignore-not-found=true --all=true
	kubectl delete secret -n ${NAMESPACE} docker-credentials

.PHONY: deploy_monitoring
deploy_monitoring: set_cluster_context
	kubectl apply -f "https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml"
	kubectl apply -f "https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml"
	kubectl apply -f "https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml"
	kubectl apply -f "https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml"
	kubectl apply -f "https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml"
	kubectl apply -f "https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml"

	helm repo add loki https://grafana.github.io/loki/charts
	-kubectl create namespace monitoring

	helm upgrade --install --atomic --timeout 600s loki loki/loki \
	  --version 0.28.1 --namespace monitoring --values ../docs/values-files/values-loki.yaml

	helm upgrade --install --atomic --timeout 600s promtail loki/promtail \
	  --version 0.22.2 --namespace monitoring --values ../docs/values-files/values-promtail.yaml

	@sed -i "s#<--- slack-api-url --->#$$SLACK_API_URL_ALERTS_SELFHOSTED#g;" values-prometheus-operator.yaml
	@sed -i "s/<--- slack-channel --->/$$SLACK_ALERTS_SELFHOSTED_CHANNEL/g;" values-prometheus-operator.yaml
	@sed -i "s#<--- grafana url --->#${GRAFANA_URL}#g; s#https://##g" ../docs/values-files/values-prometheus-operator.yaml

	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update

	helm upgrade --install --atomic --timeout 600s monitoring  prometheus-community/kube-prometheus-stack \
	  --version 9.4.3 --namespace monitoring --values ../docs/values-files/values-prometheus-operator.yaml --values values-prometheus-operator.yaml\
	  --set grafana.adminPassword=$$GRAFANA_ADMIN_PASSWORD \
	  --set grafana.ingress.hosts='{grafana.k8s.dev.codacy.org}' \
	  --set alertmanager.ingress.hosts='{alerts.k8s.dev.codacy.org}' \
	  --set prometheus.ingress.hosts='{prometheus.k8s.dev.codacy.org}'

	kubectl rollout restart deployment -n monitoring $(shell kubectl get deployments -n monitoring -o jsonpath='{.items[*].metadata.name}')
	kubectl rollout restart statefulset -n monitoring $(shell kubectl get statefulsets -n monitoring -o jsonpath='{.items[*].metadata.name}')
	kubectl rollout restart daemonset -n monitoring $(shell kubectl get daemonsets -n monitoring -o jsonpath='{.items[*].metadata.name}')

