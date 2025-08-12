{{/*
Expand the name of the chart.
*/}}
{{- define "suna.name" -}}
{{- default .Chart.Name .Values.global.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "suna.fullname" -}}
{{- if .Values.global.fullnameOverride }}
{{- .Values.global.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.global.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "suna.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "suna.labels" -}}
helm.sh/chart: {{ include "suna.chart" . }}
{{ include "suna.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "suna.selectorLabels" -}}
app.kubernetes.io/name: {{ include "suna.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
API selector labels
*/}}
{{- define "suna.api.selectorLabels" -}}
{{ include "suna.selectorLabels" . }}
app.kubernetes.io/component: api
{{- end }}

{{/*
Worker selector labels
*/}}
{{- define "suna.worker.selectorLabels" -}}
{{ include "suna.selectorLabels" . }}
app.kubernetes.io/component: worker
{{- end }}

{{/*
Redis selector labels
*/}}
{{- define "suna.redis.selectorLabels" -}}
{{ include "suna.selectorLabels" . }}
app.kubernetes.io/component: redis
{{- end }}

{{/*
RabbitMQ selector labels
*/}}
{{- define "suna.rabbitmq.selectorLabels" -}}
{{ include "suna.selectorLabels" . }}
app.kubernetes.io/component: rabbitmq
{{- end }}

{{/*
Frontend selector labels
*/}}
{{- define "suna.frontend.selectorLabels" -}}
{{ include "suna.selectorLabels" . }}
app.kubernetes.io/component: frontend
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "suna.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "suna.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create image pull secrets
*/}}
{{- define "suna.imagePullSecrets" -}}
{{- if .Values.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.imagePullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end }}
{{- end }}
