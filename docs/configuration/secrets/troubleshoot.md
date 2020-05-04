# Troubleshooting

The sections below include information to help you troubleshoot issues that you may come across while configuring the secrets used by Codacy.

If the information provided on this page is not enough to solve your issue, contact [support@codacy.com](mailto:support@codacy.com) providing all the information that you were able to collect while following the troubleshooting instructions.

## Lost/Changed initially generated secrets

While trying to open Codacy,
you were shown an error message stating that,
the secret on the database and the one in your configuration file are different.

### Steps

1. Get the tail of the logs on the api service

    a. Setup access to the cluster

    b. Get logs and filter by the prefix of the message

        ```sh
        kubectl -n codacy logs deployment/codacy-api | grep -i "Your database is using key"
        ```
        ```
2. Copy the value and update it in your values yaml file

3. Restart the application with the new configuration

    ```bash
    helm upgrade (...options used to install Codacy...) \
                 --recreate-pods
                 --values values-production.yaml \
                 # --values values-microk8s.yaml
    ```
