# Upgrading Codacy

To upgrade Codacy to the latest stable version:

1.  Store all your currently defined configuration values in a file:

    ```bash
    helm get values codacy \
                    --namespace codacy \
                    --output yaml > codacy.yaml

    ```

    !!! note
        If you installed Codacy on a Kubernetes namespace different from `codacy`, make sure that you adjust the namespace when executing the commands in this page.

2.  Review the values stored in the file `codacy.yaml`, making any changes if necessary.

3.  Perform the upgrade using the values stored in the file:

    ```bash
    helm upgrade codacy codacy-stable/codacy \
                 --namespace codacy \
                 --values codacy.yaml
    ```
