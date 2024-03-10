{{/* vim: set filetype=mustache: */}}
{{/*
Determine the name depending on whether or not to use the release name.
*/}}
{{- define "otdsws.name" -}}
{{- if .Values.global.otdsUseReleaseName }}
{{- printf "%s-%s" .Release.Name .Chart.Name -}}
{{- else }}
{{- printf "%s" .Chart.Name -}}
{{- end }}
{{- end -}}

{{/*
Determine the service name depending on whether or not to use the release name.
*/}}
{{- define "otdsws.service" -}}
{{- if .Values.global.otdsUseReleaseName }}
{{- printf "%s-%s" .Release.Name .Values.global.otdsServiceName -}}
{{- else }}
{{- printf "%s" .Values.global.otdsServiceName -}}
{{- end }}
{{- end -}}

{{/*
Determine the DB url to use
*/}}
{{- define "otdsws.dburl" -}}
{{- if .Values.otdsdb.url }}
{{- printf "%s" .Values.otdsdb.url -}}
{{- else if eq .Values.global.database.type "oracle" -}}
jdbc:oracle:thin:@//{{ .Values.global.database.hostname }}:{{ .Values.global.database.port }}/{{ .Values.global.database.adminDatabase }}
{{- else -}}
jdbc:postgresql://{{ .Values.global.database.hostname }}:{{ .Values.global.database.port }}/{{.Values.otdsdb.name }}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "otdsws.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "otdsws.labels" -}}
app.kubernetes.io/name: {{ include "otdsws.name" . }}
helm.sh/chart: {{ include "otdsws.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
