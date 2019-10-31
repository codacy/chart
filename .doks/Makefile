.PHONY: deploy_to_doks
deploy_to_doks:
	doctl kubernetes cluster kubeconfig save $${DOKS_CLUSTER_NAME} --set-current-context

	helm repo add codacy-stable https://charts.codacy.com/stable
	helm repo add codacy-unstable https://charts.codacy.com/unstable
	helm repo add codacy-incubator https://charts.codacy.com/incubator

	helm dependency update ../codacy/

	helm upgrade --install --namespace codacy codacy ../codacy/ \
		--set global.imagePullSecrets[0].name=docker-credentials \
		--set portal.config.play.cryptoSecret=$${SHARED_PLAY_CRYPTO_SECRET} \
		--set ragnaros.config.play.cryptoSecret=$${SHARED_PLAY_CRYPTO_SECRET} \
		--set activities.config.play.cryptoSecret=$${ACTIVITIES_PLAY_CRYPTO_SECRET} \
		--set hotspots-api.config.play.cryptoSecret=$${HOTSPOTS_API_PLAY_CRYPTO_SECRET} \
		--set hotspots-worker.config.play.cryptoSecret=$${HOTSPOTS_WORKER_PLAY_CRYPTO_SECRET} \
		--set engine.config.play.cryptoSecret=$${SHARED_PLAY_CRYPTO_SECRET} \
		--set core.config.play.cryptoSecret=$${SHARED_PLAY_CRYPTO_SECRET} \
		--set listener.config.play.cryptoSecret=$${SHARED_PLAY_CRYPTO_SECRET} \
		--set codacy-api.config.play.cryptoSecret=$${SHARED_PLAY_CRYPTO_SECRET}
		--set codacy-api.config.license=$${CODACY_LICENSE}
	# Generate one with head -c 128 /dev/urandom | base64
