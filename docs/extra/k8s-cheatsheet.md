# Kubernetes Cheatsheet

## Session Manager SSH

When using AWS Session Manager since the CLI is very limited you will benefit from using this alias:
```bash
alias kubectl='sudo microk8s.kubectl -n codacy'
alias helm='sudo helm'
```

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

## How to clean the namespace

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

### Check uninstall process
ps aux | grep -i kubectl

## Get logs of a service

```bash
kubectl get services
kubectl logs svc/codacy-hotspots-api
```

## Edit configmap

```bash
kubectl get configmaps
kubectl edit configmap codacy-fluentd-config
```

## Restart deployment of daemonset

```bash
kubectl get daemonsets
kubectl rollout restart daemonset/codacy-fluentdoperator

kubectl get deployment
kubectl rollout restart deployment/codacy-api
kubectl rollout status deployment/codacy-api -w
```

## Read logs

### daemonset with multiple containers

```bash
kubectl logs daemonset/codacy-fluentdoperator fluentd -f

# or

kubectl logs daemonset/codacy-fluentdoperator reloader -f
```

### service

```bash
kubectl logs service/codacy-api -f
```

## Open shell inside container

```bash
kubectl exec -it daemonset/codacy-fluentdoperator -c fluentd sh

# or

kubectl exec -it deployment/codacy-api sh
```
