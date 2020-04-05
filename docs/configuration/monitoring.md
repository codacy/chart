# Monitoring

Currently, we support two monitoring solutions:

-   **[Crow](#setting-up-monitoring-using-crow):** A simple, lightweight, and built-in monitoring solution.
-   **[Prometheus + Grafana + Loki](#setting-up-monitoring-using-grafana-prometheus-and-loki):** A comprehensive third-party monitoring solution, recommended for more advanced usage.

The sections below provide details on how to set up each monitoring solution.

## Setting up monitoring using Crow

Crow displays information about the projects that are pending analysis and the jobs currently running on Codacy.

The Crow tool is installed alongside Codacy when the Helm chart is deployed to the cluster and is configured as follows by default:

-   Crow is available on the `/monitoring` path of your Codacy installation URL, such as `http://codacy.company.org/monitoring`
-   The default credentials to access Crow are:

    ```yaml
    username: codacy
    password: C0dacy123
    ```

Follow the steps below to configure Crow and change the default configurations:

1.  Set the `global.codacy.crow.url` value in your `values.yaml` file so that Crow correctly generates anchor links to your projects. For example:

    ```yaml
    global:
      codacy:
        crow:
          url: "http://codacy.example.com/monitoring"
    ```

2.  Set the `crow.config.passwordAuth.password` value in your `values.yaml` file to define a custom password for Crow:

    ```yaml
    crow:
      config:
        passwordAuth:
          password: <--- Crow password --->
    ```

3.  Upgrade the Helm release with the updated `values.yaml` file: 


4.  Apply this configuration by performing a Helm upgrade. To do so append `--values values.yaml` to the command [used to install Codacy](../index.md#2-installing-codacy):

    ```bash
    helm upgrade (...options used to install Codacy...) \
                 --values values.yaml
    ```

## Setting up monitoring using Grafana, Prometheus, and Loki

[Prometheus](https://prometheus.io) is an open-source systems monitoring and alerting toolkit. Logs can be collected using [Loki](https://grafana.com/oss/loki/), which is a horizontally-scalable, highly-available, multi-tenant log aggregation system. Its data can be visualized with [Grafana](https://grafana.com), a widely used open source analytics and monitoring solution.

This solution is considerably more resource demanding than Crow, and is recommended only for more advanced usage. Furthermore, its installation, configuration, and management require a deeper knowledge of Kubernetes as each component must be carefully tweaked to match your specific use case, using as starting point the `.yaml` values files provided by us.

The instructions below cover the basic installation of the components in this monitoring stack.

### 1. Installing Prometheus

The simplest way to set up Prometheus in your cluster is by using the [Prometheus Operator](https://github.com/helm/charts/tree/master/stable/prometheus-operator) bundle.

Add the custom resources required for installing this bundle in your cluster:

!!! important
    **If you are using MicroK8s** use `microk8s.kubectl` instead of `kubectl`.

```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.36/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.36/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.36/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.36/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.36/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/release-0.36/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml
```

### 2. Installing Loki

Obtain the configuration file for Loki, [`values-loki.yaml`](https://github.com/codacy/chart/blob/master/codacy/values-loki.yaml), and install it by running the command below. While the default storage class setting for Loki persistence should suit most use cases, you may need to adjust it to your specific Kubernetes installation. For instance, for MicroK8s use `storageClassName: microk8s-hostpath`.

```bash
helm repo add loki https://grafana.github.io/loki/charts
helm upgrade --install --atomic loki loki/loki --version 0.17.0 \
             --recreate-pods --namespace codacy --values values-loki.yaml
```

### 3. Installing Promtail

Promtail is an agent that ships the contents of local logs to a Loki instance.

Obtain the configuration file for Promtail, [`values-promtail.yaml`](https://github.com/codacy/chart/blob/master/codacy/values-promtail.yaml), and install it by running the command below.

```bash
helm upgrade --install --atomic promtail loki/promtail --version 0.13.0 \
             --recreate-pods --namespace codacy --values promtail-values.yaml
```

### 4. Installing Prometheus and Grafana

Obtain the configuration file for the [Prometheus Operator bundle](https://github.com/helm/charts/tree/master/stable/prometheus-operator), [`values-prometheus-operator.yaml`](https://github.com/codacy/chart/blob/master/codacy/values-prometheus-operator.yaml). Then:

1.  Edit the Grafana password for the `admin` user in the `values-prometheus-operator.yaml` file.

2.  Install the bundle on your cluster by running the command below.

    ```bash
    helm upgrade --install --atomic monitoring stable/prometheus-operator --version 6.9.3 \
                 --recreate-pods --namespace codacy --values values-prometheus-operator.yaml
    ```

Follow the [Kubernetes documentation](https://v1-15.docs.kubernetes.io/docs/tasks/administer-cluster/access-cluster-services/#accessing-services-running-on-the-cluster) to access the Grafana service that is now running on your cluster, using the method that best suits your use case.

### 5. Enable Service Dashboards

Now that you have Prometheus and Grafana installed you can enable `serviceMonitors` and `grafana_dashboards` for Codacy components.

1.  Create a file named `values-monitoring.yaml` with the following content:

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

2.  Apply this configuration by performing a Helm upgrade. To do so append `--values values-monitoring.yaml --recreate-pods` to the command [used to install Codacy](../index.md#2-installing-codacy):

    ```bash
    helm upgrade (...options used to install Codacy...) \
                --values values-monitoring.yaml --recreate-pods
    ```
