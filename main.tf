locals {
  bin_dir  = module.setup_clis.bin_dir
  layer = "infrastructure"
  dir_name = local.service_account == "" ? "${var.namespace}-group" : local.service_account
  name = local.service_account == "" ? "${var.namespace}-group" : "${var.service_account}-scc"
  service_account = var.group ? "" : var.service_account
  yaml_dir = "${path.cwd}/.tmp/scc-${local.dir_name}/cluster"
  application_branch = "main"
  type = "base"
}

module setup_clis {
  source = "cloud-native-toolkit/clis/util"
}

resource null_resource create_yaml {
  count = length(var.sccs) > 0 ? 1 : 0

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${local.yaml_dir}' '${var.namespace}' '${jsonencode(var.sccs)}' '${local.service_account}'"

    environment = {
      BIN_DIR = local.bin_dir
    }
  }
}

resource gitops_module module {
  depends_on = [null_resource.create_yaml]
  count = length(var.sccs) > 0 ? 1 : 0

  name = local.name
  namespace = var.namespace
  content_dir = local.yaml_dir
  server_name = var.server_name
  layer = local.layer
  type = local.type
  branch = local.application_branch
  config = yamlencode(var.gitops_config)
  credentials = yamlencode(var.git_credentials)
}
