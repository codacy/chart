---
description: Configure log levels and log retention periods for your Codacy Self-hosted instance.
---

# Logging

Currently, Codacy Self-hosted supports two types of log configurations:

-   **[Log level](#setting-up-log-levels):** The severity of the messages that will be shown in logs. We recommend that you don't use a log level lower than WARN, as the logs are useful to troubleshoot any issues in your Codacy Self-hosted instance.
-   **[Log retention period](#configuring-log-retention-period):** The period during which logs will be stored, before being removed by the cleanup job specified in the configuration.

The sections below provide instructions on how to configure each logging configuration.

## Setting up log level

The log level of most components can be configured by editing the value of `COMPONENT.config.logLevel` in the `values-production.yaml` file that is used to install Codacy, like is shown in the example below:
```yaml
worker-manager:
  replicaCount: 2
  config:
    logLevel: WARN
  resources:
    limits:
      cpu: 500m
      memory: 1000Mi
    requests:
      cpu: 200m
      memory: 200Mi
```
The components that currently support this configuration are `codacy-api`, `listener`, `engine`, and `worker-manager`.

The list of supported values for this configuration is shown below. Note that each level also prints the information of the levels higher than it:

-   DEBUG: **Most** verbose level. Logs detailed information on the flow through the system.
-   INFO: Logs interesting events such as application startup and shutdown, important events on the flow of the system, or behavior that is skipped for expected reasons.
-  WARN: Logs runtime events that are unexpected, or undesirable, but not necessarily wrong such as the use of deprecated APIs.
-  ERROR: **Least** verbose level. Only logs runtime errors, or unexpected conditions that prevent the expected behavior from happening.

## Configuring log retention period

As stated in the `values.yaml` file used during deployments, if the `fluentdoperator` is enabled (`enabled:true`), the logs will be collected, and must be cleaned.

To cleanup a bucket in minio, it is necessary to create a bucket lifecycle policy. In the chart repository, Codacy provides a cleaning job template ([lifecycle-police-job.yaml](https://github.com/codacy/chart/blob/master/codacy/templates/fluentd/lifecycle-police-job.yaml)), which will create the policy for you when included in your deployment.

The retention period of your logs can then be configured by editing the value of `fluentdoperator.expirationDays` in the `values.yaml` file, as shown in the example below:

```yaml
fluentdoperator:
  enabled: true
  defaultConfigmap: codacy-fluentd-config
  bucketName: logs
  expirationDays: 7
```
