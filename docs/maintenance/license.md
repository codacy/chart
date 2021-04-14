---
description: Some changes to your Codacy plan require that you update your Codacy Self-hosted license with a new one provided by a Codacy representative.
---

# Updating your Codacy license

Some changes to your Codacy plan require that you update your Codacy Self-hosted license with a new one provided by a Codacy representative:

1.  Edit the value of `codacy-api.config.license` in the `values-production.yaml` file that you used to install Codacy:

    ```yaml
    codacy-api:
      config:
        license: <--- insert your Codacy license here --->
    ```

2.  Apply the new configuration by performing a Helm upgrade. To do so execute the command [used to install Codacy](../index.md#helm-upgrade):

    !!! important
        **If you're using MicroK8s** you must use the file `values-microk8s.yaml` together with the file `values-production.yaml`.

        To do this, uncomment the last line before running the `helm upgrade` command below.

    ```bash
    helm upgrade (...options used to install Codacy...) \
                 --version {{ version }} \
                 --values values-production.yaml \
                 # --values values-microk8s.yaml
    ```
