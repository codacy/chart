{{/*
Settings the vNext services need on a self-hosted install. Each helper prints KEY: "value" lines; components/settings.yaml
puts the groups each component needs into a ConfigMap (config) and a Secret (secrets) named codacy-<component>-settings,
which the component charts load through extraEnvFrom. They come from the global values 17.x installs already have.
*/}}

{{- define "codacy.settings.enabled" -}}
{{- if eq (toString (. | default "false")) "true" }}true{{ end -}}
{{- end -}}

{{/* ---- object storage ---- */}}
{{- define "codacy.settings.s3.config" -}}
AWS_REGION: {{ .Values.logging.s3.region | quote }}
CONFIG_FORCE_aws_s3_endpoint: {{ include "codacy.logs.s3Endpoint" . | quote }}
CONFIG_FORCE_aws_s3_useLocalMinio: "true"
{{- end -}}
{{- define "codacy.settings.s3.secrets" -}}
AWS_ACCESS_KEY_ID: {{ .Values.global.minio.accessKey | quote }}
AWS_SECRET_ACCESS_KEY: {{ .Values.global.minio.secretKey | quote }}
{{- end -}}

{{/* ---- RabbitMQ ---- */}}
{{- define "codacy.settings.rabbit.config" -}}
CONFIG_FORCE_op__rabbit_connection_port: {{ .Values.global.rabbitmq.port | quote }}
CONFIG_FORCE_op__rabbit_connection_ssl: {{ .Values.global.rabbitmq.ssl | quote }}
{{- end -}}
{{- define "codacy.settings.rabbit.secrets" -}}
CLOUDAMPQ_PASS: {{ .Values.global.rabbitmq.rabbitmqPassword | quote }}
CONFIG_FORCE_op__rabbit_connection_password: {{ .Values.global.rabbitmq.rabbitmqPassword | quote }}
{{- end -}}

{{/* ---- databases: pool sizes (small installs) and passwords ---- */}}
{{- define "codacy.settings.dbPools.config" -}}
{{- range $db := list "default" "analysis" "results" "metrics" "jobs" }}
CONFIG_FORCE_db_{{ $db }}_hikaricp_maximumPoolSize: {{ $.Values.componentSettings.dbPool.maximumPoolSize | quote }}
CONFIG_FORCE_db_{{ $db }}_hikaricp_minimumIdle: {{ $.Values.componentSettings.dbPool.minimumIdle | quote }}
{{- end }}
{{- end -}}
{{/* portal and website use no jobs database: a db.jobs setting would make Play open one, with no URL to open */}}
{{- define "codacy.settings.dbPoolsNoJobs.config" -}}
{{- range $db := list "default" "analysis" "results" "metrics" }}
CONFIG_FORCE_db_{{ $db }}_hikaricp_maximumPoolSize: {{ $.Values.componentSettings.dbPool.maximumPoolSize | quote }}
CONFIG_FORCE_db_{{ $db }}_hikaricp_minimumIdle: {{ $.Values.componentSettings.dbPool.minimumIdle | quote }}
{{- end }}
{{- end -}}
{{- define "codacy.settings.dbPasswordsNoJobs.secrets" -}}
DB_DEFAULT_PASSWORD: {{ .Values.global.defaultdb.postgresqlPassword | quote }}
DB_ANALYSIS_PASSWORD: {{ .Values.global.analysisdb.postgresqlPassword | quote }}
DB_RESULTS_PASSWORD: {{ .Values.global.resultsdb.postgresqlPassword | quote }}
DB_METRICS_PASSWORD: {{ .Values.global.metricsdb.postgresqlPassword | quote }}
{{- end -}}
{{- define "codacy.settings.dbPasswords.secrets" -}}
DB_DEFAULT_PASSWORD: {{ .Values.global.defaultdb.postgresqlPassword | quote }}
DB_ANALYSIS_PASSWORD: {{ .Values.global.analysisdb.postgresqlPassword | quote }}
DB_RESULTS_PASSWORD: {{ .Values.global.resultsdb.postgresqlPassword | quote }}
DB_METRICS_PASSWORD: {{ .Values.global.metricsdb.postgresqlPassword | quote }}
DB_JOBS_PASSWORD: {{ .Values.global.jobsdb.postgresqlPassword | quote }}
{{- end -}}

