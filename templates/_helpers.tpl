{{/*
Expand the name of the chart.
*/}}
{{- define "eks-cluster-autoscaler.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "eks-cluster-autoscaler.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "eks-cluster-autoscaler.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "eks-cluster-autoscaler.labels" -}}
helm.sh/chart: {{ include "eks-cluster-autoscaler.chart" . }}
{{ include "eks-cluster-autoscaler.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "eks-cluster-autoscaler.selectorLabels" -}}
app.kubernetes.io/name: {{ include "eks-cluster-autoscaler.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "eks-cluster-autoscaler.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
  {{- default (include "eks-cluster-autoscaler.fullname" .) .Values.serviceAccount.name }}
{{- else }}
  default
{{- end }}
{{- end }}


{{/*
Define Kafka broker addresses as a comma-separated string
*/}}
{{- define "KAFKA_BROKER_ADDRESS" -}}
{{- join "," .Values.kafka.brokers }}
{{- end -}}

{{/*
Define Kafka topic
*/}}
{{- define "KAFKA_TOPIC" -}}
{{- .Values.kafka.topic }}
{{- end -}}
