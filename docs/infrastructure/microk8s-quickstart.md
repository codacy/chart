# Setting up a microk8s cluster

Follow the steps below to set up a microk8s cluster from scratch, including all the necessary dependencies and configuration.

## 1. Concepts

### Kubeconfig

Any tool that operates on top of a cluster needs to know which cluster it is going to work on. This execution context is typically called the `kubeconfig` which is stored in the `~/.kube/config` file. This file basically defines a list of clusters and it holds several pieces of information per cluster entry:

* The address of the cluster (e.g. https://104.248.34.242:164309).
* The user friendly name of the cluster (e.g. microk8s-cluster).
* A reference to the current context. This is the active cluster against which any kubernetes control (`kubectl`) command you run will get executed.

### Helm and tiller

Two executables will get installed onto the cluster as part of this process: `helm` and `tiller`.

* `helm` is responsible for resolving the configuration of the chart to be installed, while issuing the correct install commands onto the cluster.
* `tiller` is responsible for receiving the install commands issued by `helm`, as well as managing the lifecycle of the components that have been installed.

`helm` is the client facing side, while `tiller` is the server/cluster facing side.

## 2. Prepare your environment

Prepare your environment to set up the microk8s cluster:

1. A machine running Ubuntu 18.04 LTS.
2. Establish a remote SSH session onto this machine.

Assuming that you are starting from a blank slate, the first step is to install microk8s. Otherwise, please jump on to the section [Configuring microk8s](###4.-Configuring-microk8s).

## 3. Installing microk8s

1. Make sure the machine is up to date and also has the `nfs-common` package installed

   ```bash
   sudo apt update && apt install nfs-common -y

2. Install microk8s
   >sudo snap install microk8s --classic --channel=1.15/stable
   1. We recommend following the official documentation on how to [install microk8s](https://microk8s.io/docs/).

## 4. Configuring microk8s

1. First, we must enable the following plugins on microk8s:
    >sudo microk8s.enable dns && sudo microk8s.status --wait-ready

    >sudo microk8s.enable storage && sudo microk8s.status --wait-ready

    >sudo microk8s.enable ingress &&  sudo microk8s.status --wait-ready

2. Now that these plugins have been enabled, we should restart microk8s to ensure a proper bootstrap of the cluster
    >microk8s.stop && microk8s.start && microk8s.status --wait-ready

    Further information on this subject can be [found here](https://github.com/ubuntu/microk8s/issues/493#issuecomment-498167435).
3. The plugins are now enabled and the cluster bootstrapped. However, we must still wait for some microk8s internals (dns, http, and ingress) plugins to be ready. Failing to do so can result in pods entering a `CrashLoopBackoff` state:

    >microk8s.kubectl wait -n kube-system --for=condition=Ready pod -l k8s-app=kube-dns --timeout=300s

    >microk8s.kubectl wait -n kube-system --for=condition=Ready pod -l k8s-app=hostpath-provisioner --timeout=300s

    >microk8s.kubectl wait -n ingress --for=condition=Ready pod -l name=nginx-ingress-microk8s --timeout=300s

4. Export your microk8s cluster configuration to the local kubeconfig file
    >microk8s.config > ~/.kube/config

After runing these commands, we have ensured that dns, http, and nginx ingress are enabled and working properly inside the cluster.

## 5. Installing Codacy

### 1. Helm and Tiller

First we must install `helm` onto the cluster. With `helm`, we can easily install charts and manage the lifecycle of the installed artifacts. One example is the ability to rollback a failed install.

1. Assuming you would want to install `helm` version 2.16.3, export the following environment variable
    >export HELM_VERSION=2.16.3
   1. Please note that we currently do *not* support helm v3.
2. Run this script that will retrieve the desired `helm` version and install it onto the machine's `/usr/local/bin`:
   1. Define a HELM_PKG variable
      >HELM_PKG=helm-v${HELM_VERSION}-linux-amd64.tar.gz
   2. Get the package
      >wget https://get.helm.sh/$HELM_PKG
   3. Extract the tarball
      >tar xvzf $HELM_PKG
   4. Move the binaries to `/usr/local/bin`
      >mv linux-amd64/tiller linux-amd64/helm /usr/local/bin
   5. Delete the extracted tarball directory
      >rm -rvf $HELM_PKG linux-amd64/

3. We must now deploy `tiller` onto the cluster.
   1. First we must set a `serviceaccount` and a `clusterrolebinding` for `tiller` on the microk8s cluster:
      >microk8s.kubectl create serviceaccount --namespace kube-system tiller

      >microk8s.kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
   1. Then we can install `tiller`, which will be installed with the same `HELM_VERSION` that you have specified earlier:
      >helm init --service-account tiller
   1. We wait for tiller to be ready
      >microk8s.kubectl -n kube-system wait --for=condition=Ready pod -l name=tiller --timeout=300s

### 2. Codacy chart

Please refer to [our chart installation documentation](https://github.com/codacy/chart/blob/master/docs/install.md).

Additionally, any `kubectl` command from [our chart installation](https://github.com/codacy/chart/blob/master/docs/install.md) must be executed as a `microk8s.kubectl` command.

#### 1. Default Values

We provide a base (values file)[##microk8s-values.yaml] that you can use for your microk8s Codacy installation. This file provisions a smaller number of component replicas with limited resources (i.e. CPU and memory). Should you want to use this as a template, please pass your `microk8s-values.yaml` file on (4.) of [our chart installation](https://github.com/codacy/chart/blob/master/docs/install.md). Lastly, it is important to correctly set your `codacy-api.ingress.hosts.host` if you are using this file as a template.

#### 2. External Databases

If you have decided to go with the [default values for the installation](####1.-Default-Values), your microk8s cluster will contain a PostgreSQL database within itself. This is not recommended as the data stored in the database will not be as durable if you store it in an external database.

To setup an external database, you should follow the [steps described here](../requirements.md).
In addition to those, you must not forget to include the appropriate configuration blocks in the values file you provide to `helm` during installation.

An example of a configuration block is:

```yaml
global:
  analysisdb:
    create: false
    postgresqlUsername: <--- codacy-db-username --->
    postgresqlDatabase: analysis # You need to create the DB manually
    postgresqlPassword: <--- codacy-db-password --->
    host: <--- codacy-db-host --->
    service:
      port: 5432
```

## 6. Accessing the Codacy UI

Please follow [the Post-install configuration steps described here](../install.md) so that you can access your Codacy installation through the UI.

The crucial configuration step is that you must have the codacy-api ingress and backend urls(`codacy-api.ingress.hosts.host`, `global.codacy.url`, and `global.codacy.backendUrl`) properly configured.

## 7. Troubleshooting

### 1. AWS EC2 specific issues

1. We had to configure the instance's list of hosts with localhost. This was because our machine was in fact an AWS EC2 instance, and therefore we must allow the correct resolution of the local microk8s cluster on the kubeconfig. We did so by running

    >sudo sed -i -e "1s/127.0.0.1 localhost.*/127.0.0.1 localhost $(hostname)/" /etc/hosts

2. Traffic forwarding must be configured on the machine so that the local microk8s cluster pods can reach the internet, again because of using an AWS EC2 instance. This can be done by running
    >sudo iptables -P FORWARD ACCEPT

    (more info on this subject can be [found here](https://microk8s.io/docs/troubleshooting#common-issues)).

## microk8s-values.yaml

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
  enabled: true
```
