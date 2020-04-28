# GitLab Enterprise

## Setup

Follow the instructions below to set up the Codacy integration with GitLab Enterprise:

1.  Open `<gitlab enterprise url>/profile/applications`, where `<gitlab enterprise url>` is the URL of your GitLab Enterprise instance.

2.  Fill in the fields to register your Codacy instance on GitLab:

    -   **Name:** Name of the application. For example, `Codacy`.

    -   **Redirect URI:** Copy the URLs below, replacing the HTTP protocol and hostname with the correct values for your Codacy instance. This field is case sensitive.

        ```text
        https://codacy.example.com/login/GitLabEnterprise
        https://codacy.example.com/add/addProvider/GitLabEnterprise
        https://codacy.example.com/add/addService/GitLabEnterprise
        https://codacy.example.com/add/addPermissions/GitLabEnterprise
        ```

    -   **Scopes:** Enable the scopes:
    
        - `api`
        - `read_user`
        - `read_repository`
        - `openid`

    ![GitLab Enterprise application](images/gitlab-enterprise-application.png)

3.  Click **Save application** and take note of the generated Application Id and Secret.

4.  Edit the file `values-production.yaml` that you used to [install Codacy](../../index.md#helm-upgrade).

5.  Set `global.gitlabEnterprise.enabled: "true"` and define the remaining values as described below using the information obtained when you created the GitLab application:

    ```yaml
    gitlabEnterprise:
      enabled: "true"
      login: "true" # Show login button for GitLab Enterprise
      hostname: "gitlab.example.com" # Hostname of your GitLab Enterprise instance
      protocol: "https" # Protocol of your GitLab Enterprise instance
      port: 443 # Port of your GitLab Enterprise instance
      clientId: "" # Application ID
      clientSecret: "" # Secret
    ```

6.  Apply the new configuration by performing a Helm upgrade. To do so execute the command [used to install Codacy](../../index.md#helm-upgrade):

    !!! important
        **If you are using MicroK8s** you must use the file `values-microk8s.yaml` together with the file `values-production.yaml`.
        
        To do this, uncomment the last line before running the `helm upgrade` command below.

    ```bash
    helm upgrade (...options used to install Codacy...) \
                 --values values-production.yaml \
                 # --values values-microk8s.yaml
    ```

After this is done you will be able to use GitLab Enterprise to authenticate to Codacy.

## Troubleshooting

- During an authentication procedure, if you got stuck on the provider and this message is shown
  - ![Invalid redirect URI](./gitlab-invalid-redirect-uri.png)
    It means you have not introduced correctly, the redirect uris when creating the application in GitLabEnterprise
    - Make sure all the urls have the correct Codacy protocol (http or http)
    - Make sure all the urls have the full path with the correct case (it is case sensitive)
    - If you still could not find the problem:
        - Extract the parameter `redirect_uri`, from the browser address bar in GitLabEnterprise where the error appears (e.g.: `https%3A%2F%codacy.example.com%2Flogin%2FGitLabEnterprise`)
        - Decode the value (e.g.: [urldecoder.com](https://www.urldecoder.org/)) (e.g.: `https://codacy.example.com/login/GitLabEnterprise`)
        - Check if the value matches one of the configured ones in the application in GitLabEnterprise
  - ![Invalid application id](./gitlab-invalid-application-id.png)
    It means you have not introduced the application id when configuring GitLabEnterprise on Codacy.
    - Make sure the value matches the one in your GitLabEnterprise application
    - If you still could not find the problem:
        - Extract the parameter `client_id`, from the browser address bar in GitLabEnterprise where the error appears (e.g.: `cca35a2a1f9b9b516ac927d82947bd5149b0e57e922c9e5564ac092ea16a3ccd`)
        - Check if the application id on GitLabEnterprise matches this value
- If you do not understand why they are different, contact [support@codacy.com](mailto:support@codacy.com)
  with all the previous information so they can help you
