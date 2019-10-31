# EKS cluster setup using terraform

This folder includes the terraform template needed to create an EKS cluster
from scratch, including all the necessary underlying infrastructure. It includes
the following infrastructure stacks:

-   **backend (optional)** - the S3 bucket for storing the terraform state and the DynamoDB table for state locking.
-   **main** - the EKS cluster, including all the network and nodes setup needed to go from zero to a fully functional EKS cluster.
-   **setup** - additional setup you must perform prior to installing codacy on your vanilla EKS cluster.
