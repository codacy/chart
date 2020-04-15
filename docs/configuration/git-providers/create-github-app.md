# Create and configure a new GitHub App for GitHub Enterprise

## Creating a new GitHub App

Navigate to your GitHub installation Settings > Developer Settings > GitHub Apps > New GitHub App or https://github.example.com/settings/apps/new, where github.example.com is your GitHub Enterprise hostname.


| Field                                   | Value                                                 |
| --------------------------------------- | ----------------------------------------------------- |
| GitHub App name                         | Codacy                                                |
| Homepage URL                            | https://codacy.example.com                            |
| User authorization callback URL         | https://codacy.example.com                            |
| Webhook URL                             | https://codacy.example.com/2.0/events/gh/organization |
| Repository permissions                  |
| Administration                          | Read & Write                                          |
| Checks                                  | Read & Write                                          |
| Issues                                  | Read & Write                                          |
| Metadata                                | Read Only                                             |
| Pull requests                           | Read & Write                                          |
| Webhooks                                | Read & Write                                          |
| Commit statuses                         | Read & Write                                          |
| Organization permissions                |
| Members                                 | Read Only                                             |
| Webhooks                                | Read & Write                                          |
| User permissions                        |
| Email addresses                         | Read Only                                             |
| Git SSH keys                            | Read & Write                                          |
| Where can this GitHub App be installed? | Any account                                           |
