# Resource requirements

In order to have a good experience with Codacy, you should have the following calculations in mind when allocating resources for the installation and setting the number of concurrent analysis.

## Requirements (not accounting for analysis)

In order to run Codacy, without accounting for analysis (check the next section for analysis requirements) and if you base the installation on the [values-production.yaml](../../codacy/values-production.yaml) file.You should need at least the following resources:

CPU: 7 CPU
Memory: 39 GB

## Requirements per analysis

Each analysis runs a maximum number 4 plugins in parallel (not configurable)

Note: All the configurations on this section are nested inside the `worker-manager.config` configuration object, but for simplicity sake we decided to omit the full path.

### CPU

`workerResources.requests.cpu + (pluginResources.requests.cpu * 4)`

### Memory

`workerResources.requests.memory + (pluginResources.requests.memory * 4)`


### Number of concurrent analysis
`workers.genericMax + workers.dedicatedMax`

### Total resources

Given the previous values, the total number of resources required should be the "per-analysis" amount times the number of concurrent analysis.

## Example

#### Maximum of 6 concurrent analysis

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

**For analysis**:

CPU: `6 * (1 + (0.5 * 4))` = 18 CPU

Memory: `6 * (2 + (1 * 4))` = 36 GB

**Total**:

CPU: `7 CPU + 18 CPU` = 25 CPU

Memory: `39 GB + 36 GB` = 75 GB


