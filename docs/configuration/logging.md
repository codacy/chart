# Logging

There are different solutions for you to aggregate logs in your cluster for day to day operation.

Overall, all solutions follow the same model: you have an **agent** on each node to collect and forward the logs, an **aggregator** to persist the logs, and a **UI** that allows you to analyze the logs.

One of the simplest stacks that you could use is:

-   [Fluent Bit](https://github.com/helm/charts/tree/master/stable/fluent-bit) as the agent
-   [Elasticsearch + Kibana](https://github.com/elastic/helm-charts/tree/master/elasticsearch) as the aggregator and UI

To use the suggested stack, run the following commands to install the Fluent Bit and Elasticsearch charts on your cluster:

```bash
helm repo add elastic https://helm.elastic.co
helm install --name elasticsearch elastic/elasticsearch --namespace logging
helm install --name fluent-bit stable/fluent-bit --namespace logging \
    --set backend.type=elasticsearch
```
