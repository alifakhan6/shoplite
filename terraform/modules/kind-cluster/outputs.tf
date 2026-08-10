output "cluster_name" {
  description = "Name of the Kind cluster."
  value       = kind_cluster.this.name
}

output "kubeconfig_context" {
  description = "Kubectl context for the Kind cluster."
  value       = "kind-${kind_cluster.this.name}"
}
