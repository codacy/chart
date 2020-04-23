# Bitbucket Server

Follow the instructions below to set up the Codacy integration with Bitbucket Server:

1.  Follow the instructions on [creating a Bitbucket Server application link](create-bitbucket-server-application-link.md).

2.  Edit the file `values-production.yaml`, set `global.githubEnterprise.enabled: "true"` and define the remaining values as described below and with the information obtained when you created the GitHub App:

    ```yaml
    bitbucketEnterprise:
       enabled: "true"
       login: "true" # Show login button for Bitbucket Server
       hostname: example.host.com # Hostname of your Bitbucket Server instance
       port: 443 # Port of your Bitbucket Server instance
       protocol: https # Protocol of your Bitbucket Server instance
       consumerKey: # Generated when creating the Bitbucket Server application link
       consumerPublicKey: # Generated when creating the Bitbucket Server application link
       consumerPrivateKey: # Generated when creating the Bitbucket Server application link
    ```

3.  Apply this configuration by performing a Helm upgrade. To do so append `--values values-production.yaml` to the command [used to install Codacy](../../index.md#2-installing-codacy):

    ```bash
    helm upgrade (...options used to install Codacy...) \
                 --values values-production.yaml
    ```

After this is done you will be able to use Bitbucket Server to authenticate to Codacy.
