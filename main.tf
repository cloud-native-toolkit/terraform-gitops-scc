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

  provisioner "local-exec" {
    command = "${local.bin_dir}/igc gitops-module '${local.name}' -n '${var.namespace}' --contentDir '${local.yaml_dir}' --serverName '${var.server_name}' -l '${local.layer}' --debug"

    environment = {
      GIT_CREDENTIALS = nonsensitive(yamlencode(var.git_credentials))
      GITOPS_CONFIG   = yamlencode(var.gitops_config)
    }
  }
}
