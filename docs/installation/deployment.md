# Deployment Guide

Before running `helm install`, you need to make some decisions about how you will run Codacy.
Options can be specified using helm's `--set option.name=value` command line option.
A complete list of command line options can be found [here](./command-line-options.md).
This guide will cover required values and common options.

## TL;DR

Quickly install Codacy for demo without any persistence.

```
kubectl create namespace codacy
kubectl create secret docker-registry docker-credentials --docker-username=$DOCKER_USERNAME --docker-password=$DOCKER_PASSWORD --namespace codacy

export SHARED_PLAY_CRYPTO_SECRET=$(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9')
echo "Store this secret: $SHARED_PLAY_CRYPTO_SECRET"

export CODACY_URL="http://codacy.example.com"

helm repo add codacy-stable https://charts.codacy.com/stable/
helm repo update
helm upgrade --install codacy codacy-stable/codacy \
  --namespace codacy \
  --set global.imagePullSecrets[0].name=docker-credentials \
  --set global.play.cryptoSecret=${SHARED_PLAY_CRYPTO_SECRET} \
  --set global.filestore.contentsSecret=${SHARED_PLAY_CRYPTO_SECRET} \
  --set global.filestore.uuidSecret=${SHARED_PLAY_CRYPTO_SECRET} \
  --set global.cacheSecret=${SHARED_PLAY_CRYPTO_SECRET} \
  --set global.codacy.url=${CODACY_URL} \
  --set global.codacy.backendUrl=${CODACY_URL} \
  --set codacy-api.service.type="LoadBalancer"
```

If you want to enable persistence please config

## Selecting configuration options

In each section collect the options that will be combined to use with `helm install`.

### Secrets

There are some secrets that need to be created (eg. cryptosecret)

Also, some Codacy images are currently private. For this, you need to
create a secret in the same namespace were you will install Codacy.
You should receive these credentials together with your license.

```
kubectl create secret docker-registry docker-credentials --docker-username=$DOCKER_USERNAME --docker-password=$DOCKER_PASSWORD --namespace $NAMESPACE
```

## Monitoring the Deployment

This will output the list of resources installed once the deployment finishes which may take 5-10 minutes.

The status of the deployment can be checked by running `helm status codacy` which can also be done while
the deployment is taking place if you run the command in another terminal.
