# Uninstall

To ensure a clean removal you should uninstall Codacy before cleaning destroying
the cluster. To do so run:

```bash
helm del --purge codacy
kubectl delete pvc -n codacy $(kubectl get pvc -n codacy -o jsonpath='{.items[*].metadata.name}') &
kubectl delete pods -n codacy $(kubectl get pods -n codacy -o jsonpath='{.items[*].metadata.name}') --force --grace-period=0
```

Note that the deletion of `pvc`s in the above command has to run in the background
due to a cyclic dependency in one of the components. If you are unsure of these
commands' effect please run the each of the `bash` subcommands and validate their output, viz.

```bash
echo "PVCs to delete:"
kubectl get pvc -n codacy -o jsonpath='{.items[*].metadata.name}'
echo "PODS to delete:"
kubectl get pods -n codacy -o jsonpath='{.items[*].metadata.name}'
```
