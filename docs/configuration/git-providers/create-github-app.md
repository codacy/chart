# Creating a GitHub App

You must create and correctly set up a [GitHub App](https://developer.github.com/apps/about-apps/) to allow Codacy to integrate with GitHub.

To create the GitHub App:

*   **If you're using GitHub Cloud**, open <https://github.com/settings/apps/new>.

*   **If you're using GitHub Enterprise**, open `https://<github hostname>/settings/apps/new`, where `<github hostname>` is the hostname of your own GitHub Enterprise instance.

Then, configure the new GitHub App using the values listed on the table below, replacing `<codacy hostname>` with the hostname of your Codacy instance.

| Field                                   | Value                                                  |
| --------------------------------------- | ------------------------------------------------------ |
| GitHub App name                         | Codacy                                                 |
| Homepage URL                            | `https://<codacy hostname>`                            |
| User authorization callback URL         | `https://<codacy hostname>`                            |
| Webhook URL                             | `https://<codacy hostname>/2.0/events/gh/organization` |
| **Repository permissions**              |                                                        |
| Administration                          | Read & write                                           |
| Checks                                  | Read & write                                           |
| Issues                                  | Read & write                                           |
| Metadata                                | Read only                                              |
| Pull requests                           | Read & write                                           |
| Webhooks                                | Read & write                                           |
| Commit statuses                         | Read & write                                           |
| **Organization permissions**            |                                                        |
| Members                                 | Read only                                              |
| Webhooks                                | Read & write                                           |
| **User permissions**                    |                                                        |
| Email addresses                         | Read only                                              |
| Git SSH keys                            | Read & write                                           |
| Where can this GitHub App be installed? | Any account                                            |
