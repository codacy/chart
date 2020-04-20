# GitLab Enterprise

## GitLab Application

Follow the instructions below to set up the Codacy integration with GitLab Cloud:

1.  Create a new application in `<gitlabEnterprise url>/profile/applications`, where `<gitlabEnterprise url>` is the url of your own GitLab Enterprise instance, pointing to your local Codacy deployment URL with `api`, `read user` and `read repository` scopes.

    You'll need to add the following 'Redirect URI'. Make sure to update your protocol to use either http or https and your hostname as well. Keep in mind this field is case sensitive.

    ```
    https://codacy.example.com/login/GitLab
    https://codacy.example.com/add/addPermissions/GitLab
    https://codacy.example.com/add/addProvider/GitLab
    https://codacy.example.com/add/addService/GitLab
    ```

2.  Edit the file `values-production.yaml`, set `global.gitlab.enabled: "true"` and define the remaining values with the information obtained when you created the GitLab Application:

    ```yaml
    gitlab:
      enabled: true
      clientId: a000000000000000 # Client ID
      clientSecret: a000000000000000 # Client secret
    ```

3.  Apply this configuration by performing a Helm upgrade. To do so append `--values values-production.yaml` to the command [used to install Codacy](../../index.md#2-installing-codacy):

    ```bash
    helm upgrade (...options used to install Codacy...) \
                 --values values-production.yaml
    ```

After this is done you will be able to use GitLab Enterprise to authenticate to Codacy.
