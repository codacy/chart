variable "digital_ocean_token" {
  # NOTE: you'll have to install the cloud-controller-manager with:
  # kubectl apply -f https://raw.githubusercontent.com/digitalocean/digitalocean-cloud-controller-manager/master/releases/v0.1.20.yml
  description = "Digital ocean access token, used by digitalocean-cloud-controller-manager (see: https://github.com/digitalocean/digitalocean-cloud-controller-manager )"
  type        = string
  default     = "REPLACE_ME"
}

variable "region" {
  description = "The region where the clusters will be deployed."
  type = string
  default = "fra1"
}

variable "k8s_cluster_name" {
  description = "The name of the k8s cluster where db connections will come from."
  type = string
  default = "REPLACE_ME"
}

variable "postgres_version" {
  description = "The postgres version to be used."
  type = string
  default = "13"
}

variable "postgres_default_admin" {
  description = "The default admin user on digital ocean postgres."
  type = string
  default = "doadmin"
}

variable "environment" {
  type = string
  default = "sandbox"
}

variable "db_names" {
  type = list(string)
  default = ["accounts", "analysis", "results", "metrics", "jobs", "crow", "listener"]
}

variable "postgres_instance_type" {
  description = "The instance type for the postgres clusters."
  type = string
  default = "db-s-6vcpu-16gb"
}

variable "postgres_db_user" {
  description = "The non admin user for the pg databases."
  type = string
  default = "codacy"
}
