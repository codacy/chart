.PHONY: setup_helm_repos
setup_helm_repos:
	doctl kubernetes cluster kubeconfig save $${DOKS_CLUSTER_NAME} --set-current-context

	helm repo add codacy-stable https://charts.codacy.com/stable
	helm repo add codacy-unstable https://charts.codacy.com/unstable
	helm repo add codacy-incubator https://charts.codacy.com/incubator


.PHONY: deploy_to_doks
deploy_to_doks: setup_helm_repos
	helm dependency update ../codacy/

	INJECT_SQL=$(cat default.sql)

	helm upgrade --install codacy ../codacy/ \
	 	-f values.yaml \
	 	--namespace codacy \
		--set global.imagePullSecrets[0].name=docker-credentials \
		--set global.play.cryptoSecret=$${SHARED_PLAY_CRYPTO_SECRET} \
		--set global.filestore.contentsSecret=$${SHARED_PLAY_CRYPTO_SECRET} \
		--set global.filestore.uuidSecret=$${SHARED_PLAY_CRYPTO_SECRET} \
		--set global.cacheSecret=$${SHARED_PLAY_CRYPTO_SECRET} \
		--set codacy-api.config.license=$${CODACY_LICENSE} \
		--set global.codacy.url="http://k8s.dev.codacy.org" \
		--set global.codacy.backendUrl="http://k8s.dev.codacy.org"
		--set postgres.initdbScripts."init\.sql"=$${INJECT_SQL}"
