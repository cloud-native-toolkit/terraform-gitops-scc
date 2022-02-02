
output "name" {
  description = "The name of the module"
  value       = local.name
  depends_on  = [null_resource.setup_gitops]
}

output "branch" {
  description = "The branch where the module config has been placed"
  value       = local.application_branch
  depends_on  = [null_resource.setup_gitops]
}

output "namespace" {
  description = "The namespace where the module will be deployed"
  value       = var.namespace
  depends_on  = [null_resource.setup_gitops]
}

output "server_name" {
  description = "The server where the module will be deployed"
  value       = var.server_name
  depends_on  = [null_resource.setup_gitops]
}

output "layer" {
  description = "The layer where the module is deployed"
  value       = local.layer
  depends_on  = [null_resource.setup_gitops]
}

output "type" {
  description = "The type of module where the module is deployed"
  value       = "base"
  depends_on  = [null_resource.setup_gitops]
}

output "group" {
  description = "The value of the group flag indicating the scc was created for all service accounts in the group"
  value       = var.group || var.service_account == ""
  depends_on  = [null_resource.setup_gitops]
}

output "service_account" {
  description = "The name of the service account"
  value       = var.group ? "" : var.service_account
  depends_on  = [null_resource.setup_gitops]
}
