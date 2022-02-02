
variable "gitops_config" {
  type        = object({
    boostrap = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
    })
    infrastructure = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    services = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    applications = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
  })
  description = "Config information regarding the gitops repo structure"
}

variable "git_credentials" {
  type = list(object({
    repo = string
    url = string
    username = string
    token = string
  }))
  description = "The credentials for the gitops repo(s)"
  sensitive = true
}

variable "namespace" {
  type        = string
  description = "The namespace where the application should be deployed"
}

variable "service_account" {
  type        = string
  description = "The name of the service account that should be granted the SCC privileges"
  default     = ""
}

variable "group" {
  type        = string
  description = "Apply the SCC to all the service accounts in the namespace"
  default     = false
}

variable "sccs" {
  type        = list(string)
  description = "The SCCs, if any, that should be provisioned"
  default     = []
}

variable "server_name" {
  type        = string
  description = "The cluster where the application will be provisioned"
  default     = "default"
}
