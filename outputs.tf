
output "name" {
  description = "The name of the module"
  value       = gitops_module.module.name
}

output "branch" {
  description = "The branch where the module config has been placed"
  value       = gitops_module.module.branch
}

output "namespace" {
  description = "The namespace where the module will be deployed"
  value       = gitops_module.module.namespace
}

output "server_name" {
  description = "The server where the module will be deployed"
  value       = gitops_module.module.server_name
}

output "layer" {
  description = "The layer where the module is deployed"
  value       = gitops_module.module.layer
}

output "type" {
  description = "The type of module where the module is deployed"
  value       = gitops_module.module.type
}

output "group" {
  description = "The value of the group flag indicating the scc was created for all service accounts in the group"
  value       = var.group || var.service_account == ""
  depends_on  = [gitops_module.module]
}

output "service_account" {
  description = "The name of the service account"
  value       = local.service_account
  depends_on  = [gitops_module.module]
}
