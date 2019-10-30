## Configuration

The following table lists the configurable parameters of the Codacy chart and their default values.

| Parameter                                    | Description                            | Default         |
| -------------------------------------------- | -------------------------------------- | --------------- |
| `global.codacy.url`                          | Hostname to your Codacy installation   | None            |
| `global.codacy.backendUrl`                   | Hostname to your Codacy installation   | None            |
| `codacy-api.service.type`                    | TBD                                    | None            |
| `codacy-api.config.license`                  | Codacy license for your installation   | None            |
| `global.cacheSecret`                         | TBD                                    | None            |
| `global.play.cryptoSecret`                   | TBD                                    | None            |
| `global.filestore.contentsSecret`            | TBD                                    | None            |
| `global.filestore.uuidSecret`                | TBD                                    | None            |
| `global.defaultdb.postgresqlUsername`        | Username of the Postgresql server      | `codacy`        |
| `global.defaultdb.postgresqlDatabase`        | Database name of the Postgresql server | `default`       |
| `global.defaultdb.postgresqlPassword`        | Hostname of the Postgresql server      | None            |
| `global.defaultdb.host`                      | Hostname of the Postgresql server      | None            |
| `global.defaultdb.service.port`              | Port of the Postgresql server          | `5432`          |
| `global.analysisdb.postgresqlUsername`       | Username of the Postgresql server      | `codacy`        |
| `global.analysisdb.postgresqlDatabase`       | Database name of the Postgresql server | `analysis`      |
| `global.analysisdb.postgresqlPassword`       | Hostname of the Postgresql server      | None            |
| `global.analysisdb.host`                     | Hostname of the Postgresql server      | None            |
| `global.analysisdb.service.port`             | Port of the Postgresql server          | `5432`          |
| `global.resultsdb.postgresqlUsername`        | Username of the Postgresql server      | `codacy`        |
| `global.resultsdb.postgresqlDatabase`        | Database name of the Postgresql server | `results`       |
| `global.resultsdb.postgresqlPassword`        | Hostname of the Postgresql server      | None            |
| `global.resultsdb.host`                      | Hostname of the Postgresql server      | None            |
| `global.resultsdb.service.port`              | Port of the Postgresql server          | `5432`          |
| `global.resultsdb201709.postgresqlUsername`  | Username of the Postgresql server      | `codacy`        |
| `global.resultsdb201709.postgresqlDatabase`  | Database name of the Postgresql server | `results201709` |
| `global.resultsdb201709.postgresqlPassword`  | Hostname of the Postgresql server      | None            |
| `global.resultsdb201709.host`                | Hostname of the Postgresql server      | None            |
| `global.resultsdb201709.service.port`        | Port of the Postgresql server          | `5432`          |
| `global.metricsdb.postgresqlUsername`        | Username of the Postgresql server      | `codacy`        |
| `global.metricsdb.postgresqlDatabase`        | Database name of the Postgresql server | `metrics`       |
| `global.metricsdb.postgresqlPassword`        | Hostname of the Postgresql server      | None            |
| `global.metricsdb.host`                      | Hostname of the Postgresql server      | None            |
| `global.metricsdb.service.port`              | Port of the Postgresql server          | `5432`          |
| `global.filestoredb.postgresqlUsername`      | Username of the Postgresql server      | `codacy`        |
| `global.filestoredb.postgresqlDatabase`      | Database name of the Postgresql server | `filestore`     |
| `global.filestoredb.postgresqlPassword`      | Hostname of the Postgresql server      | None            |
| `global.filestoredb.host`                    | Hostname of the Postgresql server      | None            |
| `global.filestoredb.service.port`            | Port of the Postgresql server          | `5432`          |
| `global.jobsdb.postgresqlUsername`           | Username of the Postgresql server      | `codacy`        |
| `global.jobsdb.postgresqlDatabase`           | Database name of the Postgresql server | `jobs`          |
| `global.jobsdb.postgresqlPassword`           | Hostname of the Postgresql server      | None            |
| `global.jobsdb.host`                         | Hostname of the Postgresql server      | None            |
| `global.jobsdb.service.port`                 | Port of the Postgresql server          | `5432`          |
| `activities.activitiesdb.postgresqlUsername` | Username of the Postgresql server      | `codacy`        |
| `activities.activitiesdb.postgresqlDatabase` | Database name of the Postgresql server | `jobs`          |
| `activities.activitiesdb.postgresqlPassword` | Hostname of the Postgresql server      | None            |
| `activities.activitiesdb.host`               | Hostname of the Postgresql server      | None            |
| `activities.activitiesdb.service.port`       | Port of the Postgresql server          | `5432`          |
| `hotspots-api.hotspotsdb.postgresqlUsername` | Username of the Postgresql server      | `codacy`        |
| `hotspots-api.hotspotsdb.postgresqlDatabase` | Database name of the Postgresql server | `hotspots`      |
| `hotspots-api.hotspotsdb.postgresqlPassword` | Hostname of the Postgresql server      | None            |
| `hotspots-api.hotspotsdb.host`               | Hostname of the Postgresql server      | None            |
| `hotspots-api.hotspotsdb.service.port`       | Port of the Postgresql server          | `5432`          |
| `engine.workers.genericMax`                  | Port of the Postgresql server          | `100`           |
| `engine.workers.dedicatedMax`                | Port of the Postgresql server          | `100`           |

You can also configure values for the PostgreSQL database via the Postgresql [README.md](https://github.com/kubernetes/charts/blob/master/stable/postgresql/README.md)

For overriding variables see: [Customizing the chart](https://docs.helm.sh/using_helm/#customizing-the-chart-before-installing)
