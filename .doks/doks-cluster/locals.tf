######################
# values_dbs_dev.yaml
######################

locals{
  template_values_dbs_dev = <<EOF
global:
  defaultdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-dev.user}
    postgresqlDatabase: defaultdb
    postgresqlPassword: ${digitalocean_database_cluster.postgres-dev.password}
    host: ${digitalocean_database_cluster.postgres-dev.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-dev.port}
  analysisdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-dev.user}
    postgresqlDatabase: analysis
    postgresqlPassword: ${digitalocean_database_cluster.postgres-dev.password}
    host: ${digitalocean_database_cluster.postgres-dev.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-dev.port}
  resultsdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-dev.user}
    postgresqlDatabase: results
    postgresqlPassword: ${digitalocean_database_cluster.postgres-dev.password}
    host: ${digitalocean_database_cluster.postgres-dev.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-dev.port}
  metricsdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-dev.user}
    postgresqlDatabase: metrics
    postgresqlPassword: ${digitalocean_database_cluster.postgres-dev.password}
    host: ${digitalocean_database_cluster.postgres-dev.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-dev.port}
  filestoredb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-dev.user}
    postgresqlDatabase: filestore
    postgresqlPassword: ${digitalocean_database_cluster.postgres-dev.password}
    host: ${digitalocean_database_cluster.postgres-dev.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-dev.port}
  jobsdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-dev.user}
    postgresqlDatabase: jobs
    postgresqlPassword: ${digitalocean_database_cluster.postgres-dev.password}
    host: ${digitalocean_database_cluster.postgres-dev.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-dev.port}
activities:
  activitiesdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-dev.user}
    postgresqlDatabase: "activities?sslmode=require"
    postgresqlPassword: ${digitalocean_database_cluster.postgres-dev.password}
    host: ${digitalocean_database_cluster.postgres-dev.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-dev.port}
hotspots-api:
  hotspotsdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-dev.user}
    postgresqlDatabase: "hotspots?sslmode=require"
    postgresqlPassword: ${digitalocean_database_cluster.postgres-dev.password}
    host: ${digitalocean_database_cluster.postgres-dev.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-dev.port}
listener:
  listenerdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-dev.user}
    postgresqlDatabase: listener
    postgresqlPassword: ${digitalocean_database_cluster.postgres-dev.password}
    host: ${digitalocean_database_cluster.postgres-dev.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-dev.port}
crow:
  crowdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-dev.user}
    postgresqlDatabase: "crow?sslmode=require"
    postgresqlPassword: ${digitalocean_database_cluster.postgres-dev.password}
    host: ${digitalocean_database_cluster.postgres-dev.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-dev.port}
EOF
}

######################
# values_dbs_sandbox.yaml
######################

locals{
  template_values_dbs_sandbox = <<EOF
global:
  defaultdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-sandbox.user}
    postgresqlDatabase: defaultdb
    postgresqlPassword: ${digitalocean_database_cluster.postgres-sandbox.password}
    host: ${digitalocean_database_cluster.postgres-sandbox.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-sandbox.port}
  analysisdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-sandbox.user}
    postgresqlDatabase: analysis
    postgresqlPassword: ${digitalocean_database_cluster.postgres-sandbox.password}
    host: ${digitalocean_database_cluster.postgres-sandbox.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-sandbox.port}
  resultsdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-sandbox.user}
    postgresqlDatabase: results
    postgresqlPassword: ${digitalocean_database_cluster.postgres-sandbox.password}
    host: ${digitalocean_database_cluster.postgres-sandbox.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-sandbox.port}
  metricsdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-sandbox.user}
    postgresqlDatabase: metrics
    postgresqlPassword: ${digitalocean_database_cluster.postgres-sandbox.password}
    host: ${digitalocean_database_cluster.postgres-sandbox.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-sandbox.port}
  filestoredb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-sandbox.user}
    postgresqlDatabase: filestore
    postgresqlPassword: ${digitalocean_database_cluster.postgres-sandbox.password}
    host: ${digitalocean_database_cluster.postgres-sandbox.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-sandbox.port}
  jobsdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-sandbox.user}
    postgresqlDatabase: jobs
    postgresqlPassword: ${digitalocean_database_cluster.postgres-sandbox.password}
    host: ${digitalocean_database_cluster.postgres-sandbox.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-sandbox.port}
