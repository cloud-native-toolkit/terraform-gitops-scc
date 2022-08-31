
# Resource Group Variables
variable "namespace" {
  type        = string
  description = "Namespace for tools"
}

variable "git_token" {
  type        = string
  description = "Git token"
}

variable "git_username" {
  type = string
}

variable "git_host" {
  type        = string
  default     = "github.com"
}

variable "git_type" {
  default = "github"
}

variable "git_org" {
  default = "seansund"
}

variable "git_repo" {
  default = "git-module-test"
}

variable "gitops_namespace" {
  default = "openshift-gitops"
}

variable "service_account_name" {
  type = string
  default = "test-service-account"
}

variable "scc_group" {
  type = bool
  default = true
}
