#!/bin/bash
set -e
doctl kubernetes cluster kubeconfig save "$DOKS_CLUSTER_NAME" --set-current-context
DEPLOYMENTS=$(kubectl get deployments -n codacy | awk '{print "deployment/"$1}' | tail -n +2 )
for DEPLOYMENT in ${DEPLOYMENTS[@]}
do
    kubectl rollout status -n codacy --watch "$DEPLOYMENT"
done