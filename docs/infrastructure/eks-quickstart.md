# Setting up an Amazon EKS cluster

Follow the steps below to set up an Amazon EKS cluster from scratch, including all the necessary underlying infrastructure, using Terraform.

## 1. Prepare your environemnt

Prepare your environment to set up the Amazon EKS cluster:

1. Set up the AWS CLI credentials for your AWS account using the [AWS CLI](https://docs.aws.amazon.com/polly/latest/dg/setup-aws-cli.html) and [Terraform](https://www.terraform.io/docs/providers/aws/index.html) documentation as reference.

    Note that, as stated in the documentation, if your `.aws/credentials` are fairly complex you might need to set `AWS_SDK_LOAD_CONFIG=1` for Terraform to work correctly:

    ```bash
    export AWS_SDK_LOAD_CONFIG=1
    ```

1. Clone the Chart repository and change to the directory that includes the Terraform configuration files provided by Codacy:

    ```bash
    git clone https://github.com/codacy/chart.git
    cd chart/docs/infrastructure/EKS/
    ```

    The folder includes the following infrastructure stacks:

    * **backend**: Optional S3 bucket for storing the Terraform state and the DynamoDB table for state locking
    * **main**: Amazon EKS cluster, including the setup of all network and node infrastructure to go from zero to a fully functional cluster
    * **setup**: Additional setup to be performed before installing Codacy on your vanilla Amazon EKS cluster, such as:
        * AWS auth for you to be able to access your cluster using your AWS IAM account
        * Kubernetes Dashboard
        * NGINX Ingress Controller
        * cert-manager

## 2. Set up the Terraform state storage backend

The [backend](https://www.terraform.io/docs/backends/index.html) stores the current and historical state of your infrastructure.

Although using the backend is optional, we recommend that you deploy it, particularly if you are planning to use these templates to make modifications to the cluster in the future:

1. Initialize Terraform and apply the changes inside the `backend/` directory, then follow Terraform's instructions:

    ```bash
    cd backend/
    terraform init && terraform apply
    ```

    An Amazon S3 bucket with a unique name to save the infrastructure state is created.

1. Note the value of `state_bucket_name` in the output of the command.

1. Edit the `config.tf` files that exist in the `main/` and `setup/` directories and follow the instructions to set the name of the Amazon S3 bucket and to enable the use of the backend in those files.

## 3. Create a vanilla Amazon EKS cluster

Create a cluster that includes all the required network and node setup:

1. Initialize Terraform and apply the changes inside the `main/` directory, then follow Terraform's instructions:

    ```bash
    cd ../main/
    terraform init && terraform apply
    ```

    This process takes around 10 minutes.

1. Consider if you want to tailor the cluster to your needs by customizing the cluster configuration.

    The cluster configuration (such as the type and number of nodes, network CIDRs, etc.) is exposed as variables in the `main/variables.tf` file.

    To customize the defaults of that file we recommend that you use a [variable definitions file](https://www.terraform.io/docs/configuration/variables.html#variable-definitions-tfvars-files) by setting the variables in a file `terraform.tfvars` in the directory `main/`. The following is an example `terraform.tfvars`:

    ```text
    some_key = "a_string_value"
    another_key = 3
    someting_else = true
    ```

    Subsequently running `terraform apply` loads the variables in the `terraform.tfvars` file by default:

    ```bash
    terraform apply
    ```

1. Set up the kubeconfig file that stores the information needed by `kubectl` to connect to the new cluster by default:

    ```bash
    aws eks update-kubeconfig --name codacy-cluster
    ```

1. Get information about the pods in the cluster to test that the cluster was created and that `kubectl` can successfully connect to the cluster:

    ```bash
    kubectl get pods -A
    ```

    You'll notice that nothing is scheduled. That's because we haven't yet allowed the worker nodes to join the cluster (see the [EKS docs](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html) for more details). We'll do that on the next section.

## 4. Configure the cluster to run Codacy

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

and then connect to the dashboard URL

<http://127.0.0.1:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:https/proxy>

select `token` and paste the value you saved above.

## Uninstalling the Amazon EKS cluster

**WARNING:**  
If you proceed beyond this point you'll permanently delete and break things.

1. Remove the cluster setup required to install Codacy

    To cleanup your cluster back to a _vanilla_ state you can now run,
    the following command in the `setup/` folder:

    ```bash
    terraform destroy
    ```

1. Remove the cluster

    After removing all the above stacks and setup, you may now delete the kubernetes
    cluster by running in the `main/` directory:

    ```bash
    terraform destroy
    ```

    This takes a while (~10min).

1. Remove the Terraform backend

    If you created the Terraform backend with the above stack you can now safely
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
