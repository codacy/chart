# System requirements

Running Codacy on a Kubernetes cluster requires the following:

-   A Kubernetes 1.14.\* or 1.15.\* cluster provisioned with the [required resources](#cluster-resource-requirements)
-   The [NGINX Ingress Controller](https://github.com/helm/charts/tree/master/stable/nginx-ingress) for Kubernetes
-   A [PostgreSQL server](#postgresql-server-setup) accessible from the Kubernetes cluster

## Cluster resource requirements

To have an enjoyable experience with Codacy, you should have the
following calculations in mind when allocating resources for the
installation and defining the number of concurrent analysis.

Without accounting for analysis ([next section](#analysis)),
you should need at least the following resources:

```text
CPU: 7 CPU
Memory: 40 GB
```

Check the
[values-production.yaml](https://github.com/codacy/chart/blob/master/codacy/values-production.yaml)
file to find a configuration reference that should work for you to run a
"production-ready" version of Codacy.

### Analysis

Each analysis runs a maximum number of 4 plugins in parallel (not configurable)

Note: All the following configurations are nested inside the `worker-manager.config`
configuration object, but for simplicity, we decided to omit the full path.

```text
CPU: workerResources.requests.cpu + (pluginResources.requests.cpu * 4)

Memory: workerResources.requests.memory + (pluginResources.requests.memory * 4)

Number of concurrent analysis: workers.dedicatedMax
```

Given the previous values, the total number of resources required should be the "per-analysis" amount times the number of concurrent analysis.

### Example

_Maximum of 6 concurrent analysis_

```yaml
worker-manager:
  config:
    workers:
      dedicatedMax: 3
    workerResources:
      limits:
        cpu: 1
        memory: "2Gi"
    pluginResources:
      requests:
        cpu: 0.5
        memory: 1000000000 # 1GB
```

In this example the minimum number of resources required would be:

```text
CPU: 6 * (1 + (0.5 * 4)) = 18 CPU
Memory: 6 * (2 + (1 * 4)) = 36 GB
```

**Total:**

```text
CPU: 7 CPU + 18 CPU = 25 CPU
Memory: 40 GB + 36 GB = 76 GB
```

## PostgreSQL server setup

Codacy requires a working PostgreSQL server to run. The recommended specifications are:

-   4 CPU
-   8 GB RAM
-   Minimum 500 GB+ hard drive, depending on the number of repositories you have. For a custom recommendation, please contact us at support@codacy.com.

You must manually create the databases required by Codacy on the PostgreSQL server. We recommend that you also create a dedicated user for Codacy, with access permissions only to the databases specific to Codacy:

1.  Connect to the PostgreSQL server as a database admin user. For example, using the `psql` command-line client:

    ```bash
    psql -U postgres -h <PostgreSQL server hostname>
    ```

2.  Execute the SQL script below to create the dedicated user and the databases required by Codacy. Make sure that you change the user name and password to suit your security needs.

    ```sql
    CREATE USER codacy WITH PASSWORD 'codacy';
    ALTER ROLE codacy WITH CREATEDB;

    CREATE DATABASE accounts WITH OWNER=codacy;
    CREATE DATABASE analysis WITH OWNER=codacy;
    CREATE DATABASE results WITH OWNER=codacy;
    CREATE DATABASE metrics WITH OWNER=codacy;
    CREATE DATABASE filestore WITH OWNER=codacy;
    CREATE DATABASE jobs WITH OWNER=codacy;
    CREATE DATABASE activities WITH OWNER=codacy;
    CREATE DATABASE hotspots WITH OWNER=codacy;
    CREATE DATABASE listener WITH OWNER=codacy;
    CREATE DATABASE crow WITH OWNER=codacy;
    ```

3.  Make sure that you can connect to the PostgreSQL database using the newly created user. For example:

    ```bash
    psql -U codacy -h <PostgreSQL server hostname>
    ```
