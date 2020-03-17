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
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.36/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.36/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.36/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.36/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.36/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.36/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml

sleep 5 # wait for crds to be created

helm upgrade --install monitoring stable/prometheus-operator \
  --version 6.9.3 \
  --namespace monitoring \
  --set prometheusOperator.createCustomResource=false \
  --set grafana.service.type=NodePort\
  --set grafana.adminPassword="CHANGE_HERE"

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

The `crow` tool can be accessed through the `/monitoring` path of the url pointing to your Codacy installation, e.g. `http://codacy.company.org/monitoring`.
You must set the `crow.config.codacy.url` and `crow.config.crow.url` values in your `values.yaml` file so that anchor links to your projects can be properly established inside `crow`.

You must also provide a `CROW_PASSWORD` environment variable for your Crow password:

```bash
  export CROW_PASSWORD=<--- crow password --->
```

Please see the [README.md](../../README.md) for more information about these values.

**Important note**

This tool is in the process of being replaced by Grafana (which will handle authentication) and therefore the credentials to login can be freely shared since there is no sensitive information displayed in the platform. The current credentials are the following:

    username: codacy
    password: C0dacy123
