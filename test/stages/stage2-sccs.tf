module "gitops_sccs" {
  source = "./module"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  namespace = module.gitops_namespace.name
  service_account = module.gitops_service_account.name
  sccs = ["anyuid","privileged"]
}
