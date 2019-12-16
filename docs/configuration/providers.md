## Providers

### GitHub Enterprise

1. Set the following configuration from your GitHub instance on the values.yaml file:

    ```
    gitHubEnterprise:
        hostname: "CHANGE_ME"
        protocol: "CHANGE_ME"
        isPrivateMode: "CHANGE_ME"
        port: "CHANGE_ME"                      # This is an optional field
        disableSSL: "CHANGE_ME"                # This is an optional field
    ```

### GitLab Enterprise

1. Set the following configurations from your GitLab instance on the values.yaml file:

    ```
    gitLabEnterprise:
        hostname: "CHANGE_ME"
        protocol: "CHANGE_ME"
    ```

### Bitbucket Enterprise

1. Set the following configurations from your Bitbucket instance on the values.yaml file:

    ```
    bitbucketEnterprise:
        hostname: "CHANGE_ME"
        protocol: "CHANGE_ME"
    ```
2. Go to the UI, on the Admin Integrations view, and set the **Project Keys** on the Bitbucket enterprise plugin configuration 


For the provider(s) you are using, go to the UI and save the configuration on the Admin Integrations view
