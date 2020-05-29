# HTTPS ingress on EKS

The following documentation provides guidance on how to setup an HTTPS ingress for Codacy in your EKS cluster.

## 0. Check Network Resources' Tags

Before proceeding please make sure your network resources are correctly tagged, and create the required tags if they are missing.
A summary of these tags is given in the following table.

 Resource Type    | Key = Value
 -----------------|-----------------------------------------------------------------------------------------------
 VPC              | `kubernetes.io/cluster/codacy-cluster` = `shared`
 Subnet (public)  | `kubernetes.io/cluster/codacy-cluster` = `shared`<br/>`kubernetes.io/role/elb` = `1`
 Subnet (private) | `kubernetes.io/cluster/codacy-cluster` = `shared`<br/>`kubernetes.io/role/internal-elb` = `1`

For more information please refer to [AWS documentation](https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html)

## 1. Add Chart Repositories

Start by adding following repositories to helm.

```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo add jetstack https://charts.jetstack.io
helm repo update
```

## 2. Install the Nginx Ingress Controller

Obtain configuration file for nginx-ingress, [`values-nginx.yaml`](https://raw.githubusercontent.com/codacy/chart/master/codacy/values-nginx.yaml).
If you wish to use a private load balancer please edit the file by uncommenting the required annotation as indicated therein.
Install nginx-ingress with
```bash
helm upgrade --install --namespace codacy --version 1.39.0 codacy-nginx-ingress stable/nginx-ingress -f values-nginx.yaml
```


## 3. Install the Certificate Manager

### 3a. Create Custom Resources

Install the [cert-manager](https://cert-manager.io) custom resources and tag the namespace:

```bash
kubectl label namespace codacy certmanager.k8s.io/disable-validation="true"

# Kubernetes 1.15+
# kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.15.1/cert-manager.crds.yaml

# Kubernetes <1.15
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.15.1/cert-manager-legacy.crds.yaml

```

### 3a. Setup the Issuer

Obtain the kubernetes template for the issuer, [issuer-letsencrypt.yaml](https://raw.githubusercontent.com/codacy/chart/master/codacy/issuer-letsencrypt.yaml), set your email address where indicated, and run

```bash
kubectl apply --namespace codacy -f issuer-letsencrypt.yaml
```

helm upgrade --install --namespace codacy --version v0.15.1 codacy-cert-manager jetstack/cert-manager -f values-cert-manager.yaml


### 3c. Install the Certificate Manager

Obtain the cert-manager configuration file, [values-cert-manager.yaml](https://raw.githubusercontent.com/codacy/chart/master/codacy/values-cert-manager.yaml), and install it with

```bash
helm upgrade --install --namespace codacy --version v0.15.1 codacy-cert-manager jetstack/cert-manager -f values-cert-manager.yaml
bash
```

## 4. Setup the Ingress

Obtain the Codacy ingress configuration file for AWS, [values-tls-ingress-aws.yaml](https://raw.githubusercontent.com/codacy/chart/master/codacy/values-tls-ingress-aws.yaml), and edit it as indicated. After that update your installation passing this additional file to the [command you previously used to install Codacy](../index.md#helm-upgrade).

```bash
helm upgrade  (...options used to install Codacy...) \
   --values values-tls-ingress-aws.yaml
```

### 5. Setup DNS

Obtain the load balancer URL from
```bash
kubectl get ingress -n codacy
```
and create, if you haven't already, a DNS A record for your Codacy hostname with the URL of this load balancer as value
