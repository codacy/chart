CODACY_URL?="http://k8s.dev.codacy.org"
RELEASE_NAME?="codacy"
NAMESPACE?="codacy"
HELM_REPOSITORY?=codacy-incubator
DEPLOYMENTS=$(shell kubectl get deployments -n "${NAMESPACE}" | awk '{print $$1}' | tail -n +2 | grep -v minio)

.PHONY: deploy_to_doks
deploy_to_doks: set_cluster_context
	$(MAKE) -C ../ update_dependencies
	helm upgrade --install ${RELEASE_NAME} ../codacy/ \
		-f values.yaml \
		--namespace ${NAMESPACE} \
		--set global.imagePullSecrets[0].name=docker-credentials \
		--set global.play.cryptoSecret=$${SHARED_PLAY_CRYPTO_SECRET} \
		--set global.filestore.contentsSecret=$${SHARED_PLAY_CRYPTO_SECRET} \
		--set global.filestore.uuidSecret=$${SHARED_PLAY_CRYPTO_SECRET} \
		--set global.cacheSecret=$${SHARED_PLAY_CRYPTO_SECRET} \
		--set codacy-api.config.license=$${CODACY_LICENSE} \
		--set global.codacy.url=${CODACY_URL} \
		--set global.codacy.backendUrl=${CODACY_URL} \
		--set listener.nfsserverprovisioner.storageClass.name="${RELEASE_NAME}-listener-cache-class" \
		--set global.features.cloneSubmodules=true

.PHONY: deploy_to_doks_from_chartmuseum
deploy_to_doks_from_chartmuseum: set_cluster_context
	$(MAKE) -C ../ setup_helm_repos
	helm repo update
	helm upgrade --install ${RELEASE_NAME} ${HELM_REPOSITORY}/codacy \
		-f values.yaml \
		--version ${VERSION} \
		--namespace ${NAMESPACE} \
		--set global.imagePullSecrets[0].name=docker-credentials \
		--set global.play.cryptoSecret=$${SHARED_PLAY_CRYPTO_SECRET} \
		--set global.filestore.contentsSecret=$${SHARED_PLAY_CRYPTO_SECRET} \
		--set global.filestore.uuidSecret=$${SHARED_PLAY_CRYPTO_SECRET} \
		--set global.cacheSecret=$${SHARED_PLAY_CRYPTO_SECRET} \
		--set codacy-api.config.license=$${CODACY_LICENSE} \
		--set global.codacy.url=${CODACY_URL} \
		--set global.codacy.backendUrl=${CODACY_URL} \
		--set listener.nfsserverprovisioner.storageClass.name="${RELEASE_NAME}-listener-cache-class" \
		--set global.features.cloneSubmodules=true

define rotate_pod
kubectl patch deployment $(strip $(1)) -n ${NAMESPACE} -p '{"spec":{"template":{"metadata":{"annotations":{"date": "'$(shell date +'%Y-%m-%dT%H:%M:%S')'" }}}}}';
kubectl rollout status "deployment/$(strip $(1))" -n ${NAMESPACE} --watch --timeout=30m;
endef

.PHONY: rotate_pods
rotate_pods: set_cluster_context
	$(foreach DEPLOYMENT, $(DEPLOYMENTS),$(call rotate_pod, $(DEPLOYMENT)))

.PHONY: set_cluster_context
set_cluster_context:
	echo '1' | doctl kubernetes cluster kubeconfig save ${DOKS_CLUSTER_NAME} --set-current-context

.PHONY: remove_codacy
remove_codacy: set_cluster_context
	helm delete --purge ${RELEASE_NAME}
	kubectl delete pods -n ${NAMESPACE} $(shell kubectl get pods -n ${NAMESPACE} -o jsonpath='{.items[*].metadata.name}') --force --grace-period=0 --ignore-not-found=true &
	kubectl delete pvc -n ${NAMESPACE} $(shell kubectl get pvc -n ${NAMESPACE} -o jsonpath='{.items[*].metadata.name}') --force --ignore-not-found=true
	kubectl delete jobs -n ${NAMESPACE} $(shell kubectl get jobs -n ${NAMESPACE} -o jsonpath='{.items[*].metadata.name}') --force --ignore-not-found=true --all=true
	kubectl delete secret -n ${NAMESPACE} docker-credentials
