## Setting up monitoring using Crow [deprecated]

Crow is a visualization tool that displays information about the projects and jobs that are pending for analysis, as well as the ones running in the Codacy platform.

The Crow tool is installed along side Codacy after the helm chart is deployed to the cluster.

**Important note**

This tool is in the process of being replaced by Grafana (which will handle authentication) and therefore the credentials to login can be freely shared since there is no sensitive information displayed in the platform. The current credentials are the following:

```
username: codacy
password: C0dacy123
```
