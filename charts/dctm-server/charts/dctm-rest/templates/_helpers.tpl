{{- /*
mychart.shortname provides a 6 char truncated version of the release name.
*/ -}}
{{- define "dctm-rest.release-labels" }}
app: {{ .Release.Name }}-{{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
version: {{ .Chart.Version }}
release: {{ .Release.Name }}
{{- end }}

{{- define "dctm-rest.custom-labels" }}
{{- range $key, $val := .Values.customLabels }}
{{ $key }}: {{ $val }}
{{- end}}
{{- end }}

{{- define "dctm-rest.fullname" -}}
{{ .Release.Name }}-{{ .Chart.Name }}
{{- end }}

{{/* vim: set filetype=mustache: */}}

{{- define "generatekfklist" -}}
{{- $nodeCount := $.fluentdConf.kafkabroker.replica | int }}
  {{- range $index0 := until $nodeCount -}}
    {{- $index1 := $index0 | add1 -}}
{{ $.fluentdConf.kafkabroker.name }}-{{ $index0 }}.{{ $.fluentdConf.kafkabroker.name }}.{{ $.fluentdConf.kafkabroker.domain }}:{{ $.fluentdConf.kafkabroker.port }}{{ if ne $index1 $nodeCount }},{{ end }}
  {{- end -}}
{{- end -}}