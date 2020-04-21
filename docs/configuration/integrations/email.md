# Emails

## SMTP Configuration

Follow the instructions below to set up the Codacy integration with SMTP to send emails:

1.  Edit the file `values-production.yaml`, set `global.email.enabled: "true"` and define the remaining values with the credentials for your smtp server:

    ```yaml
    email:
        enabled: "true"
        replyTo: "notifications@mycompany.com"
        smtp:
            hostname: "smtp.mycompany.com"
            protocol: "smtps" # smtps | smtp
            username: "my-smtp-username"
            password: "a-s!r0ng-pVsSwORG"
            # port: 25
    ```

3.  Apply this configuration by performing a Helm upgrade. To do so append `--values values-production.yaml` to the command [used to install Codacy](../../index.md#2-installing-codacy):

    ```bash
    helm upgrade (...options used to install Codacy...) \
                 --values values-production.yaml
    ```

After this is done you will be able to receive notifications Emails during usage of the product.
