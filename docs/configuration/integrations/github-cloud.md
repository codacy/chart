# GitHub Cloud

Follow the instructions below to set up the Codacy integration with GitHub Cloud:

1.  Follow the instructions on [creating a GitHub App](github-app-create.md).

2.  Edit the file `values-production.yaml` that you used to [install Codacy](../../index.md#helm-upgrade).

3.  Set `global.github.enabled: "true"` and define the remaining values as described below using the information obtained when you created the GitHub App:

    ```yaml
    github:
      enabled: "true"
      login: "true" # Show login button for GitHub Cloud
      clientId: "" # Client ID
      clientSecret: "" # Client secret
      app:
        name: "codacy" # GitHub App name
        id: "1234" # App ID
        privateKey: "" # Contents of the .pem file without newlines
    ```

4.  Apply the new configuration by performing a Helm upgrade. To do so execute the command [used to install Codacy](../../index.md#helm-upgrade):

    !!! important
        **If you are using MicroK8s** you must use the file `values-microk8s.yaml` together with the file `values-production.yaml`.
        
        To do this, uncomment the last line before running the `helm upgrade` command below.

    ```bash
    helm upgrade (...options used to install Codacy...) \
                 --values values-production.yaml \
                 # --values values-microk8s.yaml
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
