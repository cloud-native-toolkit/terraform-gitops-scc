locals {
  bin_dir = "${path.cwd}/bin"
  layer = "infrastructure"
  yaml_dir = "${path.cwd}/.tmp/scc-${var.service_account}/cluster"
  name = "${var.service_account}-scc"
}

resource null_resource setup_binaries {
  provisioner "local-exec" {
    command = "${path.module}/scripts/setup-binaries.sh"

    environment = {
      BIN_DIR = local.bin_dir
    }
  }
}

resource null_resource create_yaml {
  depends_on = [null_resource.setup_binaries]

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${local.yaml_dir}' '${var.namespace}' '${var.service_account}' '${jsonencode(var.sccs)}'"

    environment = {
      BIN_DIR = local.bin_dir
    }
  }
}

resource null_resource setup_gitops {
  depends_on = [null_resource.create_yaml]

  provisioner "local-exec" {
    command = "$(command -v igc || command -v ${local.bin_dir}/igc) gitops-module '${local.name}' -n '${var.namespace}' --contentDir '${local.yaml_dir}' --serverName '${var.serverName}' -l '${local.layer}' --debug"

    environment = {
      GIT_CREDENTIALS = yamlencode(nonsensitive(var.git_credentials))
      GITOPS_CONFIG   = yamlencode(var.gitops_config)
    }
  }
}
