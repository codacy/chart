#!/usr/bin/env bash

#### Helper functions ####

usage()
{
    echo "Usage: $0 -n <NAMESPACE> "
    exit 3
}

cleanup()
{
    if [ -d "$LOGS_DIR" ]; then
        rm -r $LOGS_DIR &>/dev/null
    fi
}
trap cleanup EXIT

#### Log extraction script ####

while getopts "n:" option; do
    case ${option} in
        n )
            NAMESPACE=${OPTARG}
            ;;
        \? )
            usage
            ;;
    esac
done

[ -z "$NAMESPACE" ] && usage

CURRENT_DATE_TIME=$(date "+%Y%m%d-%H%M%S")
LOGS_DIR="$(mktemp -d)/codacy_logs_$CURRENT_DATE_TIME"

echo "Starting log files extraction"

# Check if kubectl is available
echo "Checking if kubectl is installed..."
if ! kubectl version &>/dev/null; then
    echo "kubectl not installed"
    echo "Please install kubectl version specified in Codacy's documentation (see here - https://codacy.github.io/chart/#preparing-to-install-codacy) or the version used when installing your cluster"
    echo "To install kubectl see https://kubernetes.io/docs/tasks/tools/install-kubectl/"
    echo "Log files extraction failed, exiting..."
    exit 4
fi

# Check current cluster context
echo "Checking access to kubernetes cluster..."
KUBE_CTX=$(kubectl config current-context)
if [ $? -ne 0 ]; then
    echo "No kubernetes cluster context configured"
    echo "Log files extraction failed, exiting..."
    exit 5
fi

read -p "Is '$KUBE_CTX' the correct kubernetes cluster for log extraction? ([yes]/no)" ANSWER
if [[ ! "$ANSWER" =~ ^y(es)?$ ]]; then
    echo "Please configure correctly your current kubernetes cluster"
    echo "Log files extraction failed, exiting..."
    exit 6
fi

# Create temporary directory for copying logs
if ! mkdir -p $LOGS_DIR; then
    echo "Failed to create temporary directory $LOGS_DIR , for log files extraction"
    echo "Log files extraction failed, exiting..."
    exit 7
fi

# Get pod name for the logs pod
echo "Checking if the logs kubernetes pod exists..."
LOGS_POD_NAME=$(kubectl get pods -n $NAMESPACE -l app=minio -o jsonpath='{.items[*].metadata.name}')
if [ $? -ne 0 ]; then
    echo "Failed to get the name of the logs kubernetes pod, for namespace $NAMESPACE"
    echo "Are you sure you are in the right kubernetes cluster context?"
    echo "Log files extraction failed, exiting..."
    exit 8
fi

# Copy logs to local filesystem
echo "Extracting log files..."
if ! kubectl cp $NAMESPACE/$LOGS_POD_NAME:/export/logs $LOGS_DIR; then
    echo "Failed to extract log files from kubernetes pod $LOGS_POD_NAME to local directory $LOGS_DIR"
    echo "Are you sure you are in the right kubernetes cluster context?"
    echo "Log files extraction failed, exiting..."
    exit 9
fi

# Compress logs in ZIP file (-9 is maximum, slowest, compression)
echo "Compressing extracted log files..."
if ! zip -r9 codacy_logs_$CURRENT_DATE_TIME.zip $LOGS_DIR; then
    echo "Failed to compress logs (located in $LOGS_DIR) to a ZIP file"
    echo "If this step continues to fail, you can compress the files manually"
    echo "Log files compression failed, exiting..." 
    exit 10
fi

echo "Log file extraction completed"
