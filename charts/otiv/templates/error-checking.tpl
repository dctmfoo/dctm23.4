{{- if and (not .Values.global.existingSecret) (not .Values.global.ocp) }}
    {{- if not .Values.global.amqp.password }}
        {{- fail "global.amqp.password value must be set\n" }}
    {{- end }}
    {{- if not .Values.global.masterPassword }}
        {{- fail "global.masterPassword value must be set\n" }}
    {{- end }}
    {{- if not .Values.global.database.adminPassword }}
        {{- fail "global.database.adminPassword value must be set\n" }}
    {{- end }}
    {{- if and .Values.otds.enabled (not .Values.otds.otdsws.otdsdb.password) }}
        {{- fail "otds.otdsws.otdsdb.password value must be set\n" }}
    {{- end }}
    {{- if and .Values.otds.enabled (not .Values.otds.otdsws.cryptKey) }}
        {{- fail "otds.otdsws.cryptKey value must be set\n" }}
    {{- end }}
    {{- if and (ne .Values.global.database.type "oracle") (ne .Values.global.database.type "postgresql") }}
    	{{- fail "global.database.type must be either postgresql or oracle" }}
    {{- end}}
    {{- if .Values.global.topologyScheduling }}
        {{- if and (ne .Values.global.topologyScheduling "DoNotSchedule") (ne .Values.global.topologyScheduling "ScheduleAnyway") }}
            {{- fail "if global.topologyScheduling is set, it's value must be either DoNotSchedule or ScheduleAnyway" }}
        {{- end}}
    {{- end}}
{{- end }}

{{- if and .Values.global.existingSecret (not .Values.global.ocp) (not .Values.global.skipExistingSecretLookup) }}
    {{- $secret_object := lookup "v1" "Secret" .Release.Namespace .Values.global.existingSecret }}
    {{- if not $secret_object }}
        {{- fail "\n\nError: existing secret defined at .Values.global.existingSecret not found.\n" }}
    {{- else if not $secret_object.data }}
        {{- fail "\n\nError: keys from the existing secret set at .Values.global.existingSecret must be defined under the data section.\n" }}
    {{- end }}
    {{- $secrets := $secret_object.data }}
    {{- if not (index $secrets "rabbitmq-password") }}
        {{- fail "\n\nError: existing secret from .Values.global.existingSecret must set rabbitmq-password\n" }}
    {{- end }}
    {{- if not (index $secrets "otdsPassword") }}
        {{- fail "\n\nError: existing secret from .Values.global.existingSecret must set otdsPassword\n" }}
    {{- end }}
    {{- if not (index $secrets "pithos-password") }}
        {{- fail "\n\nError: existing secret from .Values.global.existingSecret must set pithos-password\n" }}
    {{- end }}
    {{- if not (index $secrets "OTDS_JAKARTA_PERSISTENCE_JDBC_PASSWORD") }}
        {{- fail "\n\nError: existing secret from .Values.global.existingSecret must set OTDS_JAKARTA_PERSISTENCE_JDBC_PASSWORD\n" }}
    {{- end }}
    {{- if .Values.otds.enabled  }}
        {{- if not (index $secrets "OTDS_DIRECTORY_BOOTSTRAP_INITIALPASSWORD") }}
            {{- fail "\n\nError: existing secret from .Values.global.existingSecret must set OTDS_DIRECTORY_BOOTSTRAP_INITIALPASSWORD\n" }}
        {{- end }}
        {{- if not (index $secrets "OTDS_DIRECTORY_BOOTSTRAP_CRYPTSECRET") }}
            {{- fail "\n\nError: existing secret from .Values.global.existingSecret must set OTDS_DIRECTORY_BOOTSTRAP_CRYPTSECRET\n" }}
        {{- end }}
        {{- if ne $secrets.otdsPassword $secrets.OTDS_DIRECTORY_BOOTSTRAP_INITIALPASSWORD }}
            {{- fail "\n\nError: existing secret from .Values.global.existingSecret must have the same values for otdsPassword and OTDS_DIRECTORY_BOOTSTRAP_INITIALPASSWORD.\n" }}
        {{- end }}
    {{- end }}
{{- end }}

