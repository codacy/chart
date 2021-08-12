# Creating a GitHub App

You must create and correctly set up a [GitHub App](https://developer.github.com/apps/about-apps/) to allow Codacy Self-hosted to integrate with GitHub.

To create the GitHub App:

1.  **If you're using GitHub Cloud**, open <https://github.com/settings/apps/new>.

    **If you're using GitHub Enterprise**, open `https://github.example.com/settings/apps/new`, replacing the HTTP protocol and hostname with the correct values for your GitHub Enterprise instance.

2.  Configure the new GitHub App using the values listed on the table below, replacing `https://codacy.example.com` with the correct base URL of your Codacy instance.

    | Field                                   | Value                                                   |
    | --------------------------------------- | ------------------------------------------------------- |
    | GitHub App name                         | Codacy                                                  |
    | Homepage URL                            | `https://codacy.example.com`                            |
    | User authorization callback URL         | `https://codacy.example.com`                            |
    | Expire user authorization tokens        | Disabled<br/><br/><strong>⚠️ Note:</strong> Currently, Codacy doesn't support <a href="https://docs.github.com/en/developers/apps/building-github-apps/refreshing-user-to-server-access-tokens" target="_blank">expiring user access tokens</a>. Make sure that this option is turned off. |
    | Webhook URL                             | For GitHub Cloud:<br/>`https://codacy.example.com/2.0/events/gh/organization`<br/><br/>For GitHub Enterprise:<br/>`https://codacy.example.com/2.0/events/ghe/organization` |
    | **Repository permissions**              |                                                         |
    | Administration                          | Read & write                                            |
    | Checks                                  | Read & write                                            |
    | Issues                                  | Read & write                                            |
    | Metadata                                | Read only                                               |
    | Pull requests                           | Read & write                                            |
    | Webhooks                                | Read & write                                            |
    | Commit statuses                         | Read & write                                            |
    | **Organization permissions**            |                                                         |
    | Members                                 | Read only                                               |
    | Webhooks                                | Read & write                                            |
    | **User permissions**                    |                                                         |
    | Email addresses                         | Read only                                               |
    | Git SSH keys                            | Read & write                                            |
    | Where can this GitHub App be installed? | Any account                                             |

3.  Scroll to the bottom of the page, click **Generate a private key**, and save the `.pem` file containing the private key.

4.  Take note of the following information, as you'll need it to configure Codacy:

    -   GitHub App name 
    -   App ID
    -   Client ID
    -   Client secret
    -   Private key (contents of the `.pem` file generated in the previous step)
