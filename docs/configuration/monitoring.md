# Monitoring

Currently two monitoring solutions are supported:

* [**Crow**](##Setting-up-monitoring-using-Crow) - A simple, lightweight, and builtin monitoring solution.
* [**Prometheus+Grafana+Loki**](##Setting-up-monitoring-using-Grafana,-Prometheus,-and-Loki) - A more comprehensive third-party monitoring solution, for more advanced usage.

## Setting up monitoring using Crow

Crow is a visualization tool that displays information about the projects and jobs
that are pending for analysis, as well as the ones running in the Codacy platform.

The Crow tool is installed alongside Codacy after the helm chart is deployed to the cluster.
It can be accessed through the `/monitoring` path of the url pointing to your Codacy
installation, e.g. `http://codacy.company.org/monitoring`. You must set the
`global.codacy.crow.url` value in your `values.yaml` file so that anchor links to your
projects can be properly established inside `crow`.

For example:

```yaml
global:
  codacy:
    crow:
      url: "http://codacy.example.com/monitoring"
```

Please see the [README.md](https://github.com/codacy/chart/blob/master/README.md) for more information about these values.

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

**If you have not configured your `crow` credentials as described above
the following default credentials will be used:**

```yaml
username: codacy
password: C0dacy123
```

## Setting up monitoring using Grafana, Prometheus, and Loki

[Prometheus](https://prometheus.io) is an open-source systems monitoring and alerting
toolkit. Logs can be collected using [Loki](https://grafana.com/oss/loki/), which is a
horizontally-scalable, highly-available, multi-tenant log aggregation system
It's data can be visualized with [Grafana](https://grafana.com), a widely used
open source analytics and monitoring solution.

The following guide covers the basic installation of the components. This monitoring
stack is considerably more resource demanding than Crow, and is recommended only for
more advanced usage. Furthermore, its installation, configuration, and management
requires a deeper knowledge of Kubernetes as each component must be carefully tweaked
to match your specific use case, using as starting point the values files herein provided.

### Installing CRDs

The simplest way to setup prometheus in your cluster is by using the
[Prometheus-Operator](https://github.com/helm/charts/tree/master/stable/prometheus-operator)
bundle. Start by adding the custom resources required for installing this bundle in your cluster.

NOTE: if installing on MicroK8s use `microk8s.kubectl` instead of `kubectl`

```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.36/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.36/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.36/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.36/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.36/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.36/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml
```

### Install Loki

Obtain the configuration file for Loki, [values-loki.yaml](https://github.com/codacy/chart/blob/master/codacy/values-loki.yaml),
and install it as described below. You may need to edit the storage class for Loki
persistence in this configuration file. While the default setting should suit most use
cases, you may need to adjust it to your specific Kubernetes installation.
For instance, for MicroK8s use `storageClassName: microk8s-hostpath`.

```bash
helm repo add loki https://grafana.github.io/loki/charts

helm upgrade --install --atomic loki loki/loki --version 0.17.0 \
  --recreate-pods --namespace codacy --values values-loki.yaml
```

### Install Promtail

Promtail is an agent which ships the contents of local logs to a Loki instance.
Obtain its configuration file, [values-promtail.yaml](https://github.com/codacy/chart/blob/master/codacy/values-promtail.yaml),
and install it with

```bash
helm upgrade --install --atomic promtail loki/promtail --version 0.13.0 \
  --recreate-pods --namespace codacy --values promtail-values.yaml
```

### Install Prometheus and Grafana

Obtain the [Prometheus bundle](https://github.com/helm/charts/tree/master/stable/prometheus-operator)
configuration file, [values-prometheus-operator.yaml](https://github.com/codacy/chart/blob/master/codacy/values-prometheus-operator.yaml).
You **must edit the Grafana password** for the `admin` user in this file.
Use the following command to install this bundle on your cluster.

```bash
helm upgrade --install --atomic monitoring stable/prometheus-operator --version 6.9.3 \
  --recreate-pods --namespace codacy --values values-prometheus-operator.yaml
```

Follow the [Kubernetes documentation](https://v1-15.docs.kubernetes.io/docs/tasks/administer-cluster/access-cluster-services/#accessing-services-running-on-the-cluster)
to access the Grafana service now running on your cluster, using the method that
best suits your use case.

### Enable Service Dashboards

Now that you have Prometheus and Grafana installed you can enable `serviceMonitors`
and `grafana_dashboards` for Codacy components. To do this create the following
configuration file:

```yaml
# values-monitoring.yaml
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

Apply this configuration by issuing an helm upgrade while passing these additional values.
To do so append `--values values-monitoring.yaml --recreate-pods` to the command used to install
codacy provided in [this documentation](../install.md).

```bash
helm upgrade (...options used to install codacy...) --values values-monitoring-values.yaml --recreate-pods
```
