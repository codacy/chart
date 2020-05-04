output "db_cluster_host" {
  value = digitalocean_database_cluster.postgres.private_host
}

output "db_cluster_port" {
  value = digitalocean_database_cluster.postgres.port
}

output "db_cluster_username" {
  value = digitalocean_database_user.postgres-user.name
}

output "db_cluster_password" {
  value = digitalocean_database_user.postgres-user.password
  sensitive = true
}
