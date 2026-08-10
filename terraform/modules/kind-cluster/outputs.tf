output "cluster_name" {
  value = kind_cluster.this.name
}

output "kubeconfig_context" {
  value = "kind-${kind_cluster.this.name}"
}

output "kubeconfig_path" {
  description = "Path to the kubeconfig generated for the Kind cluster"
  value       = kind_cluster.this.kubeconfig_path
}
