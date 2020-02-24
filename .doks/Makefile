CODACY_URL?="http://dev.k8s.dev.codacy.org"
RELEASE_NAME?="codacy"
NAMESPACE?="codacy"
HELM_REPOSITORY?=codacy-incubator
DEPLOYMENTS?=$(shell kubectl get deployments -n "${NAMESPACE}" | awk '{print $$1}' | tail -n +2 | grep -v minio)
WORKER_VERSION?=$(shell grep "engine" -A 2 ../codacy/requirements.lock | grep version | cut -d : -f 2 | tr -d '[:blank:]')

define rotate_pod
  kubectl patch deployment $(strip $(1)) -n ${NAMESPACE} -p '{"spec":{"template":{"metadata":{"annotations":{"date": "'$(shell date +'%Y-%m-%dT%H:%M:%S')'" }}}}}';
  kubectl rollout status "deployment/$(strip $(1))" -n ${NAMESPACE} --watch --timeout=30m;
endef

define call_helm_install
	helm upgrade --install ${1} ${3} \
	--atomic \
	--timeout=1800 \
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
	--set global.codacy.backendUrl=${4} \
	--set listener.nfsserverprovisioner.storageClass.name="${1}-listener-cache-class" \
	--set global.features.cloneSubmodules=true \
	--set global.bitbucketEnterprise.consumerPublicKey=$${BITBUCKET_ENTERPRISE_PUBLIC_KEY} \
	--set global.bitbucketEnterprise.consumerPrivateKey=$${BITBUCKET_ENTERPRISE_PRIVATE_KEY} \
	--set worker-manager.config.codacy.worker.image=${5}

  $(foreach DEPLOYMENT, $(DEPLOYMENTS),$(call rotate_pod, $(DEPLOYMENT)))
endef

.PHONY: setup_helm_repos
setup_helm_repos:
	$(MAKE) -C ../ setup_helm_repos

.PHONY: helm_install_from_local_dir
helm_install_from_local_dir:
	$(call call_helm_install,${RELEASE_NAME},${NAMESPACE},../codacy/,${CODACY_URL},${WORKER_VERSION})

.PHONY: helm_install_from_chart_museum
helm_install_from_chart_museum:
	$(call call_helm_install,${RELEASE_NAME},${NAMESPACE},${HELM_REPOSITORY}/codacy --version ${VERSION},${CODACY_URL},${WORKER_VERSION})

.PHONY: update_dependencies
update_dependencies:
	$(MAKE) -C ../ update_dependencies

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
