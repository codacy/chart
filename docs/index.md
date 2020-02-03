# How to install Codacy on Kubernetes

Before you start, review the following requirements that must be met when provisioning the infrastructure that will host Codacy:

* [Resource requirements](resource-requirements.md)
* Postgres database (follow the documentation on how to [install Postgres for Codacy](https://support.codacy.com/hc/en-us/articles/360002902573-Installing-postgres-for-Codacy-Enterprise))

## Preparing to install Codacy

To deploy Codacy on Kubernetes make sure that you have the specified versions of the following tools installed:

* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) version >= 2.0.0
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv1.html) version 1 (for Amazon EKS only)
* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) version >= 0.12
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) version compatible with your cluster ([within one minor version difference of your cluster](https://kubernetes.io/docs/tasks/tools/install-kubectl/#before-you-begin))
    * By default, this guide will create a version 1.14 cluster
* [Helm client](https://v2.helm.sh/docs/using_helm/#installing-helm) version 2.16.1

Please follow the documentation of the tools above to install them on your operating system. Typically, you can use your package manager to install the tools.

For example, if you use MacOS with [Homebrew](https://brew.sh), the following command installs all the tools:

```bash
brew install awscli terraform kubectl kubernetes-helm
```

## Setting up the Kubernetes infrastructure

To install Codacy you need a Kubernetes cluster, versions 1.14.\* or 1.15.\*.

You can follow one of the guides below to quickly set up a Kubernetes cluster on your cloud infrastructure using Terraform configuration files provided by Codacy:

* [Setting up an Amazon EKS cluster](infrastructure/eks-quickstart.md)
* [Setting up an AKS cluster](infrastructure/aks-quickstart.md)

## Installing Codacy

Install Codacy in an existing Kubernetes cluster with the provided cloud-native Helm chart.

* [Installing Codacy](install.md)

## Post-install configuration

After successfully installing Codacy, follow the post-install configuration steps:

1. Enable the Ingress on `codacy-api`.

1. Start configuring Codacy in the UI. The onboarding process will guide you through the following steps:

    * Create an administrator account
    * Configure one or more of the following supported git providers:
        * [Github Cloud](configuration/git-providers/github-cloud.md)
        * [Github Enterprise](configuration/git-providers/github-enterprise.md)
        * [Gitlab Enterprise](configuration/git-providers/gitlab-enterprise.md)
        * [Bitbucket Enterprise](configuration/git-providers/bitbucket-enterprise.md)
    * Create an initial organization
    * Invite users

1. Finally, we also recommend that you set up logging and monitoring.

    * [Logging](configuration/logging.md)
    * [Monitoring](configuration/monitoring.md)
