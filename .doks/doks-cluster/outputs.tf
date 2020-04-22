output "cluster_endpoint" {
  value = digitalocean_kubernetes_cluster.codacy_k8s.endpoint
}

output "postgres-dev-host" {
  value = digitalocean_database_cluster.postgres-dev.host
}

output "postgres-dev-port" {
  value = digitalocean_database_cluster.postgres-dev.port
}

output "postgres-release-host" {
  value = digitalocean_database_cluster.postgres-release.host
}

output "postgres-release-port" {
  value = digitalocean_database_cluster.postgres-release.port
}

output "postgres-sandbox-host" {
  value = digitalocean_database_cluster.postgres-sandbox.host
}

output "postgres-sandbox-port" {
  value = digitalocean_database_cluster.postgres-sandbox.port
}