activities:
  activitiesdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-sandbox.user}
    postgresqlDatabase: "activities?sslmode=require"
    postgresqlPassword: ${digitalocean_database_cluster.postgres-sandbox.password}
    host: ${digitalocean_database_cluster.postgres-sandbox.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-sandbox.port}
hotspots-api:
  hotspotsdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-sandbox.user}
    postgresqlDatabase: "hotspots?sslmode=require"
    postgresqlPassword: ${digitalocean_database_cluster.postgres-sandbox.password}
    host: ${digitalocean_database_cluster.postgres-sandbox.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-sandbox.port}
listener:
  listenerdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-sandbox.user}
    postgresqlDatabase: listener
    postgresqlPassword: ${digitalocean_database_cluster.postgres-sandbox.password}
    host: ${digitalocean_database_cluster.postgres-sandbox.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-sandbox.port}
crow:
  crowdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-sandbox.user}
    postgresqlDatabase: "crow?sslmode=require"
    postgresqlPassword: ${digitalocean_database_cluster.postgres-sandbox.password}
    host: ${digitalocean_database_cluster.postgres-sandbox.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-sandbox.port}
EOF
}

######################
# values_dbs_release.yaml
######################

locals{
  template_values_dbs_release = <<EOF
global:
  defaultdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-release.user}
    postgresqlDatabase: defaultdb
    postgresqlPassword: ${digitalocean_database_cluster.postgres-release.password}
    host: ${digitalocean_database_cluster.postgres-release.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-release.port}
  analysisdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-release.user}
    postgresqlDatabase: analysis
    postgresqlPassword: ${digitalocean_database_cluster.postgres-release.password}
    host: ${digitalocean_database_cluster.postgres-release.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-release.port}
  resultsdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-release.user}
    postgresqlDatabase: results
    postgresqlPassword: ${digitalocean_database_cluster.postgres-release.password}
    host: ${digitalocean_database_cluster.postgres-release.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-release.port}
  metricsdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-release.user}
    postgresqlDatabase: metrics
    postgresqlPassword: ${digitalocean_database_cluster.postgres-release.password}
    host: ${digitalocean_database_cluster.postgres-release.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-release.port}
  filestoredb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-release.user}
    postgresqlDatabase: filestore
    postgresqlPassword: ${digitalocean_database_cluster.postgres-release.password}
    host: ${digitalocean_database_cluster.postgres-release.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-release.port}
  jobsdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-release.user}
    postgresqlDatabase: jobs
    postgresqlPassword: ${digitalocean_database_cluster.postgres-release.password}
    host: ${digitalocean_database_cluster.postgres-release.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-release.port}
activities:
  activitiesdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-release.user}
    postgresqlDatabase: "activities?sslmode=require"
    postgresqlPassword: ${digitalocean_database_cluster.postgres-release.password}
    host: ${digitalocean_database_cluster.postgres-release.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-release.port}
hotspots-api:
  hotspotsdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-release.user}
    postgresqlDatabase: "hotspots?sslmode=require"
    postgresqlPassword: ${digitalocean_database_cluster.postgres-release.password}
    host: ${digitalocean_database_cluster.postgres-release.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-release.port}
listener:
  listenerdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-release.user}
    postgresqlDatabase: listener
    postgresqlPassword: ${digitalocean_database_cluster.postgres-release.password}
    host: ${digitalocean_database_cluster.postgres-release.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-release.port}
crow:
  crowdb:
    create: false
    postgresqlUsername: ${digitalocean_database_cluster.postgres-release.user}
    postgresqlDatabase: "crow?sslmode=require"
    postgresqlPassword: ${digitalocean_database_cluster.postgres-release.password}
    host: ${digitalocean_database_cluster.postgres-release.private_host}
    service:
      port: ${digitalocean_database_cluster.postgres-release.port}
EOF
}
