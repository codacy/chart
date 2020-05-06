# Troubleshooting

The sections below include information to help you troubleshoot issues that you may come across while configuring the secrets used by Codacy.

If the information provided on this page is not enough to solve your issue, contact [support@codacy.com](mailto:support@codacy.com) providing all the information that you were able to collect while following the troubleshooting instructions.

## Lost or changed original database secrets

When you open the Codacy UI, an error message states that the secret used to encrypt sensitive data on the database and the one in your configuration file are different.

To solve this issue:

1.  Obtain the correct key from the Codacy logs by executing the following command, where `<namespace>` is the cluster namespace where Codacy is installed:

    ```bash
    bash <(curl -fsSL https://raw.githubusercontent.com/codacy/chart/master/docs/configuration/secrets/extract-codacy-secrets.sh) \
        -n <namespace>
    ```

    You can also download the script [extract-codacy-secrets.sh](extract-codacy-secrets.sh) to run it manually.

2.  Copy the value of the key and update your `values-production.yaml` file with this value.

3.  Apply the new configuration by performing a Helm upgrade. To do so execute the command [used to install Codacy](../../index.md#helm-upgrade):

    !!! important
        **If you are using MicroK8s** you must use the file `values-microk8s.yaml` together with the file `values-production.yaml`.

        To do this, uncomment the last line before running the `helm upgrade` command below.

    ```bash
    helm upgrade (...options used to install Codacy...) \
                 --recreate-pods
                 --values values-production.yaml \
                 # --values values-microk8s.yaml
    ```
