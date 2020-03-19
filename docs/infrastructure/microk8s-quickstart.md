# Setting up a microk8s instance

[Microk8s](https://microk8s.io/) is a single-package fully conformant lightweight Kubernetes that works on 42 Linux versions. The project is publicly available and can be [found here](https://github.com/ubuntu/microk8s).

Follow the steps below to set up a microk8s instance from scratch, including all the necessary dependencies and configuration.

## 1. Concepts

### Helm and tiller

Two executables will get installed onto the cluster as part of this process: `helm` and `tiller`.

* `helm` is responsible for resolving the configuration of the chart to be installed, while issuing the correct install commands onto the cluster.
* `tiller` is responsible for receiving the install commands issued by `helm`, as well as managing the lifecycle of the components that have been installed.

`helm` is the client facing side, while `tiller` is the server/cluster facing side.

## 2. Prepare your environment

Prepare your environment to set up the microk8s cluster. For your infrastructure, you will need the following:

* A machine running Ubuntu 18.04 LTS. You must start a local or remote command line session on this machine.
* A [PostgreSQL instance with all the necessary databases created](../requirements.md#postgresql-server-setup). The machine above must be able to connect to this PostgreSQL instance.

All the following steps assume that you are starting from a blank slate.

## 3. Installing microk8s

1. Make sure the machine has the `nfs-common` package installed.

   ```bash
   sudo apt update && sudo apt install nfs-common -y
   ```

2. Install microk8s from the `1.15/stable` channel.

   ```bash
   sudo snap install microk8s --classic --channel=1.15/stable && \
   sudo usermod -a -G microk8s $USER  && \
   sudo su - $USER
   ```

   Check that microk8s is running.

   ```bash
   microk8s.status --wait-ready
   ```

3. Install the version `v2.16.3` of the helm binary

   ```bash
   HELM_PKG=helm-v2.16.3-linux-amd64.tar.gz
   wget https://get.helm.sh/$HELM_PKG
   tar xvzf $HELM_PKG
   sudo mv linux-amd64/tiller linux-amd64/helm /usr/local/bin
   rm -rvf $HELM_PKG linux-amd64/
   ```

## 4. Configuring microk8s

1. First, we must enable the following plugins on microk8s:

   ```bash
   sudo echo "--allow-privileged=true" >> /var/snap/microk8s/current/args/kube-apiserver && \
   microk8s.enable dns && \
   microk8s.status --wait-ready && \
   microk8s.enable storage && \
   microk8s.status --wait-ready && \
   microk8s.enable ingress && \
   microk8s.status --wait-ready && \
   microk8s.stop && \
   microk8s.start && \
   microk8s.status --wait-ready
   ```

2. Install Tiller:

   ```bash
   microk8s.kubectl create serviceaccount --namespace kube-system tiller && \
   microk8s.kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller && \
   helm init --service-account tiller
   ```

3. The plugins are now enabled and the cluster bootstrapped. However, we must still wait for some microk8s internals (dns, http, and ingress) plugins to be ready, as failing to do so can result in pods entering a `CrashLoopBackoff` state:

   ```bash
   microk8s.kubectl wait -n kube-system --for=condition=Ready pod -l k8s-app=kube-dns
   microk8s.kubectl wait -n kube-system --for=condition=Ready pod -l k8s-app=hostpath-provisioner
   # If the following command fails, you probably installed the wrong microk8s version
   microk8s.kubectl wait -n default --for=condition=Ready pod -l name=nginx-ingress-microk8s
   microk8s.kubectl -n kube-system wait --for=condition=Ready pod -l name=tiller
   ```

After these commands return successfully, we have ensured that dns, http, and nginx ingress are enabled and working properly inside the cluster.

## 5. Installing Codacy

Any `kubectl` command from [our chart installation](../install.md) must be executed as a `microk8s.kubectl` command. You can also create an alias to simplify the process:

```bash
alias kubectl='microk8s.kubectl'
```

When you get to the installation step you also need to append the [`values-microk8s.yaml`](https://github.com/codacy/chart/blob/master/codacy/values-microk8s.yaml) configuration that downsizes some of the limits, making it easier to fit in the lightweight solution that is microk8s.
