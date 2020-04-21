# GitHub Cloud

Follow the instructions below to set up the Codacy integration with GitHub Cloud:

1.  Follow the instructions on [creating a GitHub App](create-github-app.md).

2.  Edit the file `values-production.yaml`, set `global.github.enabled: "true"` and define the remaining values with the information obtained when you created the GitHub App:

    ```yaml
    github:
      enabled: "true"
      clientId: Iv1.0000000000000000 # Client ID
      clientSecret: a000000000000000 # Client secret
      app:
        name: Codacy # GitHub App name
        id: 00000 # App ID
        privateKey: >
          -----BEGIN RSA PRIVATE KEY-----
          # Private key (contents of the .pem file)
          -----END RSA PRIVATE KEY-----
    ```

3.  Apply this configuration by performing a Helm upgrade. To do so append `--values values-production.yaml` to the command [used to install Codacy](../../index.md#2-installing-codacy):

    ```bash
    helm upgrade (...options used to install Codacy...) \
                 --values values-production.yaml
    ```

After this is done you will be able to use GitHub Cloud to authenticate to Codacy.
