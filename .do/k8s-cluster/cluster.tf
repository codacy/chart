resource "digitalocean_kubernetes_cluster" "codacy_k8s" {
  name    = "codacy-doks-cluster"
  region  = "fra1"
  version = var.k8s_version

  node_pool {
    name       = "codacy-doks-pool"
    size       = "s-2vcpu-2gb"
    auto_scale = true
    node_count = 1
    min_nodes = 0
    max_nodes = 0
  }

  provisioner "local-exec" {
    command = "doctl kubernetes cluster kubeconfig save ${var.cluster_name} --set-current-context"
  }
}

resource "digitalocean_kubernetes_node_pool" "auto-scale-pool-01" {
  cluster_id = digitalocean_kubernetes_cluster.codacy_k8s.id
  name       = "codacy-doks-pool-auto-scale-pool-01"
  size       = var.node_type
  auto_scale = true
  min_nodes = 2
  max_nodes = 7
}

######## Namespace block ########

resource "kubernetes_namespace" "codacy-sandbox" {
  metadata {
    name = var.sandbox_namespace
  }
}

resource "kubernetes_secret" "docker_credentials" {
  # Depends on the namespace on the block
  depends_on = [kubernetes_namespace.codacy-sandbox]
  metadata {
    name = "docker-credentials"
    # Depends on the namespace on the block
    namespace = var.sandbox_namespace
  }
  data = {
    ".dockerconfigjson" = "{\"auths\": {\"https://index.docker.io/v1/\": {\"auth\": \"${base64encode("${var.docker_username}:${var.docker_password}")}\"}}}"
  }

  type = "kubernetes.io/dockerconfigjson"
}

###################


resource "kubernetes_secret" "do_token" {
  metadata {
    name = "digitalocean"
    namespace = "kube-system"
  }
  data = {
    "access-token" = var.digital_ocean_token
  }
}
