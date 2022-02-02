
resource local_file write_outputs {
  filename = "gitops-output.json"

  content = jsonencode({
    name        = module.gitops_sccs.name
    branch      = module.gitops_sccs.branch
    namespace   = module.gitops_sccs.namespace
    server_name = module.gitops_sccs.server_name
    layer       = module.gitops_sccs.layer
    layer_dir   = module.gitops_sccs.layer == "infrastructure" ? "1-infrastructure" : (module.gitops_sccs.layer == "services" ? "2-services" : "3-applications")
    type        = module.gitops_sccs.type
    group       = module.gitops_sccs.group
    service_account = module.gitops_sccs.service_account
  })
}
