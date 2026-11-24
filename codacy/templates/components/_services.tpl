{{/*
The vNext services 17.x didn't have, and how the others reach them. Setting names are the ones each service reads
(as the local install runs them); components/settings.yaml puts these groups into codacy-<component>-settings.
*/}}

{{/* "true" when the vNext service under .name (its values key) is installed */}}
{{- define "codacy.service.on" -}}
{{- if (index .root.Values .name | default dict).create }}true{{ end -}}
{{- end -}}

{{/* Where other services reach it: its Service, or the stand-in's quick 501 when it's left out */}}
{{- define "codacy.service.host" -}}
{{- if include "codacy.service.on" . }}{{ (index .root.Values .name).fullnameOverride }}{{ else }}codacy-unavailable-services{{ end -}}
{{- end -}}

{{/* A database of the vNext services: global.<key> where set, else global.defaultdb's server and credentials with
     its own database name. Keeps 17.x files working: the new databases live next to the old ones */}}
{{- define "codacy.db" -}}
{{- $own := index .root.Values.global .key | default dict -}}
{{- toYaml (merge (deepCopy $own) (dict "postgresqlDatabase" .database) (deepCopy .root.Values.global.defaultdb)) -}}
{{- end -}}

{{/* host, port, database and user of one database, under the key names a service uses */}}
{{- define "codacy.settings.dbConfig" -}}
{{ .prefix }}_host: {{ .db.host | quote }}
{{ .prefix }}_port: {{ (.db.service).port | default 5432 | toString | quote }}
{{ .prefix }}_{{ .nameKey }}: {{ .db.postgresqlDatabase | quote }}
{{ .prefix }}_{{ .userKey }}: {{ .db.postgresqlUsername | quote }}
{{- end -}}

{{- define "codacy.valkey.host" -}}
{{- if .Values.valkey.create }}codacy-valkey{{ else }}{{ required "valkey.host is needed when valkey.create is false" .Values.valkey.host }}{{ end -}}
{{- end -}}

{{/* ---- seat-service ---- */}}
{{- define "codacy.settings.seatService.config" -}}
{{ include "codacy.settings.dbConfig" (dict "db" (include "codacy.db" (dict "root" . "key" "seatdb" "database" "seat") | fromYaml) "prefix" "CONFIG_FORCE_db_seat" "nameKey" "name" "userKey" "username") }}
{{ include "codacy.settings.dbConfig" (dict "db" .Values.global.defaultdb "prefix" "CONFIG_FORCE_db_accounts" "nameKey" "name" "userKey" "username") }}
{{- end -}}
{{- define "codacy.settings.seatService.secrets" -}}
CONFIG_FORCE_db_seat_password: {{ (include "codacy.db" (dict "root" . "key" "seatdb" "database" "seat") | fromYaml).postgresqlPassword | quote }}
CONFIG_FORCE_db_accounts_password: {{ .Values.global.defaultdb.postgresqlPassword | quote }}
{{- end -}}

{{/* ---- analysis-scheduler: RabbitMQ under its own key names, and the engine and portal it calls ---- */}}
{{- define "codacy.settings.analysisScheduler.config" -}}
CONFIG_FORCE_analysis-scheduler_rabbitmq_username: {{ .Values.global.rabbitmq.rabbitmqUsername | quote }}
CONFIG_FORCE_analysis-scheduler_rabbitmq_virtual__host: {{ .Values.global.rabbitmq.rabbitmqvHost | quote }}
CONFIG_FORCE_analysis-scheduler_engine_host: "codacy-engine"
CONFIG_FORCE_analysis-scheduler_engine_port: "80"
CONFIG_FORCE_analysis-scheduler_portal_host: "codacy-portal"
CONFIG_FORCE_analysis-scheduler_portal_port: "80"
{{- end -}}
{{- define "codacy.settings.analysisScheduler.secrets" -}}
CONFIG_FORCE_analysis-scheduler_rabbitmq_password: {{ .Values.global.rabbitmq.rabbitmqPassword | quote }}
{{- end -}}

