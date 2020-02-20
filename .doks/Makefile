CODACY_URL?="http://k8s.dev.codacy.org"
RELEASE_NAME?="codacy"
NAMESPACE?="codacy"
HELM_REPOSITORY?=codacy-incubator
DEPLOYMENTS?=$(shell kubectl get deployments -n "${NAMESPACE}" | awk '{print $$1}' | tail -n +2 | grep -v minio)

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
	--set global.bitbucketenterprise.consumerPublicKey=$${BITBUCKET_ENTERPRISE_PUBLIC_KEY} \
	--set global.bitbucketenterprise.consumerPrivateKey=$${BITBUCKET_ENTERPRISE_PRIVATE_KEY}

  $(foreach DEPLOYMENT, $(DEPLOYMENTS),$(call rotate_pod, $(DEPLOYMENT)))
endef

.PHONY: deploy_to_doks
deploy_to_doks: set_cluster_context
	$(MAKE) -C ../ update_dependencies
	$(call call_helm_install,${RELEASE_NAME},${NAMESPACE},../codacy/,${CODACY_URL})

.PHONY: deploy_to_doks_atomic
deploy_to_doks_atomic:
	$(call call_helm_install,${RELEASE_NAME},${NAMESPACE},../codacy/,${CODACY_URL})

.PHONY: deploy_to_doks_from_chartmuseum
deploy_to_doks_from_chartmuseum: set_cluster_context
	$(MAKE) -C ../ setup_helm_repos
	helm repo update
	$(call call_helm_install,${RELEASE_NAME},${NAMESPACE},${HELM_REPOSITORY}/codacy --version ${VERSION},${CODACY_URL})

define rotate_pod
  kubectl patch deployment $(strip $(1)) -n ${NAMESPACE} -p '{"spec":{"template":{"metadata":{"annotations":{"date": "'$(shell date +'%Y-%m-%dT%H:%M:%S')'" }}}}}';
  kubectl rollout status "deployment/$(strip $(1))" -n ${NAMESPACE} --watch --timeout=30m;
endef

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
