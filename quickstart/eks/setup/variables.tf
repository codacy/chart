# variables.tf - user settings. For terraform settings see config.tf

### project
variable "project_slug" {
  description = "Base project slug, used to name resources"
  type = string
  default = "codacy"
}

### kubernetes
variable "k8s_admin_name" {
  description = "Name of the admin account for the cluster"
  type        = string
  default     = "admin"
}

variable "k8s_system_namespace" {
  description = "Kubernetes namespace where system resources will be created"
  type        = string
  default     = "kube-system"
}

variable "main_namespace" {
  description = "Name of the namespace where codacy will be deployed"
  type        = string
  default     = "codacy"
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
