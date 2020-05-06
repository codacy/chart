# create admin service account
resource "kubernetes_service_account" "admin" {
  metadata {
    name      = var.admin_name
    namespace = "kube-system"
  }

  automount_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "admin" {
  metadata {
    name = "${var.admin_name}-binding"
  }

  subject {
    kind      = "ServiceAccount"
    name      = var.admin_name
    namespace = "kube-system"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }
}
