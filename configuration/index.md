## Configuration

The following table lists the configurable parameters of the Codacy chart and their default values.

| Parameter                           | Description                                                      | Default                                        |
| ----------------------------------- | ---------------------------------------------------------------- | ---------------------------------------------- |
| `replicaCount`                      | Number of replicas deployed                                      | `1`                                            |
| `deploymentStrategy`                | Deployment strategy                                              | `{}`                                           |
| `image.repository`                  | image repository                                                 | `codacy`                                       |
| `image.tag`                         | `codacy` image tag.                                              | `7.9.1-community`                              |
| `image.pullPolicy`                  | Image pull policy                                                | `IfNotPresent`                                 |
| `image.pullSecret`                  | imagePullSecret to use for private repository                    |                                                |
| `command`                           | command to run in the container                                  | `nil` (need to be set prior to 6.7.6, and 7.4) |
| `securityContext.fsGroup`           | Group applied to mounted directories/files                       | `999`                                          |
| `ingress.enabled`                   | Flag for enabling ingress                                        | false                                          |
| `ingress.labels`                    | Ingress additional labels                                        | `{}`                                           |
| `ingress.hosts[0].name`             | Hostname to your Codacy installation                             | `codacy.organization.com`                      |
| `ingress.hosts[0].path`             | Path within the URL structure                                    | /                                              |
| `ingress.tls`                       | Ingress secrets for TLS certificates                             | `[]`                                           |
| `service.type`                      | Kubernetes service type                                          | `ClusterIP`                                    |
| `service.externalPort`              | Kubernetes service port                                          | `9000`                                         |
| `service.internalPort`              | Kubernetes container port                                        | `9000`                                         |
| `service.labels`                    | Kubernetes service labels                                        | None                                           |
| `service.annotations`               | Kubernetes service annotations                                   | None                                           |
| `service.loadBalancerSourceRanges`  | Kubernetes service LB Allowed inbound IP addresses               | None                                           |
| `service.loadBalancerIP`            | Kubernetes service LB Optional fixed external IP                 | None                                           |
| `persistence.enabled`               | Flag for enabling persistent storage                             | false                                          |
| `persistence.annotations`           | Kubernetes pvc annotations                                       | `{}`                                           |
| `persistence.existingClaim`         | Do not create a new PVC but use this one                         | None                                           |
| `persistence.storageClass`          | Storage class to be used                                         | "-"                                            |
| `persistence.accessMode`            | Volumes access mode to be set                                    | `ReadWriteOnce`                                |
| `persistence.size`                  | Size of the volume                                               | None                                           |
| `customCerts.enabled`               | Use `customCerts.secretName`                                     | false                                          |
| `customCerts.secretName`            | Name of the secret which conatins your `cacerts`                 | false                                          |
| `database.type`                     | Set to "mysql" to use mysql database                             | `postgresql`                                   |
| `postgresql.enabled`                | Set to `false` to use external server / mysql database           | `true`                                         |
| `postgresql.postgresServer`         | Hostname of the external Postgresql server                       | `null`                                         |
| `postgresql.postgresPasswordSecret` | Secret containing the password of the external Postgresql server | `null`                                         |
| `postgresql.postgresUser`           | Postgresql database user                                         | `user`                                         |
| `postgresql.postgresPassword`       | Postgresql database password                                     | `pass`                                         |
| `postgresql.postgresDatabase`       | Postgresql database name                                         | `db`                                           |
| `postgresql.service.port`           | Postgresql port                                                  | `5432`                                         |
| `annotations`                       | Codacy Pod annotations                                           | `{}`                                           |
| `resources`                         | Codacy Pod resource requests & limits                            | `{}`                                           |
| `affinity`                          | Node / Pod affinities                                            | `{}`                                           |
| `nodeSelector`                      | Node labels for pod assignment                                   | `{}`                                           |
| `hostAliases`                       | Aliases for IPs in /etc/hosts                                    | `[]`                                           |
| `tolerations`                       | List of node taints to tolerate                                  | `[]`                                           |
| `podLabels`                         | Map of labels to add to the pods                                 | `{}`                                           |


| Parameter                   | Description                          | Default |
| --------------------------- | ------------------------------------ | ------- |
| `global.codacy.url`         | Hostname to your Codacy installation | None    |
| `global.codacy.backendUrl`  | Hostname to your Codacy installation | None    |
| `codacy-api.service.type`   | Hostname to your Codacy installation | None    |
| `codacy-api.config.license` | Codacy license for your installation | None    |

  portal.mailSmtp.host:
    user: ""
    pass: ""
    email: ""

 defaultdb:
    postgresqlUsername: "codacy"
    postgresqlDatabase: "default"
    postgresqlPassword: "PLEASE_CHANGE_ME"
    host:
    service:
      port: 5432

  analysisdb:
    postgresqlUsername: "codacy"
    postgresqlDatabase: "analysis"
    postgresqlPassword: "PLEASE_CHANGE_ME"
    host:
    service:
      port: 5432

  resultsdb:
    postgresqlUsername: "codacy"
    postgresqlDatabase: "results"
    postgresqlPassword: "PLEASE_CHANGE_ME"
    host:
    service:
      port: 5432

  resultsdb201709:
    postgresqlUsername: "codacy"
    postgresqlDatabase: "results201709"
    postgresqlPassword: "PLEASE_CHANGE_ME"
    host:
    service:
      port: 5432

  metricsdb:
    postgresqlUsername: "codacy"
    postgresqlDatabase: "metrics"
    postgresqlPassword: "PLEASE_CHANGE_ME"
    host:
    service:
      port: 5432

  filestoredb:
    postgresqlUsername: "codacy"
    postgresqlDatabase: "filestore"
    postgresqlPassword: "PLEASE_CHANGE_ME"
    host:
    service:
      port: 5432

  jobsdb:
    postgresqlUsername: "codacy"
    postgresqlDatabase: "jobs"
    postgresqlPassword: "PLEASE_CHANGE_ME"
    host:
    service:
      port: 5432

activitiesdb:
    create: true

    imageTag: "9.6.2"
    postgresqlUsername: "codacy"
    postgresqlDatabase: "activities"
    postgresqlPassword: "CHANGE_ME_PLEASE"
    persistence:
        enabled: false

hotspotsdb:
  create: true

  imageTag: "9.6.2"
  postgresqlUsername: "codacy"
  postgresqlDatabase: "hotspots"
  postgresqlPassword: "PLEASE_CHANGE_ME"
  persistence:
    enabled: false
  host: hotspots-hotspotsdb.codacy.svc.cluster.local
  service:
    port: 5432

  cacheSecret: "PLEASE_CHANGE_ME"

  play:
    cryptoSecret: "" # Generate one with `head -c 128 /dev/urandom | base64`

  filestore:
    contentsSecret: "PLEASE_CHANGE_ME"
    uuidSecret: "PLEASE_CHANGE_ME"


  workers:
    genericMax: 100
    dedicatedMax: 100

You can also configure values for the PostgreSQL database via the Postgresql [README.md](https://github.com/kubernetes/charts/blob/master/stable/postgresql/README.md)

For overriding variables see: [Customizing the chart](https://docs.helm.sh/using_helm/#customizing-the-chart-before-installing)
