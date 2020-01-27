# How to install Codacy on Kubernetes

Before you start, review the following requirements that must be met when provisioning the infrastructure that will host Codacy:

*  [Resource requirements](resource-requirements.md)
*  Postgres database (follow the documentation on how to [install Postgres for Codacy](https://support.codacy.com/hc/en-us/articles/360002902573-Installing-postgres-for-Codacy-Enterprise))

## Preparing to install Codacy

To deploy Codacy on Kubernetes, make sure that you have the specified versions of the following tools installed:

*  [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) compatible with your cluster ([+/- 1 minor release from your cluster](https://kubernetes.io/docs/tasks/tools/install-kubectl/#before-you-begin))
*  [Helm](https://helm.sh/docs/using_helm/#installing-helm) 2.14> <3.0

## Setting up the Kubernetes infrastructure

To install Codacy you need a Kubernetes cluster, between version 1.14 and 1.15.

You can follow one of the quickstart guides below to set up a Kubernetes cluster on your cloud infrastructure:

*  [EKS Quickstart](infrastructure/eks-quickstart.md)
*  [AKS Quickstart](infrastructure/aks-quickstart.md)

## Installing Codacy

* [Install Codacy](install.md)

## Post-install configuration

After successfully installing Codacy, go follow the post-installation configuration steps:

*  [Use External Databases](configuration/external-dbs.md)
*  [Logging](configuration/logging.md)
*  [Monitoring](configuration/monitoring.md)
*  Configure one or more of the following supported git providers:
    *  [Github Cloud](configuration/providers/github-cloud.md)
    *  [Github Enterprise](configuration/providers/github-enterprise.md)
    *  [Gitlab Enterprise](configuration/providers/gitlab-enterprise.md)
    *  [Bitbucket Enterprise](configuration/providers/bitbucket-enterprise.md)
