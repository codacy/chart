######################
# cluster-dev
######################

resource "digitalocean_database_cluster" "postgres-dev" {
  name = "codacy-doks-cluster-postgres-dev"
  engine = "pg"
  version = var.postgres_version
  size = var.postgres_instance_type
  region = digitalocean_kubernetes_cluster.codacy_k8s.region
  node_count = 1
}

resource "digitalocean_database_firewall" "postgres-dev-fw" {
  cluster_id = digitalocean_database_cluster.postgres-dev.id

  rule {
    type  = "k8s"
    value = digitalocean_kubernetes_cluster.codacy_k8s.id
  }
}

######################
# dev environment
######################

locals{
    dev_dbs = { for v in var.db_names : v => v }
}

resource "digitalocean_database_db" "postgres_dev_db" {
  for_each = local.dev_dbs
  name  = each.key
  cluster_id = digitalocean_database_cluster.postgres-dev.id
  depends_on = [digitalocean_database_cluster.postgres-dev]
}

######################
# cluster-release
######################

resource "digitalocean_database_cluster" "postgres-release" {
  name = "codacy-doks-cluster-postgres-release"
  engine = "pg"
  version = var.postgres_version
  size = var.postgres_instance_type
  region = digitalocean_kubernetes_cluster.codacy_k8s.region
  node_count = 1
}

resource "digitalocean_database_firewall" "postgres-release-fw" {
  cluster_id = digitalocean_database_cluster.postgres-release.id

  rule {
    type  = "k8s"
    value = digitalocean_kubernetes_cluster.codacy_k8s.id
  }
}

######################
# release environment
######################

locals{
    release_dbs = { for v in var.db_names : v => v }
}

resource "digitalocean_database_db" "postgres_release_db" {
  for_each = local.release_dbs
  name  = each.key
  cluster_id = digitalocean_database_cluster.postgres-release.id
  depends_on = [digitalocean_database_cluster.postgres-release]
}

######################
# cluster-sandbox
######################

resource "digitalocean_database_cluster" "postgres-sandbox" {
  name = "codacy-doks-cluster-postgres-sandbox"
  engine = "pg"
  version = var.postgres_version
  size = var.postgres_instance_type
  region = digitalocean_kubernetes_cluster.codacy_k8s.region
  node_count = 1
}

resource "digitalocean_database_firewall" "postgres-sandbox-fw" {
  cluster_id = digitalocean_database_cluster.postgres-sandbox.id

  rule {
    type  = "k8s"
    value = digitalocean_kubernetes_cluster.codacy_k8s.id
  }
}

######################
# sandbox environment
######################

locals{
    sandbox_dbs = { for v in var.db_names : v => v }
}

resource "digitalocean_database_db" "postgres_sandbox_db" {
  for_each = local.sandbox_dbs
  name  = each.key
  cluster_id = digitalocean_database_cluster.postgres-sandbox.id
  depends_on = [digitalocean_database_cluster.postgres-sandbox]
}

######################
# create values_dbs files
######################

resource "local_file" "template_values_dbs_dev" {
    sensitive_content = local.template_values_dbs_dev
    filename = "${path.module}/values_dbs_dev.yaml"
    file_permission = "0444"
    depends_on = [local.template_values_dbs_dev, digitalocean_database_cluster.postgres-dev]
}

resource "local_file" "template_values_dbs_release" {
    sensitive_content = local.template_values_dbs_release
    filename = "${path.module}/values_dbs_release.yaml"
    file_permission = "0444"
    depends_on = [local.template_values_dbs_release, digitalocean_database_cluster.postgres-release]
}

resource "local_file" "template_values_dbs_sandbox" {
    sensitive_content = local.template_values_dbs_sandbox
    filename = "${path.module}/values_dbs_sandbox.yaml"
    file_permission = "0444"
    depends_on = [local.template_values_dbs_sandbox, digitalocean_database_cluster.postgres-sandbox]
}
