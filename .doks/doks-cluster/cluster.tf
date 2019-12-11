resource "digitalocean_kubernetes_cluster" "codacy_k8s" {
  name    = "${var.cluster_name}"
  region  = "fra1"
  version = var.k8s_version

  node_pool {
    name       = "${var.cluster_name}-pool"
    size       = var.node_type
    node_count = var.num_nodes
  }

  provisioner "local-exec" {
    command = "doctl kubernetes cluster kubeconfig save ${var.cluster_name} --set-current-context"
  }
}

resource "kubernetes_namespace" "codacy" {
  count = var.cluster_only ? 0 : 1
  metadata {
    name = var.main_namespace
  }
}

resource "kubernetes_secret" "docker_credentials" {
  depends_on = [kubernetes_namespace.codacy]
  count = var.cluster_only ? 0 : 1
  metadata {
    name = "docker-credentials"
    namespace = var.main_namespace
  }
  data = {
    ".dockerconfigjson" = "{\"auths\": {\"https://index.docker.io/v1/\": {\"auth\": \"${base64encode("${var.docker_username}:${var.docker_password}")}\"}}}"
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_secret" "do_token" {
  count = var.cluster_only ? 0 : 1
  metadata {
    name = "digitalocean"
    namespace = "kube-system"
  }
  data = {
    "access-token" = var.digital_ocean_token
  }
}
