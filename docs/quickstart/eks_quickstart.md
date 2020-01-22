# EKS cluster setup using terraform

[This folder](https://github.com/codacy/chart/tree/master/docs/quickstart/EKS) includes the terraform templates needed to create an EKS
cluster from scratch, including all the necessary underlying
infrastructure. It includes the following infrastructure stacks:

-   **backend** - (optional) the S3 bucket for storing the terraform state and the DynamoDB table for state locking.
-   **main** - the EKS cluster, including all the network and nodes setup needed to go from zero to a fully functional EKS cluster.
-   **setup** - additional setup you must perform before installing Codacy on your vanilla EKS cluster. Installs things like:
    -   Aws auth (for you to be able to access your cluster using your AWS IAM account)
    -   Docker credentials (to access codacy docker images)
    -   Kubernetes dashboard
    -   Nginx ingress
    -   Cert-manager

Clone the project and go to that directory:

```bash
$ git clone git@github.com:codacy/chart.git
$ cd chart/docs/quickstart/EKS/
```

## Requirements

In order to setup the infrastructure you'll need recent versions of:

-   [awscli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
-   [terraform >= v0.12](https://learn.hashicorp.com/terraform/getting-started/install.html)
-   [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
-   [helm](https://helm.sh/docs/using_helm/#installing-helm)
-   Credentials with access to docker hub (you should receive this with your license)

Please follow the documentation in the above links to setup these tools for your OS.
They can usually be easily installed using your package manager. For instance, on
macOS, if you are using [Homebrew](https://brew.sh), you can just run:

```bash
brew install awscli terraform kubernetes-helm kubectl
```

You'll also need to setup the CLI credentials for your AWS account. See how
to do it the [AWS](https://docs.aws.amazon.com/polly/latest/dg/setup-aws-cli.html)
and [Terraform](https://www.terraform.io/docs/providers/aws/index.html) documentation.
Note that, as stated in the documentation, if your `.aws/credentials` are fairly
complex you might need to set `AWS_SDK_LOAD_CONFIG=1` for Terraform to work correctly.

## TL;DR

### Setting up an EKS cluster for Codacy

Assuming **AWS is well configured** and you fulfill all the prerequisites,
the setup without state storage, can be done with:

```bash
$ export AWS_SDK_LOAD_CONFIG=1
$ cd main/
$ terraform init && terraform apply # should take around 15 mins
$ cd ../setup/
$ terraform init && terraform apply
$ aws eks update-kubeconfig --name codacy-cluster
```

## Deployment - Long version

### 1. `backend` - setup terraform state storage

The [backend](https://www.terraform.io/docs/backends/index.html) stores
the current and historical state of your infrastructure. Deploying and using
it is optional, but it might make your life easier if you are planning to use
these templates to make modifications to the cluster in the future.

To deploy it run:

```bash
terraform init && terraform apply
```

inside the `backend/` folder and follow terraform's instructions.

An S3 bucket with a unique name to save your state will be created. Note this
bucket's name and set it on the `config.tf` file of the `main/` and `setup/`
stacks where indicated.

### 2. `main` - create a vanilla EKS cluster

To create a cluster, along with all the necessary network and nodes setup
it requires:

```bash
terraform init && terraform apply
```

inside the `main/` folder and follow terraform's instructions. This takes a while (~10min).

The cluster configuration (e.g., type/number of nodes, network CIDRs,...)
are exposed as variables in the `variables.tf` file. You may tailor the cluster
to your needs by editing the defaults that file, by using
[CLI](https://www.terraform.io/docs/configuration/variables.html) options, viz.

```bash
terraform apply -var="some_key=some_value"
```

or by writing them on a file named `terraform.tfvars` in the same folder
as the infrastructure code, which is loaded by default when you run apply.
For instance:

```bash
some_key = "a_string_value"
another_key = 3
someting_else = true
```

To connect to the cluster get its `kubeconfig` and set it the as default
context with:

```bash
aws eks update-kubeconfig --name codacy-cluster
```

If you now run

```bash
kubectl get pods -A
```

you'll see that nothing is scheduled. That's because you haven't yet allowed
the worker nodes to join the cluster
(see the [EKS docs](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html) for more info). We'll do that on step 3.

### 3. `setup` - configure your EKS cluster to deploy codacy

Some additional setup  is necessary to run Codacy on the cluster you just created.
For one, you need to allow workers to join the cluster. Docker pull secrets need to be added to the `codacy` namespace, which will also be added here,
and the following helm charts will be installed:
[kubernetes-dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/),
[nginx-ingress](https://github.com/helm/charts/tree/master/stable/nginx-ingress), and
[cert-manager](https://github.com/jetstack/cert-manager).

To do it run

```bash
terraform init && terraform apply
```

You'll be prompted to input Codacy's docker hub repo password.

If you'd like to connect to the kubernetes dashboard, get the admin token
by running

```bash
terraform output admin_token
```

and copy the outputed value. To connect to the dashboard run

```bash
kubectl proxy
```

and then connect to [the dashboard url](http://127.0.0.1:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:https/proxy),
select `token` and paste the value you saved above.

### 4. Installing Codacy

To install Codacy please see the [installation documentation](../installation/index.md).

## Uninstalling

**WARNING: IF YOU PROCEED BEYOND THIS POINT YOU'LL PERMANENTLY DELETE AND BREAK THINGS**

### 1.  Remove the cluster setup required to install Codacy

To cleanup your cluster back to a _vanilla_ state you can now run,
the following command in the `setup/` folder:

```bash
terraform destroy
```

### 2.  Remove the cluster

After removing all the above stacks and setup, you may now delete the kubernetes
cluster by running in the `main/` directory:

```bash
terraform destroy
```

 This takes a while (~10min).

### 3.  Removing the terraform backend

If you created the terraform backend with the above stack you can now safely
delete it. The backend is purposely created with extra settings to prevent
its accidental destruction. To destroy it cleanly the easiest path is to disable
these extra settings. Go to the `backend/` folder and change the `state_and_lock.tf`
file as instructed therein.

Afterwards, you can now destroy it by running

```bash
terraform apply && terraform destroy
```

Note that you first have to apply to change the bucket settings, and only
then will destroy work.
