# AKS cluster quickstart

## Setup cli

https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest

for mac

```bash
brew install azure-cli
```

login with:

```bash
az login --use-device-code
```

this is more stable than not using device code.

To create backend run:
```bash
cd backend/
terraform init && terraform apply
```
