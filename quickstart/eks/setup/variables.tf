# variables.tf - user settings. For terraform settings see config.tf

### project
variable "project_slug" {
  description = "Base project slug, used to name resourses"
  type = string
  default = "codacy-beta"
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
