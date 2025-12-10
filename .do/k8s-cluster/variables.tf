######################
# k8s cluster
######################

variable "k8s_version" {
  description = "Kubernetes version. See available versions with `doctl kubernetes options versions`"
  type        = string
  default     = "1.31.9-do.5"
}

variable "k8s_kubeconfig" {
  description = "Kubernetes kubeconfig path."
  type        = string
  default     = "~/.kube/config"
}

variable "node_type" {
  description = "Node type used. See available types with `doctl compute size list`"
  type        = string
  default     = "s-4vcpu-8gb"
}

variable "nodes_min" {
  description = "Minimum number of nodes to use in the cluster node pool"
  type        = number
  default     = 2
}

variable "nodes_max" {
  description = "Maximum number of nodes to use in the cluster node pool"
  type        = number
  default     = 5
}

variable "admin_name" {
  description = "Name of the admin account (don't change this without having a good reason)"
  type        = string
  default     = "do-admin"
}

variable "docker_username" {
  description = "Username for docker registry secret"
  type        = string
  default     = "codacy"
}

variable "docker_password" {
  description = "Password for docker registry secret"
  type        = string
}

variable "digital_ocean_token" {
  # NOTE: you'll have to install the cloud-controller-manager with:
  # kubectl apply -f https://raw.githubusercontent.com/digitalocean/digitalocean-cloud-controller-manager/master/releases/v0.1.20.yml
  description = "Digital ocean access token, used by digitalocean-cloud-controller-manager (see: https://github.com/digitalocean/digitalocean-cloud-controller-manager )"
  type        = string
  default     = "REPLACE_ME"
}

variable "cluster_only" {
  description = "If set to true (default) it will just create the cluster and won't install anything there"
  type = bool
  default = true
}

variable "cluster_name" {
  description = "The cluster name"
  type = string
  default = "default"
}

variable "namespace_names" {
  description = "Namespaces for Codacy deployments"
  default = {0: "codacy-dev", 1: "codacy-sandbox", 2: "codacy-release"}
}
