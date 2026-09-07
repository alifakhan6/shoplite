variable "namespace" {
  description = "Kubernetes namespace to install the NGINX Ingress Controller into."
  type        = string
  default     = "ingress-nginx"
}
