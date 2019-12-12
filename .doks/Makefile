CODACY_URL?="http://k8s.dev.codacy.org"
RELEASE_NAME?="codacy"
NAMESPACE?="codacy"

.PHONY: deploy_to_doks
deploy_to_doks:
	doctl kubernetes cluster kubeconfig save $${DOKS_CLUSTER_NAME} --set-current-context

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
		--set listener.nfsserverprovisioner.storageClass.name="${RELEASE_NAME}-listener-cache-class"

.PHONY: set_cluster_context
set_cluster_context: 
	echo '1' | doctl kubernetes cluster kubeconfig save ${DOKS_CLUSTER_NAME} --set-current-context

.PHONY: remove_codacy
remove_codacy: set_cluster_context
	set +e; helm delete --purge ${RELEASE_NAME}; set -e;
	kubectl delete pods -n ${NAMESPACE} $(shell kubectl get pods -n ${NAMESPACE} -o jsonpath='{.items[*].metadata.name}') --force --grace-period=0 --ignore-not-found=true &
	kubectl delete pvc -n ${NAMESPACE} $(shell kubectl get pvc -n ${NAMESPACE} -o jsonpath='{.items[*].metadata.name}') --force --ignore-not-found=true 
	kubectl delete jobs -n ${NAMESPACE} $(shell kubectl get jobs -n ${NAMESPACE} -o jsonpath='{.items[*].metadata.name}') --force --ignore-not-found=true --all=true
	set +e; kubectl delete secret -n ${NAMESPACE} docker-credentials; set -e;
