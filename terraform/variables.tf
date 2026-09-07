variable "cluster_name" {
  description = "Name of the ShopLite Kind cluster."
  type        = string
  default     = "shoplite"
}

variable "worker_count" {
  description = "Number of worker nodes in the ShopLite Kind cluster."
  type        = number
  default     = 1
}

variable "ingress_namespace" {
  description = "Namespace to install the NGINX Ingress Controller into."
  type        = string
  default     = "ingress-nginx"
}
