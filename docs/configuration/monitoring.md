---
description: Instructions on how to set up monitoring for your Codacy Self-hosted instance.
---

# Monitoring

Currently, Codacy Self-hosted supports two monitoring solutions:

-   **[Crow](#setting-up-monitoring-using-crow):** A simple, lightweight, and built-in monitoring solution, enabled by default when you install Codacy.
-   **[Prometheus + Grafana + Loki](#setting-up-monitoring-using-grafana-prometheus-and-loki):** A comprehensive third-party monitoring solution, recommended for more advanced usage.

The sections below provide instructions on how to set up each monitoring solution.

## Setting up monitoring using Crow

Crow displays information about the projects that are pending analysis and the jobs currently running on Codacy.

Crow is installed alongside Codacy when the Helm chart is deployed to the cluster. By default, you can access Crow as follows:

-   **URL:** `http://<codacy hostname>/monitoring`, where `<codacy hostname>` is the hostname of your Codacy instance
-   **Username:** `codacy`
-   **Password:** `C0dacy123`

We highly recommend that you define a custom password for Crow, if you haven't already done it when installing Codacy:

1.  Edit the value of `global.crow.config.passwordAuth.password` in the `values-production.yaml` file that you used to install Codacy:

    ```yaml
    global:
      crow:
        config:
          passwordAuth:
            password: C0dacy123
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

## Setting up monitoring using Grafana, Prometheus, and Loki

[Prometheus](https://prometheus.io) is an open-source systems monitoring and alerting toolkit. Logs can be collected using [Loki](https://grafana.com/oss/loki/), which is a horizontally-scalable, highly-available, multi-tenant log aggregation system. Its data can be visualized with [Grafana](https://grafana.com), a widely used open source analytics and monitoring solution.

This solution is considerably more resource demanding than Crow, and is recommended only for more advanced usage. Furthermore, its installation, configuration, and management require a deeper knowledge of Kubernetes as each component must be carefully tweaked to match your specific use case, using as starting point the `.yaml` values files provided by us.

The instructions below cover the basic installation of the components in this monitoring stack.

### 1. Installing Prometheus

The simplest way to set up Prometheus in your cluster is by using the [Prometheus Operator](https://github.com/helm/charts/tree/master/stable/prometheus-operator) bundle.

Add the custom resources required for installing this bundle in your cluster:

!!! important
    **If you're using MicroK8s** use `microk8s.kubectl` instead of `kubectl`.

```bash
kubectl apply -f "https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml"
kubectl apply -f "https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml"
kubectl apply -f "https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml"
kubectl apply -f "https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml"
kubectl apply -f "https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml"
kubectl apply -f "https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml"
```

### 2. Installing Loki

Obtain the configuration file for Loki, [`values-loki.yaml`](../values-files/values-loki.yaml), and install it by running the command below. While the default storage class setting for Loki persistence should suit most use cases, you may need to adjust it to your specific Kubernetes installation. For instance, for MicroK8s use `storageClassName: microk8s-hostpath`.

```bash
helm repo add loki https://grafana.github.io/loki/charts

kubectl create namespace monitoring

helm upgrade --install --atomic --timeout 600s loki loki/loki \
  --version 0.28.1 --namespace monitoring --values values-loki.yaml
```

### 3. Installing Promtail

Promtail is an agent that ships the contents of local logs to a Loki instance.

Obtain the configuration file for Promtail, [`values-promtail.yaml`](../values-files/values-promtail.yaml), and install it by running the command below.

```bash
helm upgrade --install --atomic --timeout 600s promtail loki/promtail \
  --version 0.22.2 --namespace monitoring --values values-promtail.yaml

```

### 4. Installing Prometheus and Grafana

Obtain the configuration file for the [Prometheus Operator bundle](https://github.com/helm/charts/tree/master/stable/prometheus-operator), [`values-prometheus-operator.yaml`](../values-files/values-prometheus-operator.yaml). Then:

1.  Edit the Grafana password for the `admin` user and the hostname for Grafana in the `values-prometheus-operator.yaml` file.

2.  Install the bundle on your cluster by running the command below.

```bash
helm upgrade --install --atomic --timeout 600s monitoring stable/prometheus-operator \
  --version 8.13.8 --namespace monitoring --values values-prometheus-operator.yaml
```

Follow the [Kubernetes documentation](https://kubernetes.io/docs/tasks/administer-cluster/access-cluster-services/#accessing-services-running-on-the-cluster) to access the Grafana service that's now running on your cluster, using the method that best suits your use case.

### 5. Enable service dashboards

Now that you have Prometheus and Grafana installed you can enable metrics reporting for Codacy components.

1.  Create a file named `values-monitoring.yaml` with the following content:

    ```yaml
    global:
      metrics:
        kamon:
          enabled: true
          prometheusReporter:
            enabled: true
        serviceMonitor:
          enabled: true
        grafana:
          enabled: true
    ```

2.  Apply this configuration by performing a Helm upgrade. To do so append `--values values-monitoring.yaml` to the command [used to install Codacy](../index.md#helm-upgrade):

    ```bash
    helm upgrade (...options used to install Codacy...) \
                 --version {{ version }} \
                 --values values-monitoring.yaml
    ```