{{/* ---- the secrets every Play service shares ---- */}}
{{- define "codacy.settings.play.secrets" -}}
CONFIG_FORCE_play_http_secret_key: {{ .Values.global.play.httpSecretKey | default .Values.global.play.cryptoSecret | quote }}
CODACY_CACHE_SECRET: {{ .Values.global.cacheSecret | quote }}
{{- end -}}

{{/* ---- Git providers, for the enabled ones (17.x keys under global.<provider>) ---- */}}
{{- define "codacy.settings.providers.config" -}}
{{- $g := .Values.global }}
{{- with $g.github }}{{ if include "codacy.settings.enabled" .enabled }}
CONFIG_FORCE_codacy_github_login: {{ .login | default "true" | toString | quote }}
{{- end }}{{ end }}
{{- with $g.gitlab }}{{ if include "codacy.settings.enabled" .enabled }}
CONFIG_FORCE_codacy_gitlab_login: {{ .login | default "true" | toString | quote }}
{{- end }}{{ end }}
{{- range $p := list "githubEnterprise" "gitlabEnterprise" "bitbucketEnterprise" }}
{{- with index $g $p }}{{ if include "codacy.settings.enabled" .enabled }}
CONFIG_FORCE_codacy_enterprise_{{ $p }}_enabled: "true"
CONFIG_FORCE_codacy_enterprise_{{ $p }}_login: {{ .login | default "true" | toString | quote }}
CONFIG_FORCE_codacy_enterprise_{{ $p }}_hostname: {{ .hostname | quote }}
CONFIG_FORCE_codacy_enterprise_{{ $p }}_protocol: {{ .protocol | default "https" | quote }}
CONFIG_FORCE_codacy_enterprise_{{ $p }}_port: {{ .port | default 443 | toString | quote }}
{{- end }}{{ end }}
{{- end }}
{{- end -}}
{{- define "codacy.settings.providers.secrets" -}}
{{- $g := .Values.global }}
{{- with $g.github }}{{ if include "codacy.settings.enabled" .enabled }}
CONFIG_FORCE_codacy_github_clientId: {{ .clientId | quote }}
CONFIG_FORCE_codacy_github_clientSecret: {{ .clientSecret | quote }}
CONFIG_FORCE_codacy_github_clientName: {{ (.app).name | default "codacy" | quote }}
CONFIG_FORCE_codacy_github_webhookSecret: {{ .webhookSecret | default "" | quote }}
CONFIG_FORCE_codacy_github_app_id: {{ (.app).id | default "" | toString | quote }}
CONFIG_FORCE_codacy_github_app_privateKey: {{ (.app).privateKey | default "" | quote }}
{{- end }}{{ end }}
{{- with $g.gitlab }}{{ if include "codacy.settings.enabled" .enabled }}
CONFIG_FORCE_codacy_gitlab_clientId: {{ .clientId | quote }}
CONFIG_FORCE_codacy_gitlab_clientSecret: {{ .clientSecret | quote }}
{{- end }}{{ end }}
{{- with $g.bitbucket }}{{ if include "codacy.settings.enabled" .enabled }}
CONFIG_FORCE_codacy_bitbucket_key: {{ .key | quote }}
CONFIG_FORCE_codacy_bitbucket_secret: {{ .secret | quote }}
{{- end }}{{ end }}
{{- with $g.githubEnterprise }}{{ if include "codacy.settings.enabled" .enabled }}
CONFIG_FORCE_codacy_enterprise_githubEnterprise_clientId: {{ .clientId | quote }}
CONFIG_FORCE_codacy_enterprise_githubEnterprise_clientSecret: {{ .clientSecret | quote }}
CONFIG_FORCE_codacy_enterprise_githubEnterprise_webhookSecret: {{ .webhookSecret | default "" | quote }}
CONFIG_FORCE_codacy_enterprise_githubEnterprise_app_id: {{ (.app).id | default "" | toString | quote }}
CONFIG_FORCE_codacy_enterprise_githubEnterprise_app_name: {{ (.app).name | default "codacy" | quote }}
CONFIG_FORCE_codacy_enterprise_githubEnterprise_app_slug: {{ (.app).slug | default (.app).name | default "codacy" | quote }}
CONFIG_FORCE_codacy_enterprise_githubEnterprise_app_privateKey: {{ (.app).privateKey | default "" | quote }}
{{- end }}{{ end }}
{{- with $g.gitlabEnterprise }}{{ if include "codacy.settings.enabled" .enabled }}
CONFIG_FORCE_codacy_enterprise_gitlabEnterprise_clientId: {{ .clientId | quote }}
CONFIG_FORCE_codacy_enterprise_gitlabEnterprise_clientSecret: {{ .clientSecret | quote }}
{{- end }}{{ end }}
{{- with $g.bitbucketEnterprise }}{{ if include "codacy.settings.enabled" .enabled }}
CONFIG_FORCE_codacy_enterprise_bitbucketEnterprise_consumerKey: {{ .consumerKey | quote }}
CONFIG_FORCE_codacy_enterprise_bitbucketEnterprise_consumerPublicKey: {{ .consumerPublicKey | quote }}
CONFIG_FORCE_codacy_enterprise_bitbucketEnterprise_consumerPrivateKey: {{ .consumerPrivateKey | quote }}
{{- end }}{{ end }}
{{- end -}}

