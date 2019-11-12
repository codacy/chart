resource "helm_release" "dashboard" {
  count = var.cluster_only ? 0 : 1
  name  = "kubernetes-dashboard"
  chart = "stable/kubernetes-dashboard"
  namespace = "kube-system"

  # This prevents the destruction of tiller's role before removing
  # the chart, which ensures a clean terraform destroy.
  depends_on = [
    kubernetes_cluster_role_binding.tiller,
    kubernetes_service_account.tiller
  ]

  # Set your values verbatim as in a values.yaml file.
  # This is faster/cleaner than using then using the `set` argument,
  # but you should consider using `set_sensitive` for secrets.
  values = [<<-EOF
    enabled: true
    fullnameOverride: kubernetes-dashboard
    service:
      externalPort: 8001
    rbac:
      create: true
    serviceAccount:
      create: false
      name: ${var.admin_name}
    EOF
  ]

}
