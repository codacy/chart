# GitHub Cloud

## Create a GitHub App

To integrate with GitHub we use a GitHub App.

Follow the guide to [create the application on GitHub](create-github-app.md).

## `values.yaml` configuration

Set your configuration values for the GitHub App on the `values.yaml` file:

| Field                          | Value                     |
| ------------------------------ | ------------------------- |
| `global.github.enabled`        | `true`                    |
| `global.github.app.name`       | See below how to generate |
| `global.github.app.id`         | See below how to generate |
| `global.github.app.privateKey` | See below how to generate |
| `global.github.clientId`       | See below how to generate |
| `global.github.clientSecret`   | See below how to generate |

**Please note that you must go to `http://codacy.example.com/admin/integrations`, select the desired provider and `Test & Save` your configuration for it to be applied.**
