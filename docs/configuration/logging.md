# Logging

This page contains two different sections with different targets:

- Aggregate logs for day to day opperation
- Collect logs [for support](#collect-logs-for-support)

## Aggregation of logs

There are a lot of different solutions for you to have logs in your
cluster. Overall all of them follow the same model, you have an **agent**
on each node, an **aggregator** to persist the logs and a **UI** to analyse the logs. 

One of the simplest stacks ou there is to use:

1. [FluentBit](https://github.com/helm/charts/tree/master/stable/fluent-bit) as the agent
2. [ElasticSearch + Kibana](https://github.com/elastic/helm-charts/tree/master/elasticsearch) for Aggregation and UI

### Quick Installation

```bash
helm repo add elastic https://helm.elastic.co
helm install --name elasticsearch elastic/elasticsearch --namespace logging
helm install --name fluent-bit stable/fluent-bit --namespace logging \
    --set backend.type=elasticsearch
```

## Collect logs for support

To collect logs from your Codacy installation using fluentd change `fluentdoperator.enabled` to true.

```bash
--set fluentdoperator.enabled=true
```

The fluentd daemonset will send the logs to minio which is also installed by this chart.

In order to send them to our support in case of problems, run the following command locally (replacing the `<namespace>` with the namespace in which Codacy was installed):

```bash
kubectl cp <namespace>/$(kubectl get pods -n <namespace> -l app=minio -o jsonpath='{.items[*].metadata.name}'):/export/fluentd-bucket ./logs
```
