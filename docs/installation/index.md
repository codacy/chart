# Install

Install Codacy on Kubernetes with the cloud native Codacy Helm chart.
This guide will cover the required values and common options.

Before starting, make sure you are aware of the [requirements](../requirements/index.md).

## TL;DR

Quickly install Codacy for demo without any persistence.

```bash
export SHARED_PLAY_CRYPTO_SECRET=$(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9')
echo "Store this secret: $SHARED_PLAY_CRYPTO_SECRET"
```

Create a new [secret](#secrets). This will be used by Codacy to
encrypt data before storing it in the database. Don't lose it, don't
change it.

```bash
kubectl create namespace codacy
kubectl create secret docker-registry docker-credentials --docker-username=$DOCKER_USERNAME --docker-password=$DOCKER_PASSWORD --namespace codacy

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
  --set global.codacy.backendUrl=${CODACY_URL}
```

By now all pods should be starting, but you can only access Codacy from
withing your cluster. You should either configure and
[Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
or set the service type of the `codacy-api` to LoadBalancer.

Next steps:

1.  Enable persistence
2.  Enable the Ingress
3.  Proceed to more advanced [configurations](../configuration/index.md).

## Selecting configuration options

In each section collect the options that will be combined to use with `helm install`.

### Secrets

Some secrets need to be created (eg. cryptosecret)

Also, some Codacy images are currently private. For this, you need to
create a secret in the same namespace were you will install Codacy.
You should receive these credentials together with your license.

    kubectl create secret docker-registry docker-credentials --docker-username=$DOCKER_USERNAME --docker-password=$DOCKER_PASSWORD --namespace $NAMESPACE

## Monitoring the Deployment

This will output the list of resources installed once the deployment finishes which may take 5-10 minutes.

The status of the deployment can be checked by running `helm status codacy` which can also be done while
the deployment is taking place if you run the command in another terminal.
