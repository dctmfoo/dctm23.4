{{/* vim: set filetype=mustache: */}}

{{- define "generatekfklist" -}}
{{- $nodeCount := $.containers.fluentd.kafkabroker.replica | int }}
  {{- range $index0 := until $nodeCount -}}
    {{- $index1 := $index0 | add1 -}}
{{ $.containers.fluentd.kafkabroker.name }}-{{ $index0 }}.{{ $.containers.fluentd.kafkabroker.name }}.{{ $.containers.fluentd.kafkabroker.domain }}:{{ $.containers.fluentd.kafkabroker.port }}{{ if ne $index1 $nodeCount }},{{ end }}
  {{- end -}}
{{- end -}}