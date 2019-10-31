# Installing Codacy using Helm

Install Codacy on Kubernetes with the cloud native Codacy Helm chart.

## Requirements

If you want to deploy Codacy on Kubernetes, the following requirements must be met:

1. kubectl 1.13 or higher, compatible with your cluster
   ([+/- 1 minor release from your cluster](https://kubernetes.io/docs/tasks/tools/install-kubectl/#before-you-begin)).
2. Helm 2.14 or higher.
3. A Kubernetes cluster, version 1.13 or higher. 16vCPU and 64GB of RAM is recommended.
4. Nginx ingress (or some other ingress controller)
5. CertManager (if you want to setup https)
6. Postgres database (https://support.codacy.com/hc/en-us/articles/360002902573-Installing-postgres-for-Codacy-Enterprise)

## Environment setup

Before proceeding to deploying Codacy, you need to prepare your environment.

### Tools

[`helm`](https://helm.sh/docs/using_helm/#installing-helm) and [`kubectl`](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-macos) need to be installed.

### Cloud cluster preparation

NOTE: **Note**:
[Kubernetes 1.13 or higher is required](#requirements), due to the usage of certain
Kubernetes features.

Follow the instructions to create and connect to the Kubernetes cluster of your
choice:

- [Amazon EKS](../installation/cloud/eks.md)
- On-Premises solutions - Documentation to be added.

## Deploying Codacy

With the environment set up and configuration generated, you can now proceed to
the [deployment of Codacy](../installation/deployment.md).

## Upgrading Codacy

If you are upgrading an existing Kubernetes installation, follow the
[upgrade documentation](../installation/upgrade.md) instead.
