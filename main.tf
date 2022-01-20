locals {
  bin_dir  = module.setup_clis.bin_dir
  layer = "infrastructure"
  yaml_dir = "${path.cwd}/.tmp/scc-${var.service_account}/cluster"
  name = "${var.service_account}-scc"
}

module setup_clis {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"
}

resource null_resource create_yaml {
  count = length(var.sccs) > 0 ? 1 : 0

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${local.yaml_dir}' '${var.namespace}' '${var.service_account}' '${jsonencode(var.sccs)}'"

    environment = {
      BIN_DIR = local.bin_dir
    }
  }
}

resource null_resource setup_gitops {
  depends_on = [null_resource.create_yaml]
  count = length(var.sccs) > 0 ? 1 : 0

  triggers = {
    name = local.name
    namespace = var.namespace
    yaml_dir = local.yaml_dir
    server_name = var.server_name
    layer = local.layer
    git_credentials = nonsensitive(var.git_credentials)
    gitops_config   = var.gitops_config
  }

  provisioner "local-exec" {
    command = "${local.bin_dir}/igc gitops-module '${self.triggers.name}' -n '${self.triggers.namespace}' --contentDir '${self.triggers.yaml_dir}' --serverName '${self.triggers.server_name}' -l '${self.triggers.layer}'"

    environment = {
      GIT_CREDENTIALS = yamlencode(self.triggers.git_credentials)
      GITOPS_CONFIG   = yamlencode(self.triggers.gitops_config)
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${local.bin_dir}/igc gitops-module '${self.triggers.name}' -n '${self.triggers.namespace}' --delete --contentDir '${self.triggers.yaml_dir}' --serverName '${self.triggers.server_name}' -l '${self.triggers.layer}'"

    environment = {
      GIT_CREDENTIALS = yamlencode(self.triggers.git_credentials)
      GITOPS_CONFIG   = yamlencode(self.triggers.gitops_config)
    }
  }
}
