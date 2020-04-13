# ######################
# # values_dbs_dev.yaml
# ######################

# locals{
#   template_values_dbs_dev = <<EOF
# global:
#   defaultdb:
#     create: false
#     postgresqlUsername: ${digitalocean_database_user.postgres-user-dev.name}
#     postgresqlDatabase: accounts
#     postgresqlPassword: ${digitalocean_database_user.postgres-user-dev.password}
#     host: ${digitalocean_database_cluster.postgres-dev.host}
#     service:
#       port: ${digitalocean_database_cluster.postgres-dev.port}
#   analysisdb:
#     create: false
#     postgresqlUsername: ${digitalocean_database_user.postgres-user-dev.name}
#     postgresqlDatabase: analysis
#     postgresqlPassword: ${digitalocean_database_user.postgres-user-dev.password}
#     host: ${digitalocean_database_cluster.postgres-dev.host}
#     service:
#       port: ${digitalocean_database_cluster.postgres-dev.port}
#   resultsdb:
#     create: false
#     postgresqlUsername: ${digitalocean_database_user.postgres-user-dev.name}
#     postgresqlDatabase: results
#     postgresqlPassword: ${digitalocean_database_user.postgres-user-dev.password}
#     host: ${digitalocean_database_cluster.postgres-dev.host}
#     service:
#       port: ${digitalocean_database_cluster.postgres-dev.port}
#   metricsdb:
#     create: false
#     postgresqlUsername: ${digitalocean_database_user.postgres-user-dev.name}
#     postgresqlDatabase: metrics
#     postgresqlPassword: ${digitalocean_database_user.postgres-user-dev.password}
#     host: ${digitalocean_database_cluster.postgres-dev.host}
#     service:
#       port: ${digitalocean_database_cluster.postgres-dev.port}
#   filestoredb:
#     create: false
#     postgresqlUsername: ${digitalocean_database_user.postgres-user-dev.name}
#     postgresqlDatabase: filestore
#     postgresqlPassword: ${digitalocean_database_user.postgres-user-dev.password}
#     host: ${digitalocean_database_cluster.postgres-dev.host}
#     service:
#       port: ${digitalocean_database_cluster.postgres-dev.port}
#   jobsdb:
#     create: false
#     postgresqlUsername: ${digitalocean_database_user.postgres-user-dev.name}
#     postgresqlDatabase: jobs
#     postgresqlPassword: ${digitalocean_database_user.postgres-user-dev.password}
#     host: ${digitalocean_database_cluster.postgres-dev.host}
#     service:
#       port: ${digitalocean_database_cluster.postgres-dev.port}
# activities:
#   activitiesdb:
#     create: false
#     postgresqlUsername: ${digitalocean_database_user.postgres-user-dev.name}
#     postgresqlDatabase: activities
#     postgresqlPassword: ${digitalocean_database_user.postgres-user-dev.password}
#     host: ${digitalocean_database_cluster.postgres-dev.host}
#     service:
#       port: ${digitalocean_database_cluster.postgres-dev.port}
# hotspots-api:
#   hotspotsdb:
#     postgresqlUsername: ${digitalocean_database_user.postgres-user-dev.name}
#     postgresqlDatabase: hotspots
#     postgresqlPassword: ${digitalocean_database_user.postgres-user-dev.password}
#     host: ${digitalocean_database_cluster.postgres-dev.host}
#     service:
#       port: ${digitalocean_database_cluster.postgres-dev.port}
# listener:
#   listenerdb:
#     postgresqlUsername: ${digitalocean_database_user.postgres-user-dev.name}
#     postgresqlDatabase: listener
#     postgresqlPassword: ${digitalocean_database_user.postgres-user-dev.password}
#     host: ${digitalocean_database_cluster.postgres-dev.host}
#     service:
#       port: ${digitalocean_database_cluster.postgres-dev.port}
# crow:
#   crowdb:
#     host: ${digitalocean_database_cluster.postgres-dev.host}
#     postgresqlUsername: ${digitalocean_database_user.postgres-user-dev.name}
#     postgresqlDatabase: crow
#     postgresqlPassword: ${digitalocean_database_user.postgres-user-dev.password}
#     service:
#       port: ${digitalocean_database_cluster.postgres-dev.port}
# EOF
# }

