data "digitalocean_kubernetes_cluster" "k8s_cluster" {
  name = var.k8s_cluster_name
}
