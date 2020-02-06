# Setting up an Amazon EKS cluster

Follow the steps below to set up an Amazon EKS cluster from scratch, including all the necessary underlying infrastructure, using Terraform.
 
## 1. Prepare your environment

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
    * **setup**: Additional setup to be performed before installing Codacy on your vanilla Amazon EKS cluster

## 2. Set up the Terraform state storage backend

The [backend](https://www.terraform.io/docs/backends/index.html) stores the current and historical state of your infrastructure.

Although using the backend is optional, we recommend that you deploy it, particularly if you are planning to use these templates to make modifications to the cluster in the future:

1. Initialize Terraform and deploy the infrastructure described in the `backend/` directory, then follow Terraform's instructions:

    ```bash
    cd backend/
    terraform init && terraform apply
    ```

    An Amazon S3 bucket with a unique name to save the infrastructure state is created.

1. Note the value of `state_bucket_name` in the output of the command.

1. Edit the `config.tf` files that exist in the `main/` and `setup/` directories and follow the instructions to set the name of the Amazon S3 bucket and enable the use of the backend in those infrastructure stacks.

## 3. Create a vanilla Amazon EKS cluster

Create a cluster that includes all the required network and node setup:

1. Initialize Terraform and deploy the infrastructure described in the `main/` directory, then follow Terraform's instructions:

    ```bash
    cd ../main/
    terraform init && terraform apply
    ```

    This process takes around 10 minutes.

1. Consider if you want to tailor the cluster to your needs by customizing the cluster configuration.

    The cluster configuration (such as the type/number of nodes, network CIDRs, etc.) is exposed as variables in the [`main/variables.tf`](https://github.com/codacy/chart/blob/master/docs/infrastructure/EKS/main/variables.tf) file.

    To customize the defaults of that file we recommend that you use a [variable definitions file](https://www.terraform.io/docs/configuration/variables.html#variable-definitions-tfvars-files) by setting the variables in a file named `terraform.tfvars` in the directory `main/`. The following is an example `terraform.tfvars`:

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

## 4. Set up the cluster to run Codacy

Some additional setup is necessary to run Codacy on the newly created cluster, such as allowing workers to join the cluster and installing the following Helm charts:

* [Kubernetes Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)
* [nginx-ingress](https://github.com/helm/charts/tree/master/stable/nginx-ingress)
* [cert-manager](https://github.com/jetstack/cert-manager)

Set up the cluster to run Codacy:

1. Initialize Terraform and deploy the infrastructure described in the `setup/` directory, then follow Terraform's instructions:

    ```bash
    cd ../setup/
    terraform init && terraform apply
    ```

1. To connect to the Kubernetes Dashboard, run:

    ```bash
    kubectl proxy
    ```

    Open the following URL on a browser and select `token`:

    <http://127.0.0.1:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:https/proxy>

    Run the following command to obtain the admin token required to connect to the Kubernetes Dashboard:

    ```bash
    terraform output admin_token
    ```

## Uninstalling the Amazon EKS cluster

**WARNING:**  
If you proceed beyond this point you'll permanently delete and break things.

1. Cleanup your cluster back to a vanilla state by removing the setup required to install Codacy. Run the following command in the `setup/` folder:

    ```bash
    terraform destroy
    ```

1. After removing the stacks and setup above, you may now delete the Kubernetes cluster. Run the following command in the `main/` directory:

    ```bash
    terraform destroy
    ```

    This process takes around 10 minutes.

1. Remove the Terraform backend.

    If you created the Terraform backend with the provided stack you can now safely delete it.

    The backend is purposely created with extra settings to prevent its accidental destruction, so to destroy it cleanly you must first disable these extra settings. Edit the file `backend/state_and_lock.tf` and follow the instructions included in the comments.

    Afterwards, run the following command in the `backend/` directory:

    ```bash
    terraform apply && terraform destroy
    ```

    Note that you first have to run `terraform apply` to update the settings, and only
    then will `terraform destroy` be able to destroy the backend.
