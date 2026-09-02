output "namespace" {
  description = "Namespace the NGINX Ingress Controller was installed into."
  value       = helm_release.ingress_nginx.namespace
}

output "release_name" {
  description = "Helm release name for the NGINX Ingress Controller."
  value       = helm_release.ingress_nginx.name
}

output "status" {
  description = "Helm release status reported by Terraform."
  value       = helm_release.ingress_nginx.status
}