{{/* ---- coverage-service ---- */}}
{{- define "codacy.settings.coverageService.config" -}}
{{ include "codacy.settings.dbConfig" (dict "db" (include "codacy.db" (dict "root" . "key" "coveragedb" "database" "coveragedb") | fromYaml) "prefix" "CONFIG_FORCE_coverage_db_reports" "nameKey" "databaseName" "userKey" "user") }}
CONFIG_FORCE_codacy_engine_url: "http://codacy-engine"
CONFIG_FORCE_codacy_portal_url: "http://codacy-portal"
AWS_REGION: {{ .Values.logging.s3.region | quote }}
CONFIG_FORCE_s3_client_endpoint: {{ include "codacy.logs.s3Endpoint" . | quote }}
CONFIG_FORCE_s3_client_force_path_style: "true"
CONFIG_FORCE_s3_bucket_coverage_reports_manager_name: {{ .Values.storage.buckets.coverageReports | quote }}
CONFIG_FORCE_s3_bucket_coverage_analysis_name: {{ .Values.storage.buckets.coverageAnalysis | quote }}
{{- end -}}
{{- define "codacy.settings.coverageService.secrets" -}}
CONFIG_FORCE_coverage_db_reports_password: {{ (include "codacy.db" (dict "root" . "key" "coveragedb" "database" "coveragedb") | fromYaml).postgresqlPassword | quote }}
{{- end -}}

{{/* ---- metrics-aggregation-service ---- */}}
{{- define "codacy.settings.metricsAggregation.config" -}}
{{ include "codacy.settings.dbConfig" (dict "db" (include "codacy.db" (dict "root" . "key" "metricsaggregationdb" "database" "metricsaggregation") | fromYaml) "prefix" "CONFIG_FORCE_metricsaggregation_db" "nameKey" "dbName" "userKey" "username") }}
CONFIG_FORCE_metricsaggregation_rabbitmq_username: {{ .Values.global.rabbitmq.rabbitmqUsername | quote }}
CONFIG_FORCE_metricsaggregation_rabbitmq_virtualHost: {{ .Values.global.rabbitmq.rabbitmqvHost | quote }}
AWS_REGION: {{ .Values.logging.s3.region | quote }}
CONFIG_FORCE_metricsaggregation_s3_client_endpoint: {{ include "codacy.logs.s3Endpoint" . | quote }}
CONFIG_FORCE_metricsaggregation_s3_client_forcePathStyle: "true"
CONFIG_FORCE_metricsaggregation_s3_dayZeroBucket_name: {{ .Values.storage.buckets.metricsAggregationDayZero | quote }}
{{- end -}}
{{- define "codacy.settings.metricsAggregation.secrets" -}}
CONFIG_FORCE_metricsaggregation_db_password: {{ (include "codacy.db" (dict "root" . "key" "metricsaggregationdb" "database" "metricsaggregation") | fromYaml).postgresqlPassword | quote }}
CONFIG_FORCE_metricsaggregation_rabbitmq_password: {{ .Values.global.rabbitmq.rabbitmqPassword | quote }}
{{- end -}}

