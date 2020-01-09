# Install

Install Codacy on Kubernetes with the cloud native Codacy Helm chart.
This guide will cover the required values and common options.

Before starting, make sure you are aware of the [requirements](../requirements/index.md).

## TL;DR - Quickly install Codacy for demo without any persistence.

Some Codacy images are currently private. For this, you need to
create a secret in the same namespace were you will install Codacy.
**You should receive these credentials together with your license.**

```bash
$ kubectl create namespace codacy
$ kubectl create secret docker-registry docker-credentials --docker-username=$DOCKER_USERNAME --docker-password=$DOCKER_PASSWORD --namespace codacy
```

Create a file named `values.yaml`, using a text editor of your choice.

```yaml
global:
  imagePullSecrets:
    - docker-credentials # Access private codacy docker images
  codacy:
    url: "http://codacy.mycompany.com" # This value is important for VCS configuration and badges to work
    backendUrl: "http://codacy.mycompany.com" # This value is important for VCS configuration and badges to work
  play:
    cryptoSecret: "PLEASE_CHANGE_ME" # Generate one with `openssl rand -base64 32 | tr -dc 'a-zA-Z0-9'`
  filestore:
    contentsSecret: "PLEASE_CHANGE_ME" # Generate one with `openssl rand -base64 32 | tr -dc 'a-zA-Z0-9'`
    uuidSecret: "PLEASE_CHANGE_ME" # Generate one with `openssl rand -base64 32 | tr -dc 'a-zA-Z0-9'`
  cacheSecret: "PLEASE_CHANGE_ME" # Generate one with `openssl rand -base64 32 | tr -dc 'a-zA-Z0-9'`
```

```bash
$ helm repo add codacy-stable https://charts.codacy.com/stable/
$ helm repo update
$ helm upgrade --install codacy codacy-stable/codacy \
  --namespace codacy \
  --recreate-pod \
  --values values.yaml
```

By now all pods should be starting.