# ######################
# # values_dbs_sandbox.yaml
# ######################

# locals{
#   template_values_dbs_sandbox = <<EOF
# global:
#   defaultdb:
#     create: false
#     postgresqlUsername: ${digitalocean_database_user.postgres-user-sandbox.name}
#     postgresqlDatabase: accounts
#     postgresqlPassword: ${digitalocean_database_user.postgres-user-sandbox.password}
#     host: ${digitalocean_database_cluster.postgres-sandbox.host}
#     service:
#       port: ${digitalocean_database_cluster.postgres-sandbox.port}
#   analysisdb:
#     create: false
#     postgresqlUsername: ${digitalocean_database_user.postgres-user-sandbox.name}
#     postgresqlDatabase: analysis
#     postgresqlPassword: ${digitalocean_database_user.postgres-user-sandbox.password}
#     host: ${digitalocean_database_cluster.postgres-sandbox.host}
#     service:
#       port: ${digitalocean_database_cluster.postgres-sandbox.port}
#   resultsdb:
#     create: false
#     postgresqlUsername: ${digitalocean_database_user.postgres-user-sandbox.name}
#     postgresqlDatabase: results
#     postgresqlPassword: ${digitalocean_database_user.postgres-user-sandbox.password}
#     host: ${digitalocean_database_cluster.postgres-sandbox.host}
#     service:
#       port: ${digitalocean_database_cluster.postgres-sandbox.port}
#   metricsdb:
#     create: false
#     postgresqlUsername: ${digitalocean_database_user.postgres-user-sandbox.name}
#     postgresqlDatabase: metrics
#     postgresqlPassword: ${digitalocean_database_user.postgres-user-sandbox.password}
#     host: ${digitalocean_database_cluster.postgres-sandbox.host}
#     service:
#       port: ${digitalocean_database_cluster.postgres-sandbox.port}
#   filestoredb:
#     create: false
#     postgresqlUsername: ${digitalocean_database_user.postgres-user-sandbox.name}
#     postgresqlDatabase: filestore
#     postgresqlPassword: ${digitalocean_database_user.postgres-user-sandbox.password}
#     host: ${digitalocean_database_cluster.postgres-sandbox.host}
#     service:
#       port: ${digitalocean_database_cluster.postgres-sandbox.port}
#   jobsdb:
#     create: false
#     postgresqlUsername: ${digitalocean_database_user.postgres-user-sandbox.name}
#     postgresqlDatabase: jobs
#     postgresqlPassword: ${digitalocean_database_user.postgres-user-sandbox.password}
#     host: ${digitalocean_database_cluster.postgres-sandbox.host}
#     service:
#       port: ${digitalocean_database_cluster.postgres-sandbox.port}
# activities:
#   activitiesdb:
#     create: false
#     postgresqlUsername: ${digitalocean_database_user.postgres-user-sandbox.name}
#     postgresqlDatabase: activities
#     postgresqlPassword: ${digitalocean_database_user.postgres-user-sandbox.password}
#     host: ${digitalocean_database_cluster.postgres-sandbox.host}
#     service:
#       port: ${digitalocean_database_cluster.postgres-sandbox.port}
# hotspots-api:
#   hotspotsdb:
#     postgresqlUsername: ${digitalocean_database_user.postgres-user-sandbox.name}
#     postgresqlDatabase: hotspots
#     postgresqlPassword: ${digitalocean_database_user.postgres-user-sandbox.password}
#     host: ${digitalocean_database_cluster.postgres-sandbox.host}
#     service:
#       port: ${digitalocean_database_cluster.postgres-sandbox.port}
# listener:
#   listenerdb:
#     postgresqlUsername: ${digitalocean_database_user.postgres-user-sandbox.name}
#     postgresqlDatabase: listener
#     postgresqlPassword: ${digitalocean_database_user.postgres-user-sandbox.password}
#     host: ${digitalocean_database_cluster.postgres-sandbox.host}
#     service:
#       port: ${digitalocean_database_cluster.postgres-sandbox.port}
# crow:
#   crowdb:
#     host: ${digitalocean_database_cluster.postgres-sandbox.host}
#     postgresqlUsername: ${digitalocean_database_user.postgres-user-sandbox.name}
#     postgresqlDatabase: crow
#     postgresqlPassword: ${digitalocean_database_user.postgres-user-sandbox.password}
#     service:
#       port: ${digitalocean_database_cluster.postgres-sandbox.port}
# EOF
# }