{{/* ---- srm-service: three databases ---- */}}
{{- define "codacy.settings.srmService.config" -}}
{{ include "codacy.settings.dbConfig" (dict "db" (include "codacy.db" (dict "root" . "key" "itemsdb" "database" "itemsdb") | fromYaml) "prefix" "CONFIG_FORCE_srm_items__db" "nameKey" "database__name" "userKey" "user") }}
{{ include "codacy.settings.dbConfig" (dict "db" (include "codacy.db" (dict "root" . "key" "dependenciesdb" "database" "dependenciesdb") | fromYaml) "prefix" "CONFIG_FORCE_sbom_dependencies__db" "nameKey" "database__name" "userKey" "user") }}
{{ include "codacy.settings.dbConfig" (dict "db" (include "codacy.db" (dict "root" . "key" "activeanalysisconfigdb" "database" "activeanalysisconfigdb") | fromYaml) "prefix" "CONFIG_FORCE_active__analysis_db" "nameKey" "database__name" "userKey" "user") }}
CONFIG_FORCE_srm_quality__app__url: {{ .Values.global.codacy.url | quote }}
AWS_REGION: {{ .Values.logging.s3.region | quote }}
CONFIG_FORCE_s3_client_endpoint: {{ include "codacy.logs.s3Endpoint" . | quote }}
CONFIG_FORCE_s3_client_force__path__style: "true"
CONFIG_FORCE_srm_s3__bucket_repository__issues__snapshot_name: {{ .Values.storage.buckets.repositoryIssuesSnapshot | quote }}
CONFIG_FORCE_srm_s3__bucket_pull__request__issues__snapshot_name: {{ .Values.storage.buckets.pullRequestIssuesSnapshot | quote }}
CONFIG_FORCE_srm_s3__bucket_dast__reports_name: {{ .Values.storage.buckets.srmDastReports | quote }}
CONFIG_FORCE_srm_s3__bucket_pentest__reports_name: {{ .Values.storage.buckets.srmPentest | quote }}
CONFIG_FORCE_srm_day__zero_bucket__name: {{ .Values.storage.buckets.metricsAggregationDayZero | quote }}
CONFIG_FORCE_sbom_s3__bucket_sbom_name: {{ .Values.storage.buckets.sbom | quote }}
CONFIG_FORCE_sbom_s3__bucket_sbom__temp_name: {{ .Values.storage.buckets.sbomTemp | quote }}
CONFIG_FORCE_sbom_s3__bucket_image__sbom_name: {{ .Values.storage.buckets.imageSbom | quote }}
{{- end -}}
{{- define "codacy.settings.srmService.secrets" -}}
CONFIG_FORCE_srm_items__db_password: {{ (include "codacy.db" (dict "root" . "key" "itemsdb" "database" "itemsdb") | fromYaml).postgresqlPassword | quote }}
CONFIG_FORCE_sbom_dependencies__db_password: {{ (include "codacy.db" (dict "root" . "key" "dependenciesdb" "database" "dependenciesdb") | fromYaml).postgresqlPassword | quote }}
CONFIG_FORCE_active__analysis_db_password: {{ (include "codacy.db" (dict "root" . "key" "activeanalysisconfigdb" "database" "activeanalysisconfigdb") | fromYaml).postgresqlPassword | quote }}
{{- end -}}

{{/* ---- ai-inventory-service ---- */}}
{{- define "codacy.settings.aiInventory.config" -}}
{{ include "codacy.settings.dbConfig" (dict "db" (include "codacy.db" (dict "root" . "key" "aiinventorydb" "database" "aiinventory") | fromYaml) "prefix" "CONFIG_FORCE_aiinventory_db" "nameKey" "db__name" "userKey" "username") }}
CONFIG_FORCE_aiinventory_rabbitmq_username: {{ .Values.global.rabbitmq.rabbitmqUsername | quote }}
CONFIG_FORCE_aiinventory_rabbitmq_virtual__host: {{ .Values.global.rabbitmq.rabbitmqvHost | quote }}
AWS_REGION: {{ .Values.logging.s3.region | quote }}
CONFIG_FORCE_aiinventory_s3_client_endpoint: {{ include "codacy.logs.s3Endpoint" . | quote }}
CONFIG_FORCE_aiinventory_s3_client_force__path__style: "true"
CONFIG_FORCE_aiinventory_s3_bucket_ai__inventory__snapshot_name: {{ .Values.storage.buckets.aiInventorySnapshot | quote }}
{{- end -}}
{{- define "codacy.settings.aiInventory.secrets" -}}
CONFIG_FORCE_aiinventory_db_password: {{ (include "codacy.db" (dict "root" . "key" "aiinventorydb" "database" "aiinventory") | fromYaml).postgresqlPassword | quote }}
CONFIG_FORCE_aiinventory_rabbitmq_password: {{ .Values.global.rabbitmq.rabbitmqPassword | quote }}
{{- end -}}

