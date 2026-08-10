output "cluster_name" {
  description = "ShopLite Kind cluster name."
  value       = module.kind_cluster.cluster_name
}

output "kubeconfig_context" {
  description = "Kubectl context for the ShopLite Kind cluster."
  value       = module.kind_cluster.kubeconfig_context
}
