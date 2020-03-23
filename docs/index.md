# How to install Codacy on Kubernetes

Before you start, review the following requirements that must be met when provisioning the infrastructure that will host Codacy:

-   [System requirements](requirements.md)

## 1. Setting up the Kubernetes infrastructure

You can follow one of the guides below to quickly set up a Kubernetes cluster on your cloud infrastructure using Terraform configuration files provided by Codacy:

-   [Setting up an Amazon EKS cluster](infrastructure/eks-quickstart.md)
-   [Setting up an AKS cluster](infrastructure/aks-quickstart.md)
-   [Setting up a MicroK8s machine](infrastructure/microk8s-quickstart.md)

## 2. Installing Codacy

Follow the steps below to install Codacy on an existing Kubernetes cluster using the provided cloud-native Helm chart.

Before you continue, make sure you have the following tools installed in your machine.

-   [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) version compatible with your cluster ([within one minor version difference of your cluster](https://kubernetes.io/docs/tasks/tools/install-kubectl/#before-you-begin))

    **NOTE:**
     If you are in microk8s, any `kubectl` command must be executed as `microk8s.kubectl` instead.

-   [Helm client](https://v2.helm.sh/docs/using_helm/#installing-helm) version 2.16.3

Install Codacy as follows:

1.  Create a Kubernetes namespace called `codacy` that will group all cluster resources related to Codacy.

    ```bash
    kubectl create namespace codacy
    ```

2.  Add the Docker registry credentials that you received together with your Codacy license to a secret in the namespace created above. This is necessary because some Codacy Docker images are currently private.

    ```bash
    kubectl create secret docker-registry docker-credentials --docker-username=$DOCKER_USERNAME --docker-password=$DOCKER_PASSWORD --namespace codacy
    ```

3.  Use a text editor of your choice edit the [`values-production.yaml`](https://github.com/codacy/chart/blob/master/codacy/values-production.yaml) file, changing the values with placeholders as described in the comments.

4.  Create a record in your DNS provider with the hostname you used in the previous step to send traffic to your ingress controller.

    **NOTE:**
    If you are in microk8s, you need to configure it with the public IP address of your machine.

5.  Add Codacy's chart repository to your helm client and install the Codacy chart using the values file created in the previous step.

    **NOTE:**
    If you are in microk8s, don't forget to use the [`values-microk8s.yaml`](https://github.com/codacy/chart/blob/master/codacy/values-microk8s.yaml) configuration file as stated [here](infrastructure/microk8s-quickstart.md#5-installing-codacy).

    ```bash
    helm repo add codacy-stable https://charts.codacy.com/stable/
    helm repo update
    helm upgrade --install codacy codacy-stable/codacy \
                 --namespace codacy \
               --values values-production.yaml # --values values-microk8s.yaml
    ```

6.  By now all the Codacy pods should be starting in the Kubernetes cluster. Check this with the command below and **wait for all the pods to be Running**:

    ```bash
    $ kubectl get pods -n codacy
    NAME                                            READY   STATUS    RESTARTS   AGE
    codacy-activities-6d9db9499-stk2k               1/1     Running   2          8m57s
    codacy-activitiesdb-0                           1/1     Running   0          8m57s
    codacy-api-f7897b965-fgn67                      1/1     Running   0          8m57s
    codacy-api-f7897b965-kkqsx                      1/1     Running   0          8m57s
    codacy-core-7bcf697968-85tl6                    1/1     Running   0          8m57s
    codacy-crow-7c957d45f6-b8zp2                    1/1     Running   2          8m57s
    codacy-crowdb-0                                 1/1     Running   0          8m57s
    codacy-engine-549bcb69d9-cgrqf                  1/1     Running   1          8m57s
    codacy-engine-549bcb69d9-sh5f4                  1/1     Running   1          8m57s
    codacy-fluentdoperator-x5vr2                    2/2     Running   0          8m57s
    codacy-hotspots-api-b7b9db896-68gxx             1/1     Running   2          8m57s
    codacy-hotspots-worker-76bb45b4d6-8gz45         1/1     Running   3          8m57s
    codacy-hotspotsdb-0                             1/1     Running   0          8m57s
    codacy-listener-868b784dcf-npdfh                1/1     Running   0          8m57s
    codacy-listenerdb-0                             1/1     Running   0          8m57s
    codacy-minio-7cfdc7b4f4-254gz                   1/1     Running   0          8m57s
    codacy-nfsserverprovisioner-0                   1/1     Running   0          8m57s
    codacy-portal-774d9fc596-rwqj5                  1/1     Running   2          8m56s
    codacy-rabbitmq-ha-0                            1/1     Running   0          8m57s
    codacy-ragnaros-69459775b5-hmj4d                1/1     Running   3          8m57s
    codacy-remote-provider-service-8fb8556b-rr4ws   1/1     Running   0          8m56s
    codacy-worker-manager-656dbf8d6d-n4j7c          1/1     Running   0          8m57s
    ```

## 3. Post-install configuration

After successfully installing Codacy, follow the post-install configuration steps:

1.  Enable the Ingress on `codacy-api`.

2.  Start configuring Codacy in the UI. The onboarding process will guide you through the following steps:

    -   Create an administrator account
    -   Configure one or more of the following supported git providers:
        -   [Github Cloud](configuration/git-providers/github-cloud.md)
        -   [Github Enterprise](configuration/git-providers/github-enterprise.md)
        -   [Gitlab Enterprise](configuration/git-providers/gitlab-enterprise.md)
        -   [Bitbucket Enterprise](configuration/git-providers/bitbucket-enterprise.md)
    -   Create an initial organization
    -   Invite users

3.  Finally, we also recommend that you set up logging and monitoring.

    -   [Logging](configuration/logging.md)
    -   [Monitoring](configuration/monitoring.md)