{{/* ---- how the existing services reach the new ones, and the buckets they share ---- */}}
{{- define "codacy.settings.websiteServices.config" -}}
{{- range $name, $key := dict "seat-service" "seat" "coverage-service" "coverage" "metrics-aggregation-service" "metrics_aggregation" "srm-service" "srm" "ai-inventory-service" "aiinventory" }}
CONFIG_FORCE_{{ $key }}_service_url: {{ include "codacy.service.host" (dict "root" $ "name" $name) | quote }}
CONFIG_FORCE_{{ $key }}_service_port: "80"
{{- end }}
CONFIG_FORCE_codacy_listener_url: "codacy-listener"
AWS_S3_SRM_DAST_REPORTS_BUCKET_NAME: {{ .Values.storage.buckets.srmDastReports | quote }}
AWS_S3_SRM_PENTEST_BUCKET_NAME: {{ .Values.storage.buckets.srmPentest | quote }}
{{- end -}}
{{- define "codacy.settings.listenerServices.config" -}}
CONFIG_FORCE_codacy_services_seatService_url: {{ include "codacy.service.host" (dict "root" . "name" "seat-service") | quote }}
CONFIG_FORCE_codacy_services_seatService_port: "80"
{{- end -}}
{{- define "codacy.settings.engineServices.config" -}}
CONFIG_FORCE_aws_s3_coverageResults_bucketName: {{ .Values.storage.buckets.coverageAnalysis | quote }}
CONFIG_FORCE_aws_s3_repositoryIssuesSnapshot_bucketName: {{ .Values.storage.buckets.repositoryIssuesSnapshot | quote }}
CONFIG_FORCE_aws_s3_organizationMetrics_bucketName: {{ .Values.storage.buckets.organizationMetrics | quote }}
AWS_S3_REPOSITORY_SETUP_BUCKET_NAME: {{ .Values.storage.buckets.repositorySetup | quote }}
{{- end -}}
{{- define "codacy.settings.workerManagerServices.config" -}}
# The workers' result cache
REDIS_DB_HOST: {{ include "codacy.valkey.host" . | quote }}
REDIS_DB_PORT: {{ .Values.valkey.port | toString | quote }}
CONFIG_FORCE_codacy_services_listener_url: "codacy-listener"
# Workers upload SBOMs to srm's temporary bucket, which srm reads and moves on
CONFIG_FORCE_aws_s3_sbom_bucketName: {{ .Values.storage.buckets.sbomTemp | quote }}
CONFIG_FORCE_aws_s3_aiInventorySnapshot_bucketName: {{ .Values.storage.buckets.aiInventorySnapshot | quote }}
CONFIG_FORCE_aws_s3_analysisFileIssuesSummary_bucketName: {{ .Values.storage.buckets.analysisFileIssuesSummary | quote }}
CONFIG_FORCE_aws_s3_relatedCodeGraph_bucketName: {{ .Values.storage.buckets.relatedCodeGraph | quote }}
CONFIG_FORCE_aws_s3_repositoryIssuesSnapshot_bucketName: {{ .Values.storage.buckets.repositoryIssuesSnapshot | quote }}
CONFIG_FORCE_aws_s3_pullRequestIssuesSnapshot_bucketName: {{ .Values.storage.buckets.pullRequestIssuesSnapshot | quote }}
{{- end -}}
{{- define "codacy.settings.portalServices.config" -}}
CONFIG_FORCE_aws_s3_fileContent_bucketName: {{ .Values.storage.buckets.fileContent | quote }}
{{- end -}}
