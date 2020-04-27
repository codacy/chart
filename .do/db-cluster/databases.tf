resource "digitalocean_database_cluster" "postgres" {
  for_each = local.environments
  name = "codacy-doks-cluster-postgres${var.postgres_version}-${each.key}"
  engine = "pg"
  version = var.postgres_version
  size = var.postgres_instance_type
  region = var.region
  node_count = 1
}

resource "digitalocean_database_firewall" "postgres-fw" {
  for_each = local.environments
  cluster_id = digitalocean_database_cluster.postgres[each.key].id

  rule {
    type  = "k8s"
    value = var.k8s_cluster_id
  }
  depends_on = [digitalocean_database_cluster.postgres]
}

resource "digitalocean_database_user" "postgres-user" {
  for_each = local.environments
  cluster_id = digitalocean_database_cluster.postgres[each.key].id
  name       = var.postgres_db_user
  depends_on = [digitalocean_database_cluster.postgres]
}

resource "digitalocean_database_db" "postgres_db" {
  for_each = toset(flatten([for environment in var.environments : [for db in var.db_names : "${environment}-${db}"]]))
  name  = lower(split("-", each.value)[1])
  cluster_id = digitalocean_database_cluster.postgres[lower(split("-", each.value)[0])].id
  depends_on = [digitalocean_database_cluster.postgres]
}
