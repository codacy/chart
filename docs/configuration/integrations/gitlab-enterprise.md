# GitLab Enterprise

Follow the instructions below to set up the Codacy integration with GitLab Enterprise:

1.  Open `<gitlab enterprise url>/profile/applications`, where `<gitlab enterprise url>` is the URL of your GitLab Enterprise instance.

2.  Fill in the fields to register your Codacy instance on GitLab:

    -   **Name:** Name of the application. For example, `Codacy`.

    -   **Redirect URI:** Copy the URLs below, updating the HTTP protocol and hostname to the correct values of your Codacy instance. This field is case sensitive.

        ```text
        https://<codacy hostname>/login/GitLab
        https://<codacy hostname>/add/addPermissions/GitLab
        https://<codacy hostname>/add/addProvider/GitLab
        https://<codacy hostname>/add/addService/GitLab
        ```

    -   **Scopes:** Enable the scopes:
    
        - `api`
        - `read user`
        - `read repository`

3.  Click **Save application** and take note of the generated Application Id and Secret.

4.  Edit the file `values-production.yaml` that you used to [install Codacy](../../index.md#helm-upgrade).

5.  Set `global.gitlabEnterprise.enabled: "true"` and define the remaining values as described below using the information obtained when you created the GitLab application:

    ```yaml
    gitlabEnterprise:
      enabled: "true"
      login: "true" # Show login button for GitLab
      hostname: "example.host.com" # Hostname of your GitLab Enterprise instance
      protocol: "https" # Protocol of your GitLab Enterprise instance
      port: 443 # Port of your GitLab Enterprise instance
      clientId: a000000000000000 # Application ID
      clientSecret: a000000000000000 # Secret
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
