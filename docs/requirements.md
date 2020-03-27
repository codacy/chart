# System requirements

Running Codacy on a Kubernetes cluster requires the following:

-   A Kubernetes 1.14.\* or 1.15.\* cluster provisioned with the [required resources](#hardware-requirements)
-   The [NGINX Ingress Controller](https://github.com/helm/charts/tree/master/stable/nginx-ingress) correctly set up in your cluster
-   A [PostgreSQL server](#postgresql-server-setup) accessible from the Kubernetes cluster

## Hardware requirements

The following high-level architecture is important in understanding how Codacy uses and allocates hardware resources.

You can look at Codacy separately as the "Platform" and the "Analysis" cluster. The Platform contains the UI and other
components important to treat and show results. The Analysis is the swarm of workers that run several linters for
your project.

**The resources needed for Codacy depend a lot on the rate of commits done by your team.**

!["High Level Architecture"](<./images/High Level Architecture - Analysis II.svg> "High Level Architecture")

Since all of this runs in kubernetes, you can increase the number of replicas in for every deployment, which should give you more resilience and throughput, but it will also increase resource usage. A very simplistic overview of the resource allocations for the "Platform" and "Analysis" goes something like this:

| Component                           | vCPU | Memory |
| ----------------------------------- | ---- | ------ |
| Platform w/ 1 replica on everything | 4    | 8      |
| Per Analysis Worker                 | 5    | 10     |

The resources described on the following table are based on our experience and are also the defaults in the [values-production.yaml](https://raw.githubusercontent.com/codacy/chart/master/codacy/values-production.yaml) file, which you might need to adapt taking into account your use case.

| Installation type                        | ~ Total vCPUs | ~ Total Memory | Replicas per component | Max. commits analyzed concurrently | Platform vCPUs | Platform Memory | Analysis Workers vCPUs | Analysis Workers Memory |
| ---------------------------------------- | ------------- | -------------- | ---------------------- | ---------------------------------- | -------------- | --------------- | ---------------------- | ----------------------- |
| Kubernetes Small Installation            | 16            | 32 GB          | 1                      | 2                                  | 4              | 8 GB            | 10                     | 20 GB                   |
| Kubernetes Medium Installation (default) | 32            | 64 GB          | 2                      | 4                                  | 8              | 16 GB           | 20                     | 40 GB                   |
| Kubernetes Big Installation              | 60+           | 110+ GB        | 2+                     | 10+                                | 8+             | 16+ GB          | 50+                    | 100+ GB                 |

**NOTE:**
For microk8s we added 1.5 CPU and 1.5 GB extra in the "Platform" meant to be used by microk8s itself.

| Installation type              | ~ Total vCPUs | ~ Total Memory | Replicas per component | Max. commits analyzed concurrently | Platform vCPUs | Platform Memory | Analysis Workers vCPUs | Analysis Workers Memory |
| ------------------------------ | ------------- | -------------- | ---------------------- | ---------------------------------- | -------------- | --------------- | ---------------------- | ----------------------- |
| MicroK8s Minimum               | 16            | 32 GB          | 1                      | 2                                  | 5.5            | 9.5 GB          | 10                     | 20 GB                   |
| MicroK8s Recommended (default) | 20+           | 32+ GB         | 1-2                    | 2                                  | 11+            | 20+ GB          | 10                     | 20 GB                   |

### Storage

The storage necessary also depends on the number of repositories you have.
You can use the following table as a guideline to understand the kind of storage allocation
done by codacy.

| Installation type | Bundled in the chart         | Minimum Recommended |
| ----------------- | ---------------------------- | ------------------- |
| NFS               | Yes                          | 200 GB              |
| RabbitMQ          | Yes                          | 8 GB                |
| Minio             | Yes                          | 20 GB               |
| Postgres          | No (external DB recommended) | 500 GB+             |

For a custom recommendation, please contact us at support@codacy.com.

## External PostgreSQL

Codacy requires a working PostgreSQL.
Google itself [doesn't recommend](https://cloud.google.com/blog/products/databases/to-run-or-not-to-run-a-database-on-kubernetes-what-to-consider) that you run PostgreSQL inside you cluster.
As such, you should consider using a managed a solution like AWS RDS or Google Cloud SQL, or running the postgres server
inside a dedicated VM/Machine.

The minimum recommended specifications

| vCPU | Memory | Storage | Max Connections |
| ---- | ------ | ------- | --------------- |
| 4    | 8GB    | 500 GB+ | 300             |

### Setup

We recommend that you also create a dedicated user for Codacy, with access permissions only to the databases specific to Codacy:

1.  Connect to the PostgreSQL server as a database admin user. For example, using the `psql` command-line client:

    ```bash
    psql -U postgres -h <PostgreSQL server hostname>
    ```

2.  Execute the SQL script below to create the dedicated user and the databases required by Codacy. Make sure that you change the user name and password to suit your security needs.

    ```sql
    CREATE USER codacy WITH PASSWORD 'codacy';
    ALTER ROLE codacy WITH CREATEDB
    ```

3.  Make sure that you can connect to the PostgreSQL database using the newly created user. For example:

    ```bash
    psql -U codacy -h <PostgreSQL server hostname>
    ```

4.  Create the necessary databases

    ```sql
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
