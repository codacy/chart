# Upgrade

NOTE: **Note:**
You can retrieve your previous `--set` arguments cleanly, with
`helm get values <release name>`. If you direct this into a file
(`helm get values <release name> > codacy.yaml`), you can safely pass this
file via `-f`. Thus `helm upgrade codacy codacy/codacy -f codacy.yaml`.
This safely replaces the behavior of `--reuse-values`

## Steps

The following are the steps to upgrade Codacy to a newer version:

1.  Extract your previous `--set` arguments with

    ```bash
    helm get values codacy > codacy.yaml
    ```

2.  Decide on all the values you need to set
3.  Perform the upgrade, with all `--set` arguments extracted in step 2

    ```bash
    helm upgrade codacy codacy/codacy \
      -f codacy.yaml \
      --set ...
    ```

4.  If required, force the rollout new versions of pods using

    ```bash
    DEPLOYMENTS=$(kubectl get deployments -n codacy -o jsonpath='{.items[?(@.metadata.name!="codacy-minio")].metadata.name}')
    for app in $DEPLOYMENTS; do
      kubectl patch deployment $app -n codacy -p '{"spec":{"template":{"metadata":{"annotations":{"date": "'$(date +'%Y-%m-%dT%H:%M:%S')'" }}}}}'
      kubectl rollout status "deployment/$app" -n codacy
    done
    ```
