# GitHub Cloud

Follow the instructions below to set up the Codacy integration with GitHub Cloud:

1.  Follow the instructions on [creating a GitHub App](create-github-app.md).

2.  Edit the file `values-production.yaml`, set `global.github.enabled: "true"` and define the remaining values with the information obtained when you created the GitHub App:

    ```yaml
    github:
      enabled: "true"
      login: "true" # Show login button for GitHub
      clientId: Iv1.0000000000000000 # Client ID
      clientSecret: a000000000000000 # Client secret
      app:
        name: Codacy # GitHub App name
        id: 00000 # App ID
        privateKey: "-----BEGIN RSA PRIVATE KEY-----..." # Contents of the .pem file with newlines removed
          -----END RSA PRIVATE KEY-----
    ```

3.  Apply this configuration by performing a Helm upgrade. To do so append `--values values-production.yaml` to the command [used to install Codacy](../../index.md#2-installing-codacy):

    ```bash
    helm upgrade (...options used to install Codacy...) \
                 --values values-production.yaml
    ```

After this is done you will be able to use GitHub Cloud to authenticate to Codacy.

## Troubleshooting

- During an authentication procedure, if you got stuck on the provider and this message is shown
  - ![Invalid client id](./github-invalid-client-id.png)
    It means you have not introduced the client id when configuring GitHub.com on Codacy.
    - Make sure the value matches the one in your GitHub.com application
    - If you still could not find the problem:
        - Extract the parameter `client_id`, from the browser address bar in GitHub.com where the error appears (e.g.: `Iv1.0000000000000000`)
        - Check if the application id on GitHub.com matches this value
- If you do not understand why they are different, contact [support@codacy.com](mailto:support@codacy.com)
  with all the previous information so they can help you
