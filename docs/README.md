# Codacy Self-hosted Installation

To have your setup fully functional, Codacy will need to download the code analyzers after running for the first time. This process can take up to an extra hour, depending on network speed.

## Installing Codacy using the Helm Chart

The `codacy` chart includes all required dependencies, and takes a few minutes
to deploy:

1. [Preparation](installation/index.md)
1. [Deployment](installation/deployment.md)

## Updating Codacy using the Helm Chart

Once your Codacy Chart is installed, configuration changes and chart updates
should be done using `helm upgrade`:

```sh
helm repo add codacy https://charts.codacy.com/stable/
helm repo update
helm get values codacy > codacy.yaml
helm upgrade codacy codacy/codacy -f codacy.yaml
```

For more detailed information see [Upgrading](installation/upgrade.md).

## Uninstalling Codacy using the Helm Chart

To uninstall the Codacy Chart, run the following:

```sh
helm delete codacy
```


## Requirements
- [All requirements](requirements/index.md)
- [Resource Requirements](requirements/resources.md)

## Installation methods
[All installation guides](installation/index.md)

## Configuration
[All configuration](configuration/index.md)

[Logging](configuration/logging.md)

[Monitoring](configuration/monitoring.md)
