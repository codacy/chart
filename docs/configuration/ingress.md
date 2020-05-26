## Add chart repos

```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo add jetstack https://charts.jetstack.io
```


## Install nginx ingress

```yaml
### values-nginx.yaml
controller:
  ingressClass: nginx-codacy
  publishService:
    enabled: true 
```

```bash
helm upgrade --install --namespace codacy --version 1.24.7 codacy-nginx-ingress stable/nginx-ingress -f values-nginx.yaml

kubectl label namespace codacy certmanager.k8s.io/disable-validation="true"
```



## Install certmanager and issuer

### install jetstack crd
```bash
# Kubernetes 1.15+
# kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.15.0/cert-manager.crds.yaml
# Kubernetes <1.15
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.15.0/cert-manager-legacy.crds.yaml

```

### setup issuer
```yaml
### issuer.yaml
apiVersion: cert-manager.io/v1alpha2
kind: Issuer
metadata:
  name: letsencrypt-codacy
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: <account@yourdomain.com>
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt
    # Configure the challenge solvers.
    solvers:
    # An empty selector will 'match' all Certificate resources that
    # reference this Issuer.
    - http01:
        ingress:
          class: nginx-codacy
```

```bash
kubectl apply -n codacy -f issuer.yaml
```


### install cert-manager


```yaml
### values-cert-manager.yaml
webhook:
  enabled: true
ingressShim:
  defaultIssuerName: letsencrypt-codacy
  defaultIssuerKind: Issuer
global:
  leaderElection:
    namespace: codacy
clusterResourceNamespace: codacy
```

```bash
helm upgrade --install --namespace codacy --version v0.15.0 codacy-cert-manager jetstack/cert-manager -f values-cert-manager.yaml
```

## Setup the ingress

```yaml
### values-production.yaml

# (...)

codacy-ingress:
  enabled: true
  ingress:
    annotations:
      kubernetes.io/ingress.class: nginx-codacy
      kubernetes.io/tls-acme: "true"
      cert-manager.io/issuer: letsencrypt-codacy
      nginx.ingress.kubernetes.io/use-regex: "true"
    hostname:
      app: 'hostname.yourdomain.com'
      api: 'hostname.yourdomain.com'
    hosts:
    - host: 'hostname.yourdomain.com'
      paths:
        - /
    tls:
      secretName: k8s-tls
      hosts:
      - host: 'hostname.yourdomain.com'
        paths:
          - /
# (...)
```
