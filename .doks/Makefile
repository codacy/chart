RELEASE_NAME?=codacy
NAMESPACE?=codacy

.PHONY: install_codacy
install_codacy:
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
		--set global.codacy.url="http://k8s.dev.codacy.org" \
		--set global.codacy.backendUrl="http://k8s.dev.codacy.org"

.PHONY: remove_codacy
remove_codacy: set_cluster_context
	helm delete --purge ${RELEASE} | exit 0
	kubectl delete jobs -n ${NAMESPACE} $(shell kubectl get jobs -n ${NAMESPACE} -o jsonpath='{.items[*].metadata.name}') &
	kubectl delete pvc -n ${NAMESPACE} $(shell kubectl get pvc -n ${NAMESPACE} -o jsonpath='{.items[*].metadata.name}') &
	kubectl delete pods -n ${NAMESPACE} $(shell kubectl get pods -n ${NAMESPACE} -o jsonpath='{.items[*].metadata.name}') --force --grace-period=0 --ignore-not-found=true &