# ######################
# # values_dbs_release.yaml
# ######################

locals{
  template_values_dbs_release = <<EOF
global:
  defaultdb:
    create: false
    postgresqlUsername: ${digitalocean_database_user.postgres-user-release.name}
    postgresqlDatabase: accounts
    postgresqlPassword: ${digitalocean_database_user.postgres-user-release.password}
    host: ${digitalocean_database_cluster.postgres-release.host}
    service:
      port: ${digitalocean_database_cluster.postgres-release.port}
  analysisdb:
    create: false
    postgresqlUsername: ${digitalocean_database_user.postgres-user-release.name}
    postgresqlDatabase: analysis
    postgresqlPassword: ${digitalocean_database_user.postgres-user-release.password}
    host: ${digitalocean_database_cluster.postgres-release.host}
    service:
      port: ${digitalocean_database_cluster.postgres-release.port}
  resultsdb:
    create: false
    postgresqlUsername: ${digitalocean_database_user.postgres-user-release.name}
    postgresqlDatabase: results
    postgresqlPassword: ${digitalocean_database_user.postgres-user-release.password}
    host: ${digitalocean_database_cluster.postgres-release.host}
    service:
      port: ${digitalocean_database_cluster.postgres-release.port}
  metricsdb:
    create: false
    postgresqlUsername: ${digitalocean_database_user.postgres-user-release.name}
    postgresqlDatabase: metrics
    postgresqlPassword: ${digitalocean_database_user.postgres-user-release.password}
    host: ${digitalocean_database_cluster.postgres-release.host}
    service:
      port: ${digitalocean_database_cluster.postgres-release.port}
  filestoredb:
    create: false
    postgresqlUsername: ${digitalocean_database_user.postgres-user-release.name}
    postgresqlDatabase: filestore
    postgresqlPassword: ${digitalocean_database_user.postgres-user-release.password}
    host: ${digitalocean_database_cluster.postgres-release.host}
    service:
      port: ${digitalocean_database_cluster.postgres-release.port}
  jobsdb:
    create: false
    postgresqlUsername: ${digitalocean_database_user.postgres-user-release.name}
    postgresqlDatabase: jobs
    postgresqlPassword: ${digitalocean_database_user.postgres-user-release.password}
    host: ${digitalocean_database_cluster.postgres-release.host}
    service:
      port: ${digitalocean_database_cluster.postgres-release.port}
activities:
  activitiesdb:
    create: false
    postgresqlUsername: ${digitalocean_database_user.postgres-user-release.name}
    postgresqlDatabase: activities
    postgresqlPassword: ${digitalocean_database_user.postgres-user-release.password}
    host: ${digitalocean_database_cluster.postgres-release.host}
    service:
      port: ${digitalocean_database_cluster.postgres-release.port}
hotspots-api:
  hotspotsdb:
    postgresqlUsername: ${digitalocean_database_user.postgres-user-release.name}
    postgresqlDatabase: hotspots
    postgresqlPassword: ${digitalocean_database_user.postgres-user-release.password}
    host: ${digitalocean_database_cluster.postgres-release.host}
    service:
      port: ${digitalocean_database_cluster.postgres-release.port}
listener:
  listenerdb:
    postgresqlUsername: ${digitalocean_database_user.postgres-user-release.name}
    postgresqlDatabase: listener
    postgresqlPassword: ${digitalocean_database_user.postgres-user-release.password}
    host: ${digitalocean_database_cluster.postgres-release.host}
    service:
      port: ${digitalocean_database_cluster.postgres-release.port}
crow:
  crowdb:
    host: ${digitalocean_database_cluster.postgres-release.host}
    postgresqlUsername: ${digitalocean_database_user.postgres-user-release.name}
    postgresqlDatabase: crow
    postgresqlPassword: ${digitalocean_database_user.postgres-user-release.password}
    service:
      port: ${digitalocean_database_cluster.postgres-release.port}
EOF
}