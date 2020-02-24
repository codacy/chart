resource "digitalocean_kubernetes_cluster" "codacy_k8s" {
  name    = "codacy-doks-cluster-${terraform.workspace}"
  region  = "fra1"
  version = var.k8s_version

  node_pool {
    name       = "codacy-doks-pool-${terraform.workspace}"
    size       = "s-2vcpu-2gb"
    auto_scale = true
    min_nodes = 0
    max_nodes = 0
    node_count = 1
  }

  provisioner "local-exec" {
    command = "doctl kubernetes cluster kubeconfig save ${var.cluster_name} --set-current-context"
  }
}

resource "digitalocean_kubernetes_node_pool" "auto-scale-pool-01" {
  cluster_id = digitalocean_kubernetes_cluster.codacy_k8s.id
  name       = "codacy-doks-pool-${terraform.workspace}-auto-scale-pool"
  size       = var.node_type
  auto_scale = true
  min_nodes = 2
  max_nodes = 7
}
