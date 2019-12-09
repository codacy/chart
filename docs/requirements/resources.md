# Resource requirements

In order to have a good experience with Codacy, you should have the following calculations in mind when setting the number of concurrent analysis.

Note: All the following configurations are nexted inside the `worker-manager.config` configutation object, but for simplicity sake we decided to omit the full path.


## Requirements per analysis

Each analysis runs a maximum number 4 plugins in parallel (not configurable)

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

CPU: `6 * (1 + (0.5 * 4))` = 18 CPU

Memory: `6 * (2 + (1 * 4))` = 36 GB



