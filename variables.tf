variable "role_name" {
  description = "Nome da Role (opcional - deixe nulo para criar apenas policies)"
  type        = string
  default     = null
}

variable "assume_role_policy_document" {
  description = "Documento JSON da política de confiança da Role (obrigatório se role_name for fornecido)"
  type        = string
  default     = null
}

variable "policies" {
  description = "Lista de definições de política"
  type = list(object({
    name        = string
    description = string
    document    = string
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  default     = {}
  validation {
    condition = contains(keys(var.tags), "Repository")
    error_message = "The 'Repository' tag is mandatory."
  }
}

variable "existing_policy_arns" {
  description = "A list of ARNs of existing IAM policies to attach to the role"
  type        = list(string)
  default     = []
}
