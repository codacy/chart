resource "digitalocean_database_cluster" "postgres" {
  name = "codacy-doks-cluster-postgres${var.postgres_version}-${var.environment}"
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
    value = var.k8s_cluster_id
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