```bash
$ helm status codacy

LAST DEPLOYED: Wed Jan  8 15:52:27 2020
NAMESPACE: codacy
STATUS: DEPLOYED

RESOURCES:
==> v1/ClusterRole
NAME                         AGE
codacy-nfsserverprovisioner  12d

==> v1/ClusterRoleBinding
NAME                         AGE
codacy-nfsserverprovisioner  12d

==> v1/ConfigMap
NAME                                    DATA  AGE
codacy-activities                       12    12d
codacy-api                              69    12d
codacy-core                             19    12d
codacy-crow                             17    12d
codacy-engine                           43    12d
codacy-fluentd-config                   1     12d
codacy-hotspots-api                     16    12d
codacy-hotspots-worker                  18    12d
codacy-listener                         27    12d
codacy-listener-nfs-cleanup             1     12d
codacy-minio                            1     12d
codacy-portal                           44    12d
codacy-postgres-extended-configuration  1     12d
codacy-postgres-init-scripts            1     12d
codacy-rabbitmq-ha                      2     12d
codacy-ragnaros                         18    12d
codacy-remote-provider-service          12    12d
codacy-worker-manager                   71    98m

==> v1/Deployment
NAME                            READY  UP-TO-DATE  AVAILABLE  AGE
codacy-activities               1/2    2           1          12d
codacy-api                      3/3    3           3          12d
codacy-core                     2/2    2           2          12d
codacy-crow                     1/1    1           1          12d
codacy-engine                   2/2    2           2          12d
codacy-hotspots-api             2/2    2           2          12d
codacy-hotspots-worker          2/2    2           2          12d
codacy-listener                 1/1    1           1          12d
codacy-minio                    1/1    1           1          12d
codacy-portal                   2/2    2           2          12d
codacy-ragnaros                 1/1    1           1          12d
codacy-remote-provider-service  2/2    2           2          12d
codacy-worker-manager           2/2    2           2          12d

==> v1/PersistentVolumeClaim
NAME                         STATUS  VOLUME                                    CAPACITY  ACCESS MODES  STORAGECLASS                 AGE
codacy-listener-cache-claim  Bound   pvc-dfc57bfe-31fd-11ea-8144-4e0c422f671d  140Gi     RWO           codacy-listener-cache-class  5h56m  Filesystem
codacy-minio                 Bound   pvc-fa775d78-289c-11ea-8144-4e0c422f671d  20Gi      RWO           do-block-storage             12d    Filesystem

==> v1/Pod(related)
NAME                                             READY  STATUS            RESTARTS  AGE
codacy-activities-78849c8548-ln5sl               1/1    Running           4         6m11s
codacy-activitiesdb-0                            1/1    Running           0         6m3s
codacy-api-6f44c8d48-6bw8z                       1/1    Running           0         6m11s
codacy-api-6f44c8d48-h6cl4                       1/1    Running           0         6m11s
codacy-api-6f44c8d48-vgbl5                       1/1    Running           0         6m11s
codacy-core-786c6f79f-7sn7p                      1/1    Running           0         6m11s
codacy-core-786c6f79f-pvg9w                      1/1    Running           0         6m11s
codacy-crow-59dcfd57f-zpdrw                      1/1    Running           3         6m10s
codacy-crowdb-0                                  1/1    Running           0         6m6s
codacy-engine-5ffcddf77b-nrs8n                   1/1    Running           1         6m10s
codacy-engine-5ffcddf77b-s229m                   1/1    Running           2         6m10s
codacy-fluentdoperator-6qxpb                     2/2    Running           0         5m58s
codacy-fluentdoperator-djf8f                     2/2    Running           0         5m59s
codacy-fluentdoperator-jx269                     2/2    Running           0         5m57s
codacy-fluentdoperator-mlpz5                     2/2    Running           0         5m59s
codacy-fluentdoperator-xbmw9                     2/2    Running           0         5m59s
codacy-hotspots-api-5978df9455-6q2sv             1/1    Running           3         6m10s
codacy-hotspots-api-5978df9455-nlzwv             1/1    Running           3         6m10s
codacy-hotspots-worker-cbc9dfb7c-dxdqs           1/1    Running           3         6m10s
codacy-hotspots-worker-cbc9dfb7c-jjw4q           1/1    Running           3         6m10s
codacy-hotspotsdb-0                              1/1    Running           0         6m4s
codacy-listener-7c6ff5f8cd-hbgh2                 1/1    Running           2         6m10s
codacy-listenerdb-0                              1/1    Running           0         6m4s
codacy-minio-847c574d94-spbbz                    1/1    Running           0         6m10s
codacy-nfsserverprovisioner-0                    1/1    Running           0         6m3s
codacy-portal-74bf7887db-fvzvz                   1/1    Running           3         6m9s
codacy-portal-74bf7887db-h7tb6                   1/1    Running           4         6m9s
codacy-postgres-0                                1/1    Running           0         6m1s
codacy-rabbitmq-ha-0                             1/1    Running           0         5m58s
codacy-rabbitmq-ha-1                             1/1    Running           0         5m31s
codacy-rabbitmq-ha-2                             1/1    Running           0         5m4s
codacy-ragnaros-8b899c77f-76bw6                  1/1    Running           2         6m9s
codacy-remote-provider-service-7974696f8d-tccvj  1/1    Running           0         6m9s
codacy-remote-provider-service-7974696f8d-wx6zj  1/1    Running           0         6m9s
codacy-worker-manager-77878c655f-7jmjv           1/1    Running           0         6m8s
codacy-worker-manager-77878c655f-8s4bz           1/1    Running           0         6m9s

==> v1/Role
NAME                                      AGE
codacy-remote-provider-service            12d
codacy-worker-manager                     12d
codacy-worker-manager-worker-permissions  12d

==> v1/RoleBinding
NAME                                      AGE
codacy-remote-provider-service            12d
codacy-worker-manager                     12d
codacy-worker-manager-worker-permissions  12d

==> v1/Secret
NAME                    TYPE    DATA  AGE
codacy-activities       Opaque  3     12d
codacy-activitiesdb     Opaque  1     12d
codacy-api              Opaque  31    12d
codacy-core             Opaque  6     12d
codacy-crow             Opaque  5     12d
codacy-crowdb           Opaque  1     12d
codacy-engine           Opaque  14    12d
codacy-hotspots-api     Opaque  4     12d
codacy-hotspots-worker  Opaque  3     12d
codacy-hotspotsdb       Opaque  1     12d
codacy-listener         Opaque  6     12d
codacy-listenerdb       Opaque  1     12d
codacy-minio            Opaque  2     12d
codacy-portal           Opaque  17    12d
codacy-postgres         Opaque  1     12d
codacy-rabbitmq-ha      Opaque  6     12d
codacy-ragnaros         Opaque  11    12d
codacy-worker-manager   Opaque  17    12d

==> v1/Service
NAME                            TYPE          CLUSTER-IP      EXTERNAL-IP     PORT(S)                                 AGE
codacy-activities               ClusterIP     10.245.117.130  <none>          80/TCP                                  12d
codacy-activitiesdb             ClusterIP     10.245.86.136   <none>          5432/TCP                                12d
codacy-activitiesdb-headless    ClusterIP     None            <none>          5432/TCP                                12d
codacy-api                      LoadBalancer  10.245.218.1    157.245.20.169  80:31652/TCP                            12d
codacy-core                     ClusterIP     10.245.76.203   <none>          80/TCP                                  12d
codacy-crow                     ClusterIP     10.245.149.46   <none>          80/TCP                                  12d
codacy-crowdb                   ClusterIP     10.245.204.138  <none>          5432/TCP                                12d
codacy-crowdb-headless          ClusterIP     None            <none>          5432/TCP                                12d
codacy-engine                   ClusterIP     10.245.196.196  <none>          80/TCP,9001/TCP                         12d
codacy-hotspots-api             ClusterIP     10.245.16.156   <none>          80/TCP                                  12d
codacy-hotspots-worker          ClusterIP     10.245.123.189  <none>          80/TCP                                  12d
codacy-hotspotsdb               ClusterIP     10.245.208.1    <none>          5432/TCP                                12d
codacy-hotspotsdb-headless      ClusterIP     None            <none>          5432/TCP                                12d
codacy-listener                 ClusterIP     10.245.56.148   <none>          80/TCP                                  12d
codacy-listenerdb               ClusterIP     10.245.67.58    <none>          5432/TCP                                12d
codacy-listenerdb-headless      ClusterIP     None            <none>          5432/TCP                                12d
codacy-minio                    ClusterIP     10.245.127.197  <none>          9000/TCP                                12d
codacy-nfsserverprovisioner     ClusterIP     10.245.159.117  <none>          2049/TCP,20048/TCP,51413/TCP,51413/UDP  12d
codacy-portal                   ClusterIP     10.245.104.235  <none>          80/TCP                                  12d
codacy-postgres                 ClusterIP     10.245.20.80    <none>          5432/TCP                                12d
codacy-postgres-headless        ClusterIP     None            <none>          5432/TCP                                12d
codacy-rabbitmq-ha              ClusterIP     None            <none>          15672/TCP,5672/TCP,4369/TCP             12d
codacy-rabbitmq-ha-discovery    ClusterIP     None            <none>          15672/TCP,5672/TCP,4369/TCP             12d
codacy-ragnaros                 ClusterIP     10.245.172.99   <none>          80/TCP                                  12d
codacy-remote-provider-service  ClusterIP     10.245.247.247  <none>          80/TCP,5701/TCP                         12d
codacy-worker-manager           ClusterIP     10.245.211.195  <none>          80/TCP                                  12d

==> v1/ServiceAccount
NAME                                      SECRETS  AGE
codacy-fluentdoperator                    1        12d
codacy-minio                              1        12d
codacy-nfsserverprovisioner               1        12d
codacy-rabbitmq-ha                        1        12d
codacy-remote-provider-service            1        12d
codacy-worker-manager                     1        12d
codacy-worker-manager-worker-permissions  1        12d

==> v1/StatefulSet
NAME                         READY  AGE
codacy-nfsserverprovisioner  1/1    12d

==> v1/StorageClass
NAME                         PROVISIONER                                AGE
codacy-listener-cache-class  cluster.local/codacy-nfsserverprovisioner  12d

==> v1beta1/ClusterRole
NAME                    AGE
codacy-fluentdoperator  12d

==> v1beta1/ClusterRoleBinding
NAME                    AGE
codacy-fluentdoperator  12d

==> v1beta1/CronJob
NAME                         SCHEDULE   SUSPEND  ACTIVE  LAST SCHEDULE  AGE
codacy-listener-nfs-cleanup  0 0 * * 6  False    0       4d15h          12d

==> v1beta1/DaemonSet
NAME                    DESIRED  CURRENT  READY  UP-TO-DATE  AVAILABLE  NODE SELECTOR  AGE
codacy-fluentdoperator  5        5        5      5           5          <none>         12d

==> v1beta1/PodDisruptionBudget
NAME                            MIN AVAILABLE  MAX UNAVAILABLE  ALLOWED DISRUPTIONS  AGE
codacy-activities               N/A            1                0                    12d
codacy-api                      N/A            1                1                    5d22h
codacy-core                     N/A            1                1                    12d
codacy-engine                   N/A            1                1                    12d
codacy-hotspots-api             N/A            1                1                    12d
codacy-hotspots-worker          N/A            1                1                    12d
codacy-listener                 N/A            1                1                    12d
codacy-portal                   N/A            1                1                    12d
codacy-remote-provider-service  N/A            1                1                    26h
codacy-worker-manager           N/A            1                1                    5d22h

==> v1beta1/Role
NAME                AGE
codacy-rabbitmq-ha  12d

==> v1beta1/RoleBinding
NAME                AGE
codacy-rabbitmq-ha  12d

==> v1beta1/StatefulSet
NAME                READY  AGE
codacy-rabbitmq-ha  3/3    12d

==> v1beta2/StatefulSet
NAME                 READY  AGE
codacy-activitiesdb  1/1    12d
codacy-crowdb        1/1    12d
codacy-hotspotsdb    1/1    12d
codacy-listenerdb    1/1    12d
codacy-postgres      1/1    12d
```

## Next steps - Making it "Production Ready"

1.  Use the `values-production.yaml` file as [reference](https://raw.githubusercontent.com/codacy/chart/master/codacy/values-production.yaml)

    -   [Use external DBs](../configuration/external-dbs.md) (Ideally a cloud managed postgres)
    -   Enable persistence on `listener`
    -   Enable persistence on `minio`
    -   Setup resources and limits
    -   Enable the Ingress on `codacy-api`

2.  [Setup a git provider](../configuration/providers/index.md)

3.  Start configuring Codacy in the UI

    -   Create an administrator account
    -   Create an initial organization
    -   Invite users

4.  Proceed to more advanced [configurations](../configuration/index.md).
