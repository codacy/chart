# Monitoring

In older versions, Codacy was monitored using an application we build
in-house called "Crow". Going forward, we are deprecating Crow and
setting up "Prometheus style" metrics in all our components that
can be accessed using the Prometheus + Grafana ecosystem.

Initially Crow will still be bundled in Codacy helm chart, until
we have all functionality available on Grafana.

## Setting up monitoring using Grafana & Prometheus

The simplest way to setup prometheus in your cluster is by using the
[Prometheus-Operator](https://github.com/helm/charts/tree/master/stable/prometheus-operator)
bundle.

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
  --set grafana.adminPassword="CHANGE_HERE"
​
kubectl get svc monitoring-grafana -n monitoring
```

Now that you have prometheus and grafana you can enable `ServiceMonitors` and `GrafanaDashboards`
for Codacy components:

```yaml
codacy-api:
  metrics:
    serviceMonitor:
      enabled: true
    grafana_dashboards:
      enabled: true
engine:
  metrics:
    serviceMonitor:
      enabled: true
    grafana_dashboards:
      enabled: true
```

## Setting up monitoring using Crow [deprecated]

Crow is a visualization tool that displays information about the projects and jobs that are pending for analysis, as well as the ones running in the Codacy platform.

The Crow tool is installed alongside Codacy after the helm chart is deployed to the cluster.

**Important note**

This tool is in the process of being replaced by Grafana (which will handle authentication) and therefore the credentials to login can be freely shared since there is no sensitive information displayed in the platform. The current credentials are the following:

    username: codacy
    password: C0dacy123
