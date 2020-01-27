# System requirements

To have an enjoyable experience with Codacy, you should have the
following calculations in mind when allocating resources for the
installation and defining the number of concurrent analysis.

Without accounting for analysis ([next section](#analysis)),
you should need at least the following resources:

```text
CPU: 7 CPU
Memory: 39 GB
```

Check the
[values-production.yaml](https://github.com/codacy/chart/blob/master/codacy/values-production.yaml)
file to find a configuration reference that should work for you to run
a "production ready" version of Codacy.

## Analysis

Each analysis runs a maximum number of 4 plugins in parallel (not configurable)

Note: All the following configurations are nested inside the `worker-manager.config`
configuration object, but for simplicity, we decided to omit the full path.

```text
CPU: workerResources.requests.cpu + (pluginResources.requests.cpu * 4)

Memory: workerResources.requests.memory + (pluginResources.requests.memory * 4)

Number of concurrent analysis: workers.genericMax + workers.dedicatedMax
```

Given the previous values, the total number of resources required should be the "per-analysis" amount times the number of concurrent analysis.

## Example

_Maximum of 6 concurrent analysis_

```yaml
worker-manager:
  config:
    workers:
      genericMax: 3
      dedicatedMax: 3
    workerResources:
      limits:
        cpu: 1
        memory: "2Gi"
    pluginResources:
      requests:
        cpu: 0.5
        memory: 1000000000 # 1GB
```

In this example the minimum number of resources required would be:

```text
CPU: 6 * (1 + (0.5 * 4)) = 18 CPU
Memory: 6 * (2 + (1 * 4)) = 36 GB
```

**Total:**

```text
CPU: 7 CPU + 18 CPU = 25 CPU
Memory: 39 GB + 36 GB = 75 GB
```
