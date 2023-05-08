data "digitalocean_kubernetes_cluster" "k8s_cluster_id" {
  name = var.k8s_cluster_name
}
