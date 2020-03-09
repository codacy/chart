# Setting up a microk8s cluster

[Microk8s](https://microk8s.io/) is a single-package fully conformant lightweight Kubernetes that works on 42 Linux versions. The project is publicly available and can be [found here](https://github.com/ubuntu/microk8s).

Follow the steps below to set up a microk8s instance from scratch, including all the necessary dependencies and configuration.

## 1. Concepts

### Kubeconfig

Any tool that operates on top of a cluster needs to know which cluster it is going to work on. This execution context is typically called the `kubeconfig` which is stored in the `~/.kube/config` file. This file basically defines a list of clusters and it holds several pieces of information per cluster entry:

* The address of the cluster (e.g. https://104.248.34.242:164309).
* The user friendly name of the cluster (e.g. microk8s-instance).
* A reference to the current context. This is the active cluster against which any kubernetes control (`kubectl`) command you run will get executed.

### Helm and tiller

Two executables will get installed onto the cluster as part of this process: `helm` and `tiller`.

* `helm` is responsible for resolving the configuration of the chart to be installed, while issuing the correct install commands onto the cluster.
* `tiller` is responsible for receiving the install commands issued by `helm`, as well as managing the lifecycle of the components that have been installed.

`helm` is the client facing side, while `tiller` is the server/cluster facing side.

## 2. Prepare your environment

Prepare your environment to set up the microk8s cluster.
For your infrastructure, you will need the following:

1. A machine running Ubuntu 18.04 LTS.
2. A postgres database and open firewall rule. ([Documentation can be found here.](../requirements.md))

To start installing Codacy, you will need to:

1. Establish a session (local or remote) onto the machine described in 1. above.

Assuming that you are starting from a blank slate, the first step is to install microk8s. Otherwise, consider that Codacy is supported up to kubernetes 1.15. Please jump on to the section [Configuring microk8s](###4.-Configuring-microk8s) if you are on a compatible kubernetes version.

## 3. Installing microk8s

1. Make sure the machine is up to date and also has the `nfs-common` package installed

   ```bash
   sudo apt update && apt install nfs-common -y

2. Install microk8s. Codacy is supported up to kubernetes 1.15. Therefore we recommend following the [official documentation on how to install microk8s](https://microk8s.io/docs/) with the `1.15/stable` channel.

3. Allow privileged containers for microk8s

   ```bash
   sudo echo "--allow-privileged=true" >> /var/snap/microk8s/current/args/kube-apiserver
   ```

## 4. Configuring microk8s

1. First, we must enable the following plugins on microk8s:

    ```bash
   microk8s.enable dns &&
   microk8s.enable storage &&
   microk8s.enable ingress &&
   microk8s.status --wait-ready
    ```

2. Now that these plugins have been enabled, we should restart microk8s to ensure a proper bootstrap of the cluster

    ```bash
   microk8s.stop && microk8s.start && microk8s.status --wait-ready
    ```

    Further information on this subject can be [found here](https://github.com/ubuntu/microk8s/issues/493#issuecomment-498167435).

3. The plugins are now enabled and the cluster bootstrapped. However, we must still wait for some microk8s internals (dns, http, and ingress) plugins to be ready. Failing to do so can result in pods entering a `CrashLoopBackoff` state:

   ```bash
    microk8s.kubectl wait -n kube-system --for=condition=Ready pod -l k8s-app=kube-dns

    microk8s.kubectl wait -n kube-system --for=condition=Ready pod -l k8s-app=hostpath-provisioner

    microk8s.kubectl wait -n default --for=condition=Ready pod -l name=nginx-ingress-microk8s
    ```

After these commands return successfully, we have ensured that dns, http, and nginx ingress are enabled and working properly inside the cluster.

## 5. Installing Codacy

### 1. Helm and Tiller

First we must install `helm` onto the cluster. With `helm`, we can easily install charts and manage the lifecycle of the installed artifacts. One example is the ability to rollback a failed install.

1. __Codacy supports up to `helm` version 2.16.3.__
   __We currently do not support `helm` v3.__
2. Follow the instructions on installing the `helm` client on the [Preparing to install Codacy documentation](../../docs/index.md).

3. We must now deploy `tiller` onto the cluster.
   1. First we must set a `serviceaccount` and a `clusterrolebinding` for `tiller` on the microk8s cluster:

      ```bash
      microk8s.kubectl create serviceaccount --namespace kube-system tiller
      microk8s.kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
      ```

   2. Then we can install `tiller`, which will be installed with the same `HELM_VERSION` that you have specified earlier and we wait for tiller to be ready:

      ```bash
      helm init --service-account tiller
      microk8s.kubectl -n kube-system wait --for=condition=Ready pod -l name=tiller
      ```

### 2. Codacy chart

Please refer to [our chart installation documentation](https://github.com/codacy/chart/blob/master/docs/install.md).

Additionally, any `kubectl` command from [our chart installation](https://github.com/codacy/chart/blob/master/docs/install.md) must be executed as a `microk8s.kubectl` command.

#### 1. Default Values

We provide a base [values file](##values-microk8s.yaml) that you can use for your microk8s Codacy installation. This file provisions a smaller number of component replicas with limited resources (i.e. CPU and memory). Should you want to use this as a template, please pass your `values-microk8s.yaml` file on (4.) of [our chart installation](https://github.com/codacy/chart/blob/master/docs/install.md). Lastly, it is important to correctly set your `codacy-api.ingress.hosts.host` if you are using this file as a template.

#### 2. External Databases

If you do not have an external database set up for you by an Ops team,  you should follow the [steps described here](../requirements.md).
In addition to these requirements, you must not forget to include the appropriate configuration blocks in the values file you provide to `helm` during installation.

Do not forget to replace the placeholders for database names, credentials, urls, and ports on the [values file](##values-microk8s.yaml)

## 6. Accessing the Codacy UI

Please follow [the Post-install configuration steps described here](../install.md) so that you can access your Codacy installation through the UI.

The crucial configuration step is that you must have the codacy-api ingress and backend urls(`codacy-api.ingress.hosts.host`, `global.codacy.url`, and `global.codacy.backendUrl`) properly configured.

## values-microk8s.yaml

Please see [this file](../../codacy/values-microk8s.yaml) that you can consider as a starting point to configure your Codacy microk8s installation.
