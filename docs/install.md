# Installing Codacy

Follow the steps below to install Codacy on an existing Kubernetes cluster using the provided cloud native Helm chart.

**NOTE:**
If you are in microk8s, any `kubectl` command must be executed as `microk8s.kubectl` instead.

1.  Create a Kubernetes namespace called `codacy` that will group all cluster resources related to Codacy.

    ```bash
    kubectl create namespace codacy
    ```

2.  Add the Docker registry credentials that you received together with your Codacy license to a secret in the namespace created above. This is necessary because some Codacy Docker images are currently private.

    ```bash
    kubectl create secret docker-registry docker-credentials --docker-username=$DOCKER_USERNAME --docker-password=$DOCKER_PASSWORD --namespace codacy
    ```

3.  Use a text editor of your choice edit the [`values-production.yaml`](../codacy/values-production.yaml) file, changing the values with placeholders as described in the comments.


4.  Add Codacy's chart repository to your helm client and install the Codacy chart using the values file created in the previous step.

    **NOTE:**
    If you are in microk8s, don't forget to use the [`values-microk8s.yaml`](../codacy/values-microk8s.yaml) configuration file as stated [here](infrastructure/microk8s-quickstart.md#5-installing-codacy).

    ```bash
    helm repo add codacy-stable https://charts.codacy.com/stable/
    helm repo update
    helm upgrade --install codacy codacy-stable/codacy \
      --namespace codacy \
      --atomic \
      --timeout=300 \
      --values values-production.yaml # --values values-microk8s.yaml
    ```

    By now all the Codacy pods should be starting in the Kubernetes cluster. Check this with the command below (your output will contain more detail):

    ```bash
    $ helm status codacy
    LAST DEPLOYED: Wed Jan  8 15:52:27 2020
    NAMESPACE: codacy
    STATUS: DEPLOYED

    RESOURCES:

    [...]

    ==> v1/Pod(related)
    NAME                                             READY  STATUS            RESTARTS  AGE
    codacy-activities-78849c8548-ln5sl               1/1    Running           4         6m11s
    codacy-activitiesdb-0                            1/1    Running           0         6m3s
    codacy-api-6f44c8d48-6bw8z                       1/1    Running           0         6m11s
    codacy-api-6f44c8d48-h6cl4                       1/1    Running           0         6m11s
    codacy-api-6f44c8d48-vgbl5                       1/1    Running           0         6m11s
    codacy-core-786c6f79f-7sn7p                      1/1    Running           0         6m11s
    codacy-core-786c6f79f-pvg9w                      1/1    Running           0         6m11s
    [...]
    ```