{{/* ---- website ---- */}}
{{- define "codacy.settings.website.config" -}}
CONFIG_FORCE_codacy_selfHosted_enabled: "true"
{{- with .Values.global.codacy.adminEmails }}
CONFIG_FORCE_codacy_selfHosted_adminEmails: {{ join "," . | quote }}
{{- end }}
CONFIG_FORCE_codacy_license_enabled: "true"
{{- with .Values.global.codacy.licensePublicKey }}
CONFIG_FORCE_codacy_license_publicKey: {{ . | quote }}
{{- end }}
CONFIG_FORCE_codacy_supportBundles_enabled: {{ .Values.logging.supportBundles.enabled | toString | quote }}
CONFIG_FORCE_codacy_supportBundles_endpoint: {{ include "codacy.logs.s3Endpoint" . | quote }}
CONFIG_FORCE_codacy_supportBundles_bucket: {{ .Values.logging.supportBundles.bucket | quote }}
CONFIG_FORCE_codacy_supportBundles_region: {{ .Values.logging.s3.region | quote }}
# Cloud-only services, off on self-hosted
CONFIG_FORCE_codacy_integration_githubMarketplace: "false"
CONFIG_FORCE_codacy_integration_gravatar: "false"
CONFIG_FORCE_codacy_integration_hubspot: "false"
CONFIG_FORCE_codacy_integration_intercom: "false"
CONFIG_FORCE_codacy_integration_pylon: "false"
CONFIG_FORCE_codacy_integration_segment: "false"
CONFIG_FORCE_codacy_zendesk_enabled: "false"
CONFIG_FORCE_codacy_stripe_daemon_active: "false"
CONFIG_FORCE_codacy_stripe_paidSubscriptionsDaemon_active: "false"
CONFIG_FORCE_akka_http_session_cookie_secure: {{ hasPrefix "https" .Values.global.codacy.url | toString | quote }}
CONFIG_FORCE_remote_provider_service_port: "80"
{{- with .Values.global.email }}{{ if include "codacy.settings.enabled" .enabled }}
CONFIG_FORCE_codacy_email_enabled: "true"
CONFIG_FORCE_codacy_email_replyTo: {{ .replyTo | quote }}
CONFIG_FORCE_codacy_email_sendMaintenanceEmails: "false"
CONFIG_FORCE_codacy_email_smtp_hostname: {{ (.smtp).hostname | quote }}
CONFIG_FORCE_codacy_email_smtp_port: {{ (.smtp).port | default 25 | toString | quote }}
CONFIG_FORCE_codacy_email_smtp_protocol: {{ (.smtp).protocol | default "smtp" | quote }}
{{- end }}{{ end }}
{{- end -}}
{{- define "codacy.settings.website.secrets" -}}
CONFIG_FORCE_akka_http_session_server__secret: {{ .Values.global.akka.sessionSecret | quote }}
CONFIG_FORCE_codacy_cache_secret: {{ .Values.global.cacheSecret | quote }}
CONFIG_FORCE_codacy_license_value: {{ .Values.global.codacy.license | default "" | quote }}
CONFIG_FORCE_codacy_supportBundles_accessKey: {{ .Values.global.minio.accessKey | quote }}
CONFIG_FORCE_codacy_supportBundles_secretKey: {{ .Values.global.minio.secretKey | quote }}
# Cloud billing and support integrations the services still read: placeholders, they're switched off above
CODACY_CHARGEBEE_API_KEY: "unused"
CODACY_CHARGEBEE_SITE: "unused"
CODACY_INTERCOM_SECRET: "unused"
CODACY_PYLON_SECRET: "unused"
STRIPE_PRIVATE: "unused"
STRIPE_PUBLIC: "unused"
{{- with .Values.global.email }}{{ if include "codacy.settings.enabled" .enabled }}{{ with (.smtp).password }}
CONFIG_FORCE_codacy_email_smtp_password: {{ . | quote }}
{{- end }}{{ end }}{{ end }}
{{- end -}}

