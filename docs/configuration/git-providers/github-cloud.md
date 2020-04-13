# GitHub Cloud

## `values.yaml` configuration

Set your configuration values for your GitHub instance on the `values.yaml` file:

| Field                          | Value                     |
| ------------------------------ | ------------------------- |
| `global.github.enabled`        | `true`                    |
| `global.github.app.name`       | See below how to generate |
| `global.github.app.id`         | See below how to generate |
| `global.github.app.privateKey` | See below how to generate |

**Please note that you must go to `http://codacy.example.com/admin/integrations`, select the desired provider and `Test & Save` your configuration for it to be applied.**

## Create a GitHub App

To integrate with GitHub we use a GitHub App.

Follow the guide to [create the application on GitHub](create-github-app.md).

## Set credentials

After the application is created, you should copy both the `Client ID` and the `Client Secret` and paste them in the setup page on your Codacy Self-hosted.

![GitHub Application](./images/github-token-retrieval.png)

After this is done you will be able to use GitHub Enterprise as an authentication method to add repositories and as an integration in the repository settings.
