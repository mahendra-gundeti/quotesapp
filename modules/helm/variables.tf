variable "release_name" {
  type        = string
  description = "Name of the Helm release"
}

variable "chart_name" {
  type        = string
  description = "Name of the Helm chart"
}

variable "chart_version" {
  type        = string
  default     = null
  description = "Version of the Helm chart"
}

variable "repository_url" {
  type        = string
  default     = null
  description = "Helm repository URL"
}

variable "namespace" {
  type        = string
  default     = "default"
  description = "Kubernetes namespace"
}

variable "create_namespace" {
  type        = bool
  default     = false
  description = "Create namespace if it doesn't exist"
}

variable "wait_for_deployment" {
  type        = bool
  default     = true
  description = "Wait for deployment to complete"
}

variable "timeout" {
  type        = number
  default     = 600
  description = "Timeout in seconds for deployment"
}

variable "cleanup_on_fail" {
  type        = bool
  default     = true
  description = "Cleanup resources on deployment failure"
}

variable "helm_values" {
  type        = map(string)
  default     = {}
  description = "Helm chart values to set"
}

variable "sensitive_values" {
  type        = map(string)
  default     = {}
  description = "Sensitive helm chart values to set"
}

variable "values_files" {
  type        = list(string)
  default     = []
  description = "List of YAML files with helm values"
}