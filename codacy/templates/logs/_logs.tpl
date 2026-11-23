{{/*
Logs and support bundles. The 17.x keys under fluentdoperator keep working: enabled turns log capture on, bucketName names
the logs bucket and expirationDays sets how long logs are kept. The logging.* keys, when set, take precedence.
*/}}
{{- define "codacy.logs.captureEnabled" -}}
{{- if kindIs "bool" .Values.logging.capture.enabled -}}
{{- .Values.logging.capture.enabled -}}
{{- else -}}
{{- .Values.fluentdoperator.enabled | default false -}}
{{- end -}}
{{- end -}}

{{- define "codacy.logs.bucket" -}}
{{- .Values.logging.bucket | default .Values.fluentdoperator.bucketName | default "logs" -}}
{{- end -}}

{{- define "codacy.logs.retentionDays" -}}
{{- .Values.logging.retentionDays | default .Values.fluentdoperator.expirationDays | default 7 -}}
{{- end -}}

{{- define "codacy.logs.s3Endpoint" -}}
{{- .Values.logging.s3.endpoint | default (printf "http://%s:%v" .Values.global.minio.location .Values.global.minio.port) -}}
{{- end -}}

{{- define "codacy.logs.supportBundleImage" -}}
{{- printf "%s:%s" .Values.logging.supportBundles.image.repository .Values.logging.supportBundles.image.tag -}}
{{- end -}}

{{/* S3 credentials for Fluent Bit and the bundle jobs: the bundled object store's keys */}}
{{- define "codacy.logs.s3Env" -}}
- name: AWS_ACCESS_KEY_ID
  valueFrom: { secretKeyRef: { name: codacy-logs-s3, key: access-key } }
- name: AWS_SECRET_ACCESS_KEY
  valueFrom: { secretKeyRef: { name: codacy-logs-s3, key: secret-key } }
{{- end -}}

{{- define "codacy.logs.imagePullSecrets" -}}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{ toYaml .Values.global.imagePullSecrets | indent 2 }}
{{- end }}
{{- end -}}

{{/* Meets the "restricted" Pod Security level: the bundle jobs and the dispatcher run on clusters that enforce it */}}
{{- define "codacy.logs.restrictedPod" -}}
securityContext: { runAsNonRoot: true, runAsUser: 10001, runAsGroup: 10001, fsGroup: 10001, seccompProfile: { type: RuntimeDefault } }
{{- end -}}

{{- define "codacy.logs.restrictedContainer" -}}
securityContext: { allowPrivilegeEscalation: false, capabilities: { drop: [ALL] } }
{{- end -}}
