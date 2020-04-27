output "db_cluster_hosts" {
  value = [
    for host, port in zipmap(
      sort(values(digitalocean_database_cluster.postgres)[*]["private_host"]),
      sort(values(digitalocean_database_cluster.postgres)[*]["port"])) :
      map("host", host, "port", port)
  ]
}

output "db_cluster_usernames" {
  value = [
    for environment, user in zipmap(
      sort(var.environments),
      sort(values(digitalocean_database_user.postgres-user)[*]["name"])) :
      map("environment", environment, "username", user)
  ]
}

output "db_cluster_passwords" {
  value = [
    for environment, password in zipmap(
      sort(var.environments),
      sort(values(digitalocean_database_user.postgres-user)[*]["password"])) :
      map("environment", environment, "password", password)
  ]
  sensitive = true
}
