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

## Setting up monitoring using Crow

Crow is a visualization tool that displays information about the projects and jobs that are pending for analysis, as well as the ones running in the Codacy platform.

The Crow tool is installed alongside Codacy after the helm chart is deployed to the cluster.

The `crow` tool can be accessed through the `/monitoring` path of the url pointing to your Codacy installation, e.g. `http://codacy.company.org/monitoring`.
You must set the `global.codacy.crow.url` value in your `values.yaml` file so that anchor links to your projects can be properly established inside `crow`.
For example:

```yaml
global:
  codacy:
    crow:
      url: "http://codacy.example.com/monitoring"
```

Please see the [README.md](../../README.md) for more information about these values.

### Configuring your credentials

You **should** provide a password for the `crow` installation either through the `values.yaml` file or through a `--set` parameter during the `helm` installation process. This parameter can be configured as follows:

* Through a `--set` parameter:

  ```yaml
  helm upgrade (...) --set crow.config.passwordAuth.password=<--- crow password --->
  ```

* Through the `values.yaml` file:

  ```yaml
  crow:
    config:
      passwordAuth:
        password: <--- crow password --->
  ```

**Failing to do so your `crow` will fall back to using the default credentials as described [below](##Default-credentials).**

## Default credentials

If you have not configured your `crow` credentials as described [above](###Configuring-your-credentials), you can login with the following default credentials:

```yaml
username: codacy
password: C0dacy123
```