{{/* ---- engine ---- */}}
{{- define "codacy.settings.engine.secrets" -}}
APPLICATION_SECRET: {{ .Values.global.play.cryptoSecret | quote }}
PLAY_CRYPTO_SECRET: {{ .Values.global.play.cryptoSecret | quote }}
{{- end -}}

{{/* ---- worker-manager, and the environment it gives analysis workers ---- */}}
{{- define "codacy.settings.workerManager.config" -}}
CONFIG_FORCE_codacy_worker_extraEnv: {{ printf "CONFIG_FORCE_aws_s3_useLocalMinio=true;CONFIG_FORCE_aws_s3_endpoint=%s;AWS_REGION=%s;CONFIG_FORCE_op__rabbit_connection_port=%v;CONFIG_FORCE_op__rabbit_connection_ssl=%v;CONFIG_FORCE_kamon_enabled=false;CONFIG_FORCE_segment_enabled=false" (include "codacy.logs.s3Endpoint" .) .Values.logging.s3.region .Values.global.rabbitmq.port .Values.global.rabbitmq.ssl | quote }}
CONFIG_FORCE_codacy_workers_startTimeoutMinutes: "5"
# Required, no defaults: worker pods older than the lifespan are deleted whatever their state (so it must exceed the
# longest analysis); a pod not in the database is removed after the unmanaged timeout (worker boot is about 3 minutes)
CONFIG_FORCE_codacy_workers_podLifespanMinutes: {{ .Values.componentSettings.workerPodLifespanMinutes | quote }}
CONFIG_FORCE_codacy_workers_unmanagedPodTimeoutMinutes: "15"
# Required booleans with no defaults: AI issue suggestions are cloud-only, and vNext has no legacy clone tables
CONFIG_FORCE_codacy_features_issueSuggestions: "false"
CONFIG_FORCE_codacy_features_clone_readLegacyTables: "false"
CONFIG_FORCE_codacy_worker_pod_volume_type: {{ .Values.componentSettings.workerVolumeType | quote }}
CONFIG_FORCE_db_jobs_maximumPoolSize: {{ .Values.componentSettings.dbPool.maximumPoolSize | quote }}
CONFIG_FORCE_db_jobs_minimumIdle: {{ .Values.componentSettings.dbPool.minimumIdle | quote }}
CONFIG_FORCE_db_jobs_numThreads: {{ .Values.componentSettings.dbPool.maximumPoolSize | quote }}
{{- end -}}
{{- define "codacy.settings.workerManager.secrets" -}}
# Workers encrypt and later read back per-file issue summaries with it: it must stay the same across upgrades
ANALYSIS_FILE_ISSUES_SUMMARY_ENCRYPTION_KEY: {{ .Values.global.analysisFileIssuesSummaryEncryptionKey | default (sha256sum (toString .Values.global.play.cryptoSecret)) | quote }}
APPLICATION_SECRET: {{ .Values.global.play.cryptoSecret | quote }}
CLOUDAMPQ_WORKER_PASS: {{ .Values.global.rabbitmq.rabbitmqPassword | quote }}
CONFIG_FORCE_codacy_db_default_password: {{ .Values.global.defaultdb.postgresqlPassword | quote }}
CONFIG_FORCE_codacy_db_analysis_password: {{ .Values.global.analysisdb.postgresqlPassword | quote }}
CONFIG_FORCE_codacy_db_results_password: {{ .Values.global.resultsdb.postgresqlPassword | quote }}
CONFIG_FORCE_codacy_db_metrics_password: {{ .Values.global.metricsdb.postgresqlPassword | quote }}
CONFIG_FORCE_db_jobs_password: {{ .Values.global.jobsdb.postgresqlPassword | quote }}
CONFIG_FORCE_s3__emulator_credentials_accessKey: {{ .Values.global.minio.accessKey | quote }}
CONFIG_FORCE_s3__emulator_credentials_secretKey: {{ .Values.global.minio.secretKey | quote }}
{{- end -}}

