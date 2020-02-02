# Installing Codacy

Follow the step by step instructions below on how to install Codacy in an existing Kubernetes cluster using the provided cloud native Helm chart.

1. Create a Kubernetes namespace called `codacy` that will group all cluster resources related to Codacy.

    ```bash
    kubectl create namespace codacy
    ```

1. Add the Docker registry credentials that you received together with your Codacy license to a secret in the namespace created above. This is necessary because some Codacy Docker images are currently private.

    ```bash
    kubectl create secret docker-registry docker-credentials --docker-username=$DOCKER_USERNAME --docker-password=$DOCKER_PASSWORD --namespace codacy
    ```

1. Use a text editor of your choice to copy the template below to a new file named `values.yaml`, changing the values as described in the comments.

    ```yaml
    global:
      imagePullSecrets:
        - name: docker-credentials
      codacy:
        url: "http://codacy.example.com" # This value is important for VCS configuration and badges to work
        backendUrl: "http://codacy.example.com" # This value is important for VCS configuration and badges to work
      play:
        cryptoSecret: "CHANGE ME" # Generate one with `openssl rand -base64 32 | tr -dc 'a-zA-Z0-9'`
      filestore:
        contentsSecret: "CHANGE ME" # Generate one with `openssl rand -base64 32 | tr -dc 'a-zA-Z0-9'`
        uuidSecret: "CHANGE ME" # Generate one with `openssl rand -base64 32 | tr -dc 'a-zA-Z0-9'`
      cacheSecret: "CHANGE ME" # Generate one with `openssl rand -base64 32 | tr -dc 'a-zA-Z0-9'`
    ```

1. Add Codacy's chart repository to your helm client and install the Codacy chart using the values in the `values.yaml` file created in the previous step.

    ```bash
    helm repo add codacy-stable https://charts.codacy.com/stable/
    helm repo update
    helm upgrade --install codacy codacy-stable/codacy \
      --namespace codacy \
      --recreate-pods \
      --values values.yaml
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

1. Modify and use the [reference file](https://raw.githubusercontent.com/codacy/chart/master/codacy/values-production.yaml) `values-production.yaml` to [set up external DBs](configuration/external-dbs.md) (ideally running in a cloud managed Postgres instance).
