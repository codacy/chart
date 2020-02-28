# Installing Codacy on microk8s

## Pre-requisites

* a machine running Ubuntu 18.04 LTS version.
  * Further versions might work but we recommend using an LTS release.
* a remote session (ssh) onto your machine of choice.

## Concepts

### Helm and tiller

Two executables will get installed onto the machine as part of this process: `helm` and `tiller`. The former is responsible for resolving the configuration of the chart to be installed, while issuing the correct install commands onto the cluster. The latter is responsible for receiving the install commands issued by `helm`, as well as managing the lifecycle of the components that have been installed. `helm` is the client facing side, while `tiller` is the server/cluster facing side.

## Cookbook

Assuming that you are starting from a blank slate, the first step is to install microk8s. Otherwise, please jump on to the [Configuring microk8s](###Configuring-microk8s) section.

### Installing microk8s

You can follow the official documentation on how to [install microk8s](https://microk8s.io/docs/). However, because we were running off of an AWS EC2 instance, we had do the following steps becore installing microk8s:

1. Make sure the machine is up to date and also has the `nfs-common` package installed: `apt update && apt install nfs-common -y`.
2. We must run configure the instance's list of hosts with localhost. This was because our machine was in fact an AWS EC2 instance, and therefore we must allow the correct resolution of the local microk8s cluster on the kubeconfig. We did so by running `sed -i -e "1s/127.0.0.1 localhost.*/127.0.0.1 localhost $(hostname)/" /etc/hosts`.
3. Traffic forwarding must be configured on the machine so that the local microk8s cluster pods can reach the internet, again because of using an AWS EC2 instance. This can be done by running `iptables -P FORWARD ACCEPT` (more info on this subject can be [found here](https://microk8s.io/docs/troubleshooting#common-issues).

### Configuring microk8s

1. First, we must enable the following plugins on microk8s:
   1. `sudo microk8s.enable dns && sudo microk8s.status --wait-ready`
   2. `sudo microk8s.enable storage && sudo microk8s.status --wait-ready`
   3. `sudo microk8s.enable ingress &&  sudo microk8s.status --wait-ready`
2. Now that these plugins have been enabled, we should restart microk8s to ensure a proper bootstrap of the cluster: `microk8s.stop && microk8s.start && microk8s.status --wait-ready`. Further information on this subject can be [found here](https://github.com/ubuntu/microk8s/issues/493#issuecomment-498167435).
3. The plugins are now enabled and the cluster bootstrapped. However, we must still wait for some microk8s internals (dns, http, and ingress) plugins to be ready. Failing to do so can result in pods entering a `CrashLoopBackoff` state:
   1. ```microk8s.kubectl wait -n kube-system --for=condition=Ready pod -l k8s-app=kube-dns --timeout=300s && microk8s.kubectl wait -n kube-system --for=condition=Ready pod -l k8s-app=hostpath-provisioner --timeout=300s && microk8s.kubectl wait -n default --for=condition=Ready pod -l app=default-http-backend --timeout=300s && microk8s.kubectl wait -n default --for=condition=Ready pod -l name=nginx-ingress-microk8s --timeout=300s```

After runing these commands, we have ensured that dns, http, and nginx ingress are enabled and working properly inside the cluster.

### Installing Codacy

#### Helm and Tiller

First we must install `helm` onto the cluster. With `helm`, we can easily install charts and manage the lifecycle of the installed artifacts. One example is the ability to rollback a failed install.
1. Assuming you would want to install `helm` version 2.16.3, export the following environment variable: `export HELM_VERSION=2.16.3`
   1. Please note that we currently do *not* support helm v3.
2. Run this script that will retrieve the desired `helm` version and install it onto the machine's `/usr/local/bin`: `HELM_PKG=helm-${HELM_VERSION}-linux-amd64.tar.gz
wget https://get.helm.sh/$HELM_PKG
tar xvzf $HELM_PKG
su mv linux-amd64/tiller linux-amd64/helm /usr/local/bin
rm -rvf $HELM_PKG linux-amd64/`.
4. We must now deploy `tiller` onto the cluster.
   1. First we must set a `serviceaccount` and a `clusterrolebinding` for `tiller` on the microk8s cluster: `microk8s.kubectl create serviceaccount --namespace kube-system tiller
microk8s.kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller`
   2. Then we can install `tiller`, which will be installed with the same `HELM_VERSION` that you have specified earlier: `helm init --service-account tiller`
   3. We wait for tiller to be ready: `microk8s.kubectl -n kube-system wait --for=condition=Ready pod -l name=tiller --timeout=300s`

### Codacy chart

1. Create a namespace inside the cluster onto which codacy will be deployed. We use the `codacy` namespace on the commands below, but you are free to use your own value for this namespace. `microk8s.kubectl create namespace codacy`
2. The microk8s cluster must know some docker credentials so that the container docker images can be pulled onto the pods. These credentials must belong to the namespace where codacy is installed. You can do so by running: `microk8s.kubectl create secret docker-registry docker-credentials --docker-username=${DOCKER_USERNAME} --docker-password=${DOCKER_PASSWORD} --namespace codacy`. These credentials will be encoded inside the cluster.
3. For codacy to work, we must set a file that which contains information like how many replicas of a given pod will codacy have, what are the cpu and memory limits for these pods, which secret tokens to use for the filestore, among others.
   1. Define the following variables
      1. `CODACY_PROTOCOL` - http or https protocol for your codacy installation.
      2. `CODACY_URL` - desired URL for your codacy installation.
      3. All of the following secrets, which are base64 encoded secrets with a minimum length of 64 characters. You can easily generate them with `openssl rand -base64 128 | tr -dc 'a-zA-Z0-9'`:
         1. `AKKA_SESSION_SECRET`
         2. `PLAY_SESSION_SECRET`
         3. `FILESTORE_CONTENTS_SECRET`
         4. `FILESTORE_UUID_SECRET`
         5. `CACHE_SECRET`
   2. Get your `microk8s-values.yaml` file ready by running `cat << END_VALUES > microk8s-values.yaml`
   3. Configure your `microk8s-values.yaml` file. You can refer to our [documentation](../../README.md), as well as the [microk8s-values.yaml reference file](####microk8s-values.yaml) written below.
   4. Type `END_VALUES` to finish the inline `cat` onto the file.
4. `helm` must know where it can get the charts from. You must add Codacy's chart museum to `helm`'s internal list: `
helm repo add codacy-repo https://charts.codacy.com/stable/`
5. Finally, you can install Codacy's chart by issuing the following `helm` command: `helm upgrade --install codacy codacy-repo/codacy --namespace codacy \
  --recreate-pods --values microk8s-values.yaml`
   1. This command will tell `helm` to install codacy from scratch if no installation exists. Otherwise it will additively upgrade the version that is installed.
   2. It will be installed onto the given `--namespace`.
   3. It will also tell `tiller` to terminate all running pods and create new ones (`--recreate-pods`). This is useful for propagating changes in configuration across all pods.
   4. Lastly we provide the `microk8s-values.yaml` with the intended `--value` for the cluster's configuration.
6. After this, the pods should get to a `Running` state shortly after.




#### microk8s-values.yaml

```yaml
global:
  imagePullSecrets:
    - name: docker-credentials
  codacy:
    url: "${CODACY_PROTOCOL}://${CODACY_URL}"
    backendUrl: "${CODACY_PROTOCOL}://${CODACY_URL}"
  akka:
    sessionSecret: "${AKKA_SESSION_SECRET}"
  play:
    cryptoSecret: "${PLAY_SESSION_SECRET}"
  filestore:
    contentsSecret: "${FILESTORE_CONTENTS_SECRET}"
    uuidSecret: "${FILESTORE_UUID_SECRET}"
  cacheSecret: "${CACHE_SECRET}"

codacy-api:
  replicaCount: 1
  resources:
    limits:
      cpu: 500m
      memory: 2000Mi
    requests:
      cpu: 100m
      memory: 1000Mi
  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: "nginx"
    hosts:
    - host: '${CODACY_URL}'
      paths:
        - /

portal:
  replicaCount: 1
  resources:
    limits:
      cpu: 500m
      memory: 1Gi
    requests:
      cpu: 100m
      memory: 500Mi

activities:
  replicaCount: 1
  resources:
    limits:
      cpu: 500m
      memory: 1Gi
    requests:
      cpu: 100m
      memory: 500Mi
  activitiesdb:
    persistence:
      enabled: true
      size: 50Gi

remote-provider-service:
  replicaCount: 1
  resources:
    limits:
      cpu: 500m
      memory: 750Mi
    requests:
      cpu: 100m
      memory: 300Mi

hotspots-api:
  replicaCount: 1
  resources:
    limits:
      cpu: 500m
      memory: 1Gi
    requests:
      cpu: 100m
      memory: 500Mi
  hotspotsdb:
    persistence:
      enabled: true
      size: 50Gi

hotspots-worker:
  replicaCount: 1
  resources:
    limits:
      cpu: 500m
      memory: 1Gi
    requests:
      cpu: 100m
      memory: 500Mi

listener:
  replicaCount: 1
  resources:
    limits:
      cpu: 2
      memory: 8Gi
    requests:
      cpu: 1
      memory: 6Gi
  listenerdb:
    persistence:
      enabled: true
      size: 50Gi

  persistence:
    claim:
      size: 50Gi

  nfsserverprovisioner:
    enabled: true
    persistence:
      enabled: true
      size: 100Gi

core:
  replicaCount: 1
  resources:
    limits:
      cpu: 500m
      memory: 1500Mi
    requests:
      cpu: 100m
      memory: 750Mi

engine:
  replicaCount: 1
  resources:
    limits:
      cpu: 2000m
      memory: 15000Mi
    requests:
      cpu: 1000m
      memory: 10000Mi

worker-manager:
  replicaCount: 1
  resources:
    limits:
      cpu: 500m
      memory: 1000Mi
    requests:
      cpu: 100m
      memory: 500Mi
  config:
    workers:
      genericMax: 2
      dedicatedMax: 2
    workerResources:
      limits:
        cpu: 1
        memory: "2Gi"
    pluginResources:
      requests:
        cpu: 0.5
        memory: 1000000000 # 1000Mb

crow:
  replicaCount: 1
  resources:
    limits:
      cpu: 1
      memory: 2Gi
    requests:
      cpu: 0.5
      memory: 1Gi

postgres:
  persistence:
    enabled: true
    size: 100Gi

rabbitmq-ha:
  replicaCount: 1
  resources:
    limits:
      cpu: 0.5
      memory: 1200Mi
    requests:
      cpu: 0.2
      memory: 200Mi

fluentdoperator:
  replicaCount: 1
  enabled: true
```
