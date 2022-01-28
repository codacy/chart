---
description: Instructions on how to configure log levels and log retention periods for your Codacy Self-hosted instance.
---

# Logging

Currently, Codacy Self-hosted supports two types of log configuration:

-   **[Log level](#setting-up-log-levels):** The severity of the messages that will be shown in logs (we recommend not going lower than WARN, as the logs are used to troubleshoot any problems).
-   **[Log retention period](#configuring-log-retention-period):** The period during which logs will be stored, before being removed by the cleanup job specified in the configuration.

The sections below provide instructions on how to configure each logging configuration.

## Setting up log level

The log level of most components can be configured by editing the value of `COMPONENT.config.logLevel` in the `values-production.yaml` file that is used to install Codacy, like is shown in the example below:
```
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
And the list of supported values for this configuration are shown below. Note that each level also prints the information of the levels higher than it:
* DEBUG - **Most** verbose level. Logs detailed information on the flow through the system.
* INFO - Logs interesting events such as application startup and shutdown, important events on the flow of the system, or behaviour that is skipped for expected reasons.
* WARN - Logs runtime events that are unexpected, or undesirable, but not necessarily wrong such as use of deprecated APIs.
* ERROR - **Least** verbose level. Only logs runtime errors, or unexpected conditions that prevent the expected behaviour from happening.

## Configuring log retention period

If you want to change the log retention period,
