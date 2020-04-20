# Installing Codacy on Kubernetes

This documentation guides you on how to install Codacy on Kubernetes or MicroK8s.

To install Codacy you must complete these main steps:

1.  [**Setting up the system requirements**](#1-setting-up-the-system-requirements)

    Ensure that your infrastructure meets the hardware and system requirements to run Codacy.

2.  [**Installing Codacy**](#2-installing-codacy)

    Install Codacy on the cluster using our [Helm chart](https://github.com/codacy/chart/) that includes all the necessary components and dependencies.

3.  [**Configuring Codacy**](#3-configuring-codacy)

    Configure integrations with Git providers and set up monitoring.

The next sections include detailed instructions on how to complete each step of the installation process. Make sure that you complete each step before advancing to the next one.

## 1. Setting up the system requirements

Before you start, you must prepare and and provision the database server and Kubernetes or MicroK8s cluster that will host Codacy.

Carefully review and set up the system requirements to run Codacy by following the instructions on the page below:

-   [System requirements](requirements.md)

Optionally, you can follow one of the guides below to quickly create a new Kubernetes or MicroK8s cluster that satisfies the characteristics described in the system requirements:

-   [Creating an Amazon EKS cluster](infrastructure/eks-quickstart.md)
-   [Creating an AKS cluster](infrastructure/aks-quickstart.md)
-   [Creating a MicroK8s cluster](infrastructure/microk8s-quickstart.md)

## 2. Installing Codacy

Install Codacy on an existing cluster using our Helm chart:

1.  Make sure that you have the following tools installed on your machine:

    -   [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) within one minor version difference of your cluster

        !!! important
            **If you are using MicroK8s** you don't need to install kubectl because you will execute all `kubectl` commands as `microk8s.kubectl` commands instead. To simplify this, [check how to create an alias](infrastructure/microk8s-quickstart.md#notes-on-installing-codacy) for `kubectl`.

    -   [Helm client](https://v2.helm.sh/docs/using_helm/#installing-helm) version 2.16.3

2.  Create a cluster namespace called `codacy` that will group all resources related to Codacy.

    ```bash
    kubectl create namespace codacy
    ```

3.  Add the Docker registry credentials provided by Codacy together with your license to a cluster Secret. This is necessary because some Codacy Docker images are currently private.

    Substitute `<docker_username>` and `<docker_password>` with the Docker registry username and password and run the following command:

    ```bash
    kubectl create secret docker-registry docker-credentials \
        --docker-username=<docker_username> \
        --docker-password=<docker_password> \
        --namespace codacy
    ```

4.  Download the template file [`values-production.yaml`](https://github.com/codacy/chart/blob/master/codacy/values-production.yaml){: target="_blank"} and use a text editor of your choice to edit the value placeholders as described in the comments. You can download the template file by running:

    ```bash
    wget https://raw.githubusercontent.com/codacy/chart/master/codacy/values-production.yaml
    ```

5.  Create an address record on your DNS provider mapping the hostname you used in the previous step to the IP address of your Ingress controller.

    !!! important
        **If you are using MicroK8s** you must map the hostname to the public IP address of the machine running MicroK8s.

6.  Add Codacy's chart repository to your Helm client and install the Codacy chart using the file `values-production.yaml` created previously.

    !!! important
        **If you are using MicroK8s** you must use the file `values-microk8s.yaml` together with the file `values-production.yaml`.
        
        Use `wget` to download the extra file and uncomment the last line before running the `helm upgrade` command below:

        ```bash
        wget https://raw.githubusercontent.com/codacy/chart/master/codacy/values-microk8s.yaml
        ```

    ```bash
    helm repo add codacy-stable https://charts.codacy.com/stable/
    helm repo update
    helm upgrade --install codacy codacy-stable/codacy \
                 --namespace codacy \
                 --values values-production.yaml \
                 # --values values-microk8s.yaml
    ```

7.  By now all the Codacy pods except `codacy-crow` (which can be [configured later](configuration/monitoring.md#setting-up-monitoring-using-crow)) should be starting in the cluster.

    Run the following command and **wait for all the pods except `codacy-crow` to have the status Running**, which can take several minutes:

    ```bash
    $ kubectl get pods -n codacy
    NAME                                             READY   STATUS             RESTARTS   AGE
    codacy-activities-6d9db9499-qch59                1/1     Running            5          6m11s
    codacy-api-67c8c89b57-lrh8f                      1/1     Running            0          6m10s
    codacy-api-67c8c89b57-zn4ln                      1/1     Running            0          6m10s
    codacy-core-5458484db9-bb2z4                     1/1     Running            0          6m11s
    codacy-crow-65ff6df7cf-7lmgv                     0/1     CrashLoopBackOff   5          6m11s
    codacy-engine-fc8f4cf7b-52mlb                    1/1     Running            2          6m11s
    codacy-engine-fc8f4cf7b-8zj4f                    1/1     Running            5          6m11s
    codacy-fluentdoperator-9pjmd                     2/2     Running            0          6m11s
    codacy-hotspots-api-7f6b7d8cbf-g5g29             1/1     Running            4          6m10s
    codacy-hotspots-worker-76bb45b4d6-whk62          1/1     Running            4          6m11s
    codacy-listener-7f996cd786-dfpm6                 1/1     Running            1          6m11s
    codacy-minio-7cfdc7b4f4-lvj8d                    1/1     Running            0          6m11s
    codacy-nfsserverprovisioner-0                    1/1     Running            0          6m11s
    codacy-portal-77d759786f-p6pzq                   1/1     Running            3          6m11s
    codacy-rabbitmq-ha-0                             1/1     Running            0          6m11s
    codacy-ragnaros-5c687cdd66-jc4zt                 1/1     Running            0          6m11s
    codacy-remote-provider-service-bf4587dbd-zm54k   1/1     Running            0          6m11s
    codacy-worker-manager-6ff865db45-r8v9s           1/1     Running            0          6m11s
    ```

## 3. Configuring Codacy

After successfully installing Codacy on your cluster, you are now ready to perform the post-install configuration steps:

1.  Use a browser to navigate to the Codacy hostname previously configured on the file `values-production.yaml`.

2.  Follow Codacy's onboarding process, which will guide you through the following steps:

    -   Creating an administrator account
    -   Configuring one or more of the following supported Git providers:
        -   [GitHub Cloud](configuration/git-providers/github-cloud.md)
        -   [GitHub Enterprise](configuration/git-providers/github-enterprise.md)
        -   [GitLab Cloud](configuration/git-providers/gitlab-cloud.md)
        -   [GitLab Enterprise](configuration/git-providers/gitlab-enterprise.md)
        -   [Bitbucket Server](configuration/git-providers/bitbucket-server.md)
    -   Creating an initial organization
    -   Inviting users to Codacy

3.  As a last step we recommend that you [set up monitoring](configuration/monitoring.md) on your Codacy instance.
