{{- define "fluid-workload.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "fluid-workload.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "fluid-workload.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
{{- end }}

{{- define "fluid-workload.labels" -}}
helm.sh/chart: {{ include "fluid-workload.chart" . }}
{{ include "fluid-workload.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
fluid.io/workload-kind: {{ .Values.workload.kind | quote }}
{{- end }}

{{- define "fluid-workload.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fluid-workload.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
  Build ConfigMap data: filename -> file content.
  Prefer config.files; legacy config.content + optional config.schemaContent remain supported.
*/}}
{{- define "fluid-workload.configFiles" -}}
{{- $files := default dict .Values.config.files -}}
{{- if .Values.config.content -}}
{{- $main := default "config.yaml" .Values.configMount.fileName -}}
{{- $files = merge $files (dict $main .Values.config.content) -}}
{{- end -}}
{{- if .Values.config.schemaContent | trim -}}
{{- $files = merge $files (dict "schema.yml" .Values.config.schemaContent) -}}
{{- end -}}
{{- $files | toYaml -}}
{{- end }}

{{/*
  When true, mount only the main config file (subPath) so schema.yml from the image
  (probe semver) stays at configMount.mountPath/schema.yml.
*/}}
{{- define "fluid-workload.configMountSubPath" -}}
{{- if not .Values.config.schemaInImage -}}
false
{{- else -}}
{{- $files := fromYaml (include "fluid-workload.configFiles" .) -}}
{{- if eq (len $files) 1 -}}
true
{{- else -}}
false
{{- end -}}
{{- end -}}
{{- end }}
