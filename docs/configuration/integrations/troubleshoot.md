# Troubleshooting

The sections below include information to help you troubleshoot issues that you may come across while configuring the integration of Codacy with your Git provider.

If the information provided on this page is not enough to solve your issue, contact [support@codacy.com](mailto:support@codacy.com) providing all the information that you were able to collect while following the troubleshooting instructions.

## GitHub Cloud and GitHub Enterprise authentication {id="github"}

### 404 error

While trying to authenticate on GitHub you get the following error message:

![Invalid client id](images/github-invalid-client-id.png)

This might mean that there is a mismatch in the Client ID that Codacy is using to authenticate on GitHub.

To solve this issue:

1.  Make sure that the value of `clientId` in your `values-production.yaml` file is the same as the Client ID of the [GitHub App that you created](github-app-create.md)
2.  If the values were different, you need to re-execute the `helm upgrade` command as described for [GitHub Cloud](github-cloud.md) or [GitHub Enterprise](github-enterprise.md)

If the error persists:

1.  Take note of the parameter `client_id` in the URL of the GitHub error page (for example, `Iv1.0000000000000000`)
2.  Check if the value of the parameter matches the value of the Client ID of your GitHub App

## GitLab Cloud and GitLab Enterprise authentication {id="gitlab"}

### Invalid redirect URI

While trying to authenticate on GitLab you get the following error message:

![Invalid redirect URI](images/gitlab-invalid-redirect-uri.png)

This might mean that the redirect URIs are not correct in the GitLab application that Codacy is using to authenticate on GitLab.

To solve this issue:

1.  Open the GitLab application that you created on [GitLab Cloud](gitlab-cloud.md#create-application) or [GitLab Enterprise](gitlab-enterprise.md#create-application)
2.  Make sure that all the redirect URIs have the correct protocol for the Codacy instance endpoints, either `http://` or `https://`
3.  Make sure that all the redirect URIs have the full path with the correct case, since the field is case-sensitive

If the error persists:

1.  Take note of the parameter `redirect_uri` in the URL of the GitLab error page (for example, `https%3A%2F%2Fcodacy.example.com%2Flogin%2FGitLab` or `https%3A%2F%2Fcodacy.example.com%2Flogin%2FGitLabEnterprise`)
2.  Decode the value of the parameter using a tool such as [urldecoder.com](https://www.urldecoder.org/) (for example, `https://codacy.example.com/login/GitLab` or `https://codacy.example.com/login/GitLabEnterprise`)
3.  Check if the decoded value matches one of the redirect URIs of your GitLab application

### Unknown client

While trying to authenticate on GitLab you get the following error message:

![Invalid application id](images/gitlab-invalid-application-id.png)

This might mean that there is a mismatch in the Application ID that Codacy is using to authenticate on GitLab.

To solve this issue:

1.  Make sure that the value of `clientId` in your `values-production.yaml` file is the same as the Application ID of the [GitLab Cloud](gitlab-cloud.md#create-application) or [GitLab Enterprise](gitlab-enterprise.md#create-application) application that you created
2.  If the values were different, you need to re-execute the `helm upgrade` command as described for [GitLab Cloud](gitlab-cloud.md#configure) or [GitLab Enterprise](gitlab-enterprise.md#configure)

If the error persists:

1.  Take note of the parameter `client_id` in the URL of the GitLab error page (for example, `cca35a2a1f9b9b516ac927d82947bd5149b0e57e922c9e5564ac092ea16a3ccd`)
2.  Check if the value of the parameter matches the value of the Application ID of your GitLab application

## Bitbucket Cloud authentication {id="bitbucket-cloud"}

### Invalid client_id

While trying to authenticate on Bitbucket Cloud you get the following error message:

![Invalid client_id](images/bitbucket-invalid-client-id.png)

This might mean that there is a mismatch in the OAuth consumer Client ID that Codacy is using to authenticate on Bitbucket Cloud.

To solve this issue:

1.  Make sure that the value of `key` in your `values-production.yaml` file is the same as the Key of the [Bitbucket OAuth consumer that you created](bitbucket-cloud.md#create-oauth)
2.  If the values were different, you need to re-execute the `helm upgrade` command as described for [Bitbucket Cloud](bitbucket-cloud.md#configure)

If the error persists:

1.  Take note of the parameter `client_id` in the URL of the Bitbucket Cloud error page (for example, `r8QJDkkxj8unYfg4Bd`)
2.  Check if the value of the parameter matches the value of the Client ID of your Bitbucket OAuth consumer
