# AKS cluster quickstart \[WIP\]

## Setup cli

<https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest>

for mac

```bash
brew install azure-cli
```

login with:

```bash
az login --use-device-code
```

this is more stable than not using device code.

## Backend

To create backend run:
```bash
cd backend/
terraform init && terraform apply
```

Save the output data and use it to configure the backends of the `main/`
and `setup/` stacks (in `config.tf`).

## Main

To create run:
```bash
cd backend/
terraform init && terraform apply
```

get kubeconfig:

```bash
az aks get-credentials --resource-group codacy-cluster --name codacy-aks-cluster
```

## Setup

To create run:
```bash
cd setup/
terraform init && terraform apply
```
