# HTTPS using LetsEncrypt

This documentation guides you on how to set up HTTPS for Codacy using (LetsEncript)[https://letsencrypt.org]

For this, we will use:

-   The [cert-manager](https://cert-manager.io) Kubernetes certificate management controller, configured to issue certificates from [Let's Encrypt](https://letsencrypt.org/) (a certificate authority providing free TLS certificates)

-   The [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/) to perform TLS termination. This is already preinstalled if you followed our installation documentation for [microk8s](../infrastructure/microk8s-quickstart.md) or [AWS EKS](../infrastructure/eks-quickstart.md).

## 1. Install the Certificate Manager

Install and set up cert-manager to issue certificates from Let's Encrypt:

1.  Start by adding the following chart repository to Helm:

    ```bash
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    ```

2.  Install the cert-manager custom resources and tag the namespace:

    ```bash
    kubectl label namespace codacy certmanager.k8s.io/disable-validation="true"

    # Kubernetes 1.15+
    # kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.15.1/cert-manager.crds.yaml

    # Kubernetes <1.15
    kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.15.1/cert-manager-legacy.crds.yaml
    ```

3.  Download the certificate issuer configuration file [`issuer-letsencrypt.yaml`](../values-files/issuer-letsencrypt.yaml), edit the file to set your email address where indicated, and execute:

    ```bash
    kubectl apply --namespace codacy -f issuer-letsencrypt.yaml
    ```

4.  Finally, install the certificate manager.

    Download the cert-manager configuration file [`values-cert-manager.yaml`](../values-files/values-cert-manager.yaml), and execute:

    ```bash
    helm upgrade --install --version v0.15.1 codacy-cert-manager jetstack/cert-manager \
                 --namespace codacy \
                 --values values-cert-manager.yaml
    ```

## 2. Set up the Ingress

Set up Ingress to use TLS:

1.  Uncomment the TLS section in the `codacy-ingress` section of your [`values-prodcution.yaml`](../values-files/values-production.yaml) file.

2.  Apply the new configuration by performing a Helm upgrade, using the same options you have previously used to install Codacy.

    ```bash
    helm upgrade (...options used to install Codacy...) \
                 --version {{ version }} 
    ```
