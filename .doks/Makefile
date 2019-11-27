RELEASE_NAME?=codacy
NAMESPACE?=codacy

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
		--set global.codacy.url="http://k8s.dev.codacy.org" \
		--set global.codacy.backendUrl="http://k8s.dev.codacy.org"