{{/* ---- portal ---- */}}
{{- define "codacy.settings.portal.config" -}}
CODACY_GITHUB_BOT: "unset"
# Cloud's badge Lambda: portal needs a URL, none is used on self-hosted
AWS_LAMBDA_BADGER_URL: "http://unset"
{{- end -}}
{{- define "codacy.settings.portal.secrets" -}}
# Cloud integrations the portal still reads: placeholders
AWS_LAMBDA_BADGER_SECRET: "unused"
CODACY_BACKEND_SEGMENT_SECRET: "unused"
CONFIG_FORCE_codacy_email_sendgrid_apiToken: "unused"
CONFIG_FORCE_codacy_email_sendgrid_password: "unused"
CONFIG_FORCE_codacy_experiment_ai_token: "unused"
# Encrypts portal's file-content cache in the object store; derived like the workers' key, stable across upgrades
CONFIG_FORCE_aws_s3_fileContent_privateKey: {{ .Values.global.fileContentEncryptionKey | default (sha256sum (printf "file-content:%s" (toString .Values.global.play.cryptoSecret))) | quote }}
{{- if not (include "codacy.settings.enabled" ((.Values.global.bitbucket).enabled)) }}
CONFIG_FORCE_codacy_bitbucket_key: "unused"
CONFIG_FORCE_codacy_bitbucket_secret: "unused"
{{- end }}
{{- if not (include "codacy.settings.enabled" ((.Values.global.gitlab).enabled)) }}
# portal reads GitLab's OAuth client whether GitLab is on or not
CONFIG_FORCE_codacy_gitlab_clientId: "unused"
CONFIG_FORCE_codacy_gitlab_clientSecret: "unused"
{{- end }}
{{- with .Values.global.email }}{{ if include "codacy.settings.enabled" .enabled }}{{ with (.smtp).password }}
CONFIG_FORCE_codacy_email_smtp_password: {{ . | quote }}
{{- end }}{{ end }}{{ end }}
{{- end -}}

