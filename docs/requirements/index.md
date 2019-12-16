# Requirements

If you want to deploy Codacy on Kubernetes, the following requirements must be met:

1.  [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) 1.13 or higher, compatible with your cluster
    ([+/- 1 minor release from your cluster](https://kubernetes.io/docs/tasks/tools/install-kubectl/#before-you-begin)).
2.  [Helm](https://helm.sh/docs/using_helm/#installing-helm) 2.14> &lt;3.0
3.  A Kubernetes cluster, between version 1.13 and 1.15. 16vCPU and 64GB of RAM is the recommended minimum.
4.  Postgres database (<https://support.codacy.com/hc/en-us/articles/360002902573-Installing-postgres-for-Codacy-Enterprise>)

## Resources

### Analysis

To have an enjoyable experience with Codacy, you should have the following
calculations in mind when setting the number of concurrent analysis.

Each analysis runs a maximum number of 4 plugins in parallel (not configurable)

Note: All the following configurations are nested inside the `worker-manager.config`
configuration object, but for simplicity, we decided to omit the full path.

#### CPU

`workerResources.requests.cpu + (pluginResources.requests.cpu * 4)`

#### Memory

`workerResources.requests.memory + (pluginResources.requests.memory * 4)`

#### Number of concurrent analysis

`workers.genericMax + workers.dedicatedMax`

#### Total resources

Given the previous values, the total number of resources required should be the "per-analysis" amount times the number of concurrent analysis.

### Example

##### Maximum of 6 concurrent analysis

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

CPU: `6 * (1 + (0.5 * 4))` = 18 CPU

Memory: `6 * (2 + (1 * 4))` = 36 GB
