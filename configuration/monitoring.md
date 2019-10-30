## Setting up monitoring using Grafana

```sh
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/master/example/prometheus-operator-crd/alertmanager.crd.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/master/example/prometheus-operator-crd/prometheus.crd.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/master/example/prometheus-operator-crd/prometheusrule.crd.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/master/example/prometheus-operator-crd/servicemonitor.crd.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/master/example/prometheus-operator-crd/podmonitor.crd.yaml
​
sleep 5 # wait for crds to be created
​
helm upgrade --install monitoring stable/prometheus-operator \
  --version 6.9.3 \
  --namespace monitoring \
  --set prometheusOperator.createCustomResource=false \
  --set grafana.service.type=LoadBalancer \
  --set grafana.adminPassword="SOMETHING_TO_BE_CHANGED"
​
kubectl get svc monitoring-grafana -n monitoring
```