{{/* ---- codacy-tools, spa, listeners ---- */}}
{{/* codacy-tools: its own database (codacytoolsdb) and RabbitMQ, under its own key names */}}
{{- define "codacy.settings.codacyTools.config" -}}
{{- $db := include "codacy.db" (dict "root" . "key" "codacytoolsdb" "database" "codacytoolsdb") | fromYaml }}
CONFIG_FORCE_database_host: {{ $db.host | quote }}
CONFIG_FORCE_database_port: {{ ($db.service).port | default 5432 | toString | quote }}
CONFIG_FORCE_database_databaseName: {{ $db.postgresqlDatabase | quote }}
CONFIG_FORCE_database_username: {{ $db.postgresqlUsername | quote }}
CONFIG_FORCE_rabbitmq_host: {{ .Values.global.rabbitmq.host | quote }}
CONFIG_FORCE_rabbitmq_port: {{ .Values.global.rabbitmq.port | toString | quote }}
CONFIG_FORCE_rabbitmq_ssl: {{ .Values.global.rabbitmq.ssl | toString | quote }}
CONFIG_FORCE_rabbitmq_username: {{ .Values.global.rabbitmq.rabbitmqUsername | quote }}
CONFIG_FORCE_rabbitmq_virtualHost: {{ .Values.global.rabbitmq.rabbitmqvHost | quote }}
{{- end -}}
{{- define "codacy.settings.codacyTools.secrets" -}}
CONFIG_FORCE_database_password: {{ (include "codacy.db" (dict "root" . "key" "codacytoolsdb" "database" "codacytoolsdb") | fromYaml).postgresqlPassword | quote }}
CONFIG_FORCE_rabbitmq_password: {{ .Values.global.rabbitmq.rabbitmqPassword | quote }}
{{- end -}}
{{- define "codacy.settings.spa.config" -}}
CODACY_FEATURES_STANDARDS_MAX_LIMIT: "100"
CODACY_DOCUMENTATION_VERSION: "latest"
CODACY_HEARTBEAT_INTERVAL: "30000"
# Signs the browser out after this long without activity; the website's own idle timeout is 8 hours
SESSION_IDLE_TIMEOUT: "28800000"
{{- end -}}
{{/* The listener database: 17.x's listener.listenerdb wins over global.listenerdb, as in the 17.x listener chart */}}
{{- define "codacy.listenerDb" -}}
{{- toYaml ((.Values.listener).listenerdb | default .Values.global.listenerdb) -}}
{{- end -}}
{{- define "codacy.settings.listener.config" -}}
{{- $db := include "codacy.listenerDb" . | fromYaml }}
CONFIG_FORCE_codacy_listener_service_db_listener_psql_db_properties_serverName: {{ $db.host | quote }}
CONFIG_FORCE_codacy_listener_service_db_listener_psql_db_properties_portNumber: {{ ($db.service).port | default 5432 | toString | quote }}
CONFIG_FORCE_codacy_listener_service_db_listener_psql_db_properties_databaseName: {{ $db.postgresqlDatabase | quote }}
CONFIG_FORCE_codacy_listener_service_db_listener_psql_db_properties_user: {{ $db.postgresqlUsername | quote }}
{{- end -}}
{{- define "codacy.settings.listener.secrets" -}}
CONFIG_FORCE_codacy_listener_service_db_default_psql_db_properties_password: {{ .Values.global.defaultdb.postgresqlPassword | quote }}
CONFIG_FORCE_codacy_listener_service_db_analysis_psql_db_properties_password: {{ .Values.global.analysisdb.postgresqlPassword | quote }}
CONFIG_FORCE_codacy_listener_service_db_jobs_psql_db_properties_password: {{ .Values.global.jobsdb.postgresqlPassword | quote }}
CONFIG_FORCE_codacy_listener_service_db_listener_psql_db_properties_password: {{ (include "codacy.listenerDb" . | fromYaml).postgresqlPassword | quote }}
{{- end -}}
