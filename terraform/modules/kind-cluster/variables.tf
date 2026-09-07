variable "cluster_name" {
  description = "Name of the Kind Kubernetes cluster."
  type        = string
  default     = "shoplite"
}

variable "worker_count" {
  description = "Number of worker nodes in the Kind cluster."
  type        = number
  default     = 1
}
