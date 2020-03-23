# Kubernetes Cheatsheet

## How to install a custom Codacy version

### Install

```bash
sudo git clone git://github.com/codacy/chart -b <YOUR-BRANCH>
helm dep build ./chart/codacy
helm upgrade --install codacy ./chart/codacy/ --namespace codacy --atomic --timeout=300 --values ./<YOUR-VALUES-FILE>
```

### Update

```bash
(cd chart; sudo git fetch --all --prune --tags; sudo git reset --hard origin/<YOUR-BRANCH>;)
helm dep build ./chart/codacy
helm upgrade --install codacy ./chart/codacy/ --namespace codacy --atomic --timeout=300 --values ./<YOUR-VALUES-FILE>
```

## Clean the namespace

```
helm del --purge codacy
kubectl -n codacy delete --all pod &
kubectl -n codacy delete --all pvc &
kubectl -n codacy delete --all pv  &
kubectl -n codacy delete --all job &
sleep 5
kubectl -n codacy patch pvc -p '{"metadata":{"finalizers":null}}' $(kubectl -n codacy get pvc -o jsonpath='{.items[*].metadata.name}')
kubectl -n codacy patch pv -p '{"metadata":{"finalizers":null}}' $(kubectl -n codacy get pv -o jsonpath='{.items[*].metadata.name}')
sleep 5
kubectl -n codacy delete pod $(kubectl -n codacy get pod -o jsonpath='{.items[*].metadata.name}') --force --grace-period=0
kubectl -n codacy get pod &
kubectl -n codacy get pvc &
kubectl -n codacy get pv  &
kubectl -n codacy get job &
```

### Check uninstall was successful
```bash
ps aux | grep -i kubectl
```

## Edit configmap

```bash
kubectl get configmaps
```

**and**

```bash
kubectl edit configmap <configmap-name>
```

## Restart deployment of daemonset

### daemonsets

```bash
kubectl get daemonsets
```

**and**

```bash
kubectl rollout restart daemonset/<daemonset-name>
```


### deployment

```bash
kubectl get deployment
```

**and**

```bash
kubectl rollout restart deployment/<deployment-name>
```

**and**

```bash
kubectl rollout status deployment/<deployment-name> -w
```

## Read logs

### daemonset with multiple containers

```bash
kubectl logs daemonset/<daemonset-name> <container-name> -f
```

### service

```bash
kubectl get svc
```

**and**

```bash
kubectl logs -l $(kubectl get svc/<service-name> -o=json | jq ".spec.selector" | jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' | sed -e 'H;${x;s/\n/,/g;s/^,//;p;};d') -f
```

## Open shell inside container

```bash
kubectl exec -it daemonset/<daemonset-name> -c <container-name> sh
```

**or**

```bash
kubectl exec -it deployment/<deployment-name> sh
```

## microk8s

### Session Manager SSH

When using AWS Session Manager, to connect to the instance where you installed microk8s,
since the CLI is very limited you will benefit from using these aliases:

```bash
alias kubectl='sudo microk8s.kubectl -n <namespace-name>'
alias helm='sudo helm'
```
