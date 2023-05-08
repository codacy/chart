resource "digitalocean_database_cluster" "postgres" {
  # name includes `postgres10` irrespective of version because changing it
  # would force total database destruction and subsequent recreation.
  name = "codacy-doks-cluster-postgres10-${var.environment}"
  engine = "pg"
  version = var.postgres_version
  size = var.postgres_instance_type
  region = var.region
  node_count = 1
}

resource "digitalocean_database_firewall" "postgres-fw" {
  cluster_id = digitalocean_database_cluster.postgres.id
  rule {
    type  = "k8s"
    value = data.digitalocean_kubernetes_cluster.k8s_cluster.id
  }
  depends_on = [digitalocean_database_cluster.postgres]
}

resource "digitalocean_database_user" "postgres-user" {
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = var.postgres_db_user
  depends_on = [digitalocean_database_cluster.postgres]
}

resource "digitalocean_database_db" "postgres_db" {
  for_each = local.db_names
  name  = each.key
  cluster_id = digitalocean_database_cluster.postgres.id
  depends_on = [digitalocean_database_cluster.postgres]
}
