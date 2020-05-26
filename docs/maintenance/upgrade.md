# Upgrading Codacy

To upgrade Codacy to the latest stable version:

1.  Store all your currently defined configuration values in a file:

    ```bash
    helm get values codacy \
                    --output yaml \
                    --namespace codacy > codacy.yaml
    ```

2.  Review the values stored in the file `codacy.yaml`, making any changes if necessary.

3.  Perform the upgrade, setting the values stored in the file:

    ```bash
    helm upgrade codacy codacy-stable/codacy \
                 --namespace codacy \
                 --values codacy.yaml
    ```
