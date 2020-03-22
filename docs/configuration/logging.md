# Logging

## Aggregation of logs for day to day opperation

There are a lot of different solutions for you to have logs in your
cluster. Overall all of them follow the same model, you have an **agent**
on each node, an **aggregator** to persist the logs and a **UI** to analyse the logs. 

One of the simplest stacks ou there is to use:

1. [FluentBit](https://github.com/helm/charts/tree/master/stable/fluent-bit) as the agent
2. [ElasticSearch + Kibana](https://github.com/elastic/helm-charts/tree/master/elasticsearch) for Aggregation and UI

## Quick Installation

```bash
helm repo add elastic https://helm.elastic.co
helm install --name elasticsearch elastic/elasticsearch --namespace logging
helm install --name fluent-bit stable/fluent-bit --namespace logging \
    --set backend.type=elasticsearch
```
