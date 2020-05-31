# HTTPS on Amazon EKS

This documentation guides you on how to set up HTTPS for Codacy running on your Amazon EKS cluster.

For this, we will use:

-   The [cert-manager](https://cert-manager.io) Kubernetes certificate management controller, configured to issue certificates from [Let's Encrypt](https://letsencrypt.org/) (a certificate authority providing free TLS certificates)

-   The [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/) to perform TLS termination

## 1. Preparing to set up HTTPS

Start by performing the following steps:

1.  Make sure that your network resources are correctly tagged, and create the following required tags if they are missing:

    | Resource Type    | Key = Value                                                                                   |
    | ---------------- | --------------------------------------------------------------------------------------------- |
    | VPC              | `kubernetes.io/cluster/codacy-cluster` = `shared`                                             |
    | Subnet (public)  | `kubernetes.io/cluster/codacy-cluster` = `shared`<br/>`kubernetes.io/role/elb` = `1`          |
    | Subnet (private) | `kubernetes.io/cluster/codacy-cluster` = `shared`<br/>`kubernetes.io/role/internal-elb` = `1` |

    For more information refer to the [AWS documentation](https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html#vpc-tagging).

2.  Add the following chart repositories to Helm:

    ```bash
    helm repo add stable https://kubernetes-charts.storage.googleapis.com
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    ```

## 2. Installing the NGINX Ingress Controller

Install the NGINX Ingress Controller:

1.  Download the configuration file [`values-nginx.yaml`](https://raw.githubusercontent.com/codacy/chart/master/codacy/values-nginx.yaml) for the NGINX Ingress Controller.

    If you wish to use a private load balancer edit the file and enable the required annotation where indicated.

2.  Install the NGINX Ingress Controller:

    ```bash
    helm upgrade --install --namespace codacy --version 1.39.0 codacy-nginx-ingress stable/nginx-ingress -f values-nginx.yaml
    ```

## 3. Installing the certificate manager

Install and set up cert-manager to issue certificates from Let's Encrypt:

1.  Install the cert-manager custom resources and tag the namespace:

    ```bash
    kubectl label namespace codacy certmanager.k8s.io/disable-validation="true"

    # Kubernetes 1.15+
    # kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.15.1/cert-manager.crds.yaml

    # Kubernetes <1.15
    kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.15.1/cert-manager-legacy.crds.yaml
    ```

2.  Download the certificate issuer configuration file [`issuer-letsencrypt.yaml`](https://raw.githubusercontent.com/codacy/chart/master/codacy/issuer-letsencrypt.yaml), edit the file to set your email address where indicated, and execute:

    ```bash
    kubectl apply --namespace codacy -f issuer-letsencrypt.yaml
    ```

3.  Finally, install the certificate manager.

    Download the cert-manager configuration file [`values-cert-manager.yaml`](https://raw.githubusercontent.com/codacy/chart/master/codacy/values-cert-manager.yaml), and execute:

    ```bash
    helm upgrade --install --version v0.15.1 codacy-cert-manager jetstack/cert-manager \
                 --namespace codacy \
                 --values values-cert-manager.yaml
    ```

## 4. Setting up Ingress

Set up Ingress to use TLS:

1.  Download the Codacy Ingress configuration file for AWS [`values-tls-ingress-aws.yaml`](https://raw.githubusercontent.com/codacy/chart/master/codacy/values-tls-ingress-aws.yaml), and edit the file where indicated.

2.  Apply this configuration by performing a Helm upgrade. To do so append `--values values-tls-ingress-aws.yaml` to the command [used to install Codacy](../index.md#helm-upgrade):

    ```bash
    helm upgrade (...options used to install Codacy...) \
                 --values values-tls-ingress-aws.yaml
    ```

## 5. Setting up DNS

If you haven't done so already, create a DNS A record for your Codacy hostname and set the value to the URL of the Ingress load balancer.

To obtain the Ingress URL, execute:

```bash
kubectl get ingress -n codacy
```
