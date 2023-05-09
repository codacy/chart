resource "digitalocean_kubernetes_cluster" "codacy_k8s" {
  name    = var.cluster_name
  region  = "fra1"
  version = var.k8s_version

  # defined for provider compliance only, at least one default node pool is required
  node_pool {
    name       = "codacy-doks-pool"
    size       = "s-2vcpu-2gb"
    auto_scale = false
    node_count = 1
  }

  # ensures k8s cluster is not recreated when node_pool changes
  # see https://github.com/digitalocean/terraform-provider-digitalocean/issues/424
  lifecycle {
    ignore_changes = [
      node_pool
    ]
  }

  provisioner "local-exec" {
    command = "doctl kubernetes cluster kubeconfig save ${var.cluster_name} --set-current-context"
  }
}

resource "digitalocean_kubernetes_node_pool" "auto-scale-pool" {
  cluster_id = digitalocean_kubernetes_cluster.codacy_k8s.id
  name       = "codacy-doks-pool-auto-scale-pool"
  size       = var.node_type
  auto_scale = true
  min_nodes  = var.nodes_min
  max_nodes  = var.nodes_max
}

resource "kubernetes_namespace" "namespaces" {
  for_each = var.namespace_names

  metadata {
    name = each.value
  }
}

resource "kubernetes_secret" "docker_credentials" {
  for_each   = var.namespace_names
  depends_on = [kubernetes_namespace.namespaces]

  metadata {
    name      = "docker-credentials"
    namespace = each.value
  }
  data = {
    ".dockerconfigjson" = "{\"auths\": {\"https://index.docker.io/v1/\": {\"auth\": \"${base64encode("${var.docker_username}:${var.docker_password}")}\"}}}"
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_secret" "do_token" {
  metadata {
    name      = "digitalocean"
    namespace = "kube-system"
  }
  data = {
    "access-token" = var.digital_ocean_token
  }
}
