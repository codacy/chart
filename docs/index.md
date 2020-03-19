# How to install Codacy on Kubernetes

Before you start, review the following requirements that must be met when provisioning the infrastructure that will host Codacy:

-   [System requirements](requirements.md)

## 1. Setting up the Kubernetes infrastructure

You can follow one of the guides below to quickly set up a Kubernetes cluster on your cloud infrastructure using Terraform configuration files provided by Codacy:

-   [Setting up an Amazon EKS cluster](infrastructure/eks-quickstart.md)
-   [Setting up an AKS cluster](infrastructure/aks-quickstart.md)
-   [Setting up a MicroK8s machine](infrastructure/microk8s-quickstart.md)

## 2. Installing Codacy

Install Codacy in an existing Kubernetes cluster with the provided cloud-native Helm chart.

-   [Installing Codacy](install.md)

## 3. Post-install configuration

After successfully installing Codacy, follow the post-install configuration steps:

1.  Enable the Ingress on `codacy-api`.

2.  Start configuring Codacy in the UI. The onboarding process will guide you through the following steps:

    -   Create an administrator account
    -   Configure one or more of the following supported git providers:
        -   [Github Cloud](configuration/git-providers/github-cloud.md)
        -   [Github Enterprise](configuration/git-providers/github-enterprise.md)
        -   [Gitlab Enterprise](configuration/git-providers/gitlab-enterprise.md)
        -   [Bitbucket Enterprise](configuration/git-providers/bitbucket-enterprise.md)
    -   Create an initial organization
    -   Invite users

3.  Finally, we also recommend that you set up logging and monitoring.

    -   [Logging](configuration/logging.md)
    -   [Monitoring](configuration/monitoring.md)
