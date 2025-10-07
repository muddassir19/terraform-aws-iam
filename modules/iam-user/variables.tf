variable "aws_region" {
  type        = string
  description = "This AWS region where the resource will be created"
  default     = ""
}

variable "create" {
  description = "If resources should be crated (affets all)"
  type        = bool
  default     = true
}

variable "create_login_profile" {
  description = "Whether to create IAM user login profile"
  type        = bool
  default     = false # Changed to `false` as human user supposed to login via AWS Identity Center
}

variable "create_access_key" {
  description = "Whether to create IAM access key"
  type        = bool
  default     = true
}

variable "name" {
  description = "Desired name for the IAM user"
  type        = string
  deafult = ""
}

variable "path" {
  description = "Desired path for the IAM user"
  type        = string
  default     = null
}

variable "permissions_boundary" {
  description = "When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices. Without force_destroy a user with non-Terraform-managed access keys and login profile will fail to be destroyed."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices. Without force_destroy a user with non-Terraform-managed access keys and login profile will fail to be destroyed."
  type        = bool
  default     = false
}

variable "policies" {
  description = "policies to atatch to IAM USer `{'static_name' = 'policy_arn'}` format"
  type        = map(string)
  default     = {}
}

variable "pgp_key" {
  description = "Either a base-64 encoded PGP public key, or a keybase username in the form `keybase:username`. Used to encrypt password and access key."
  type        = string
  default     = null
}

# variable "iam_access_key_status" {
  # description = "Access key status to apply."
  # type        = string
  # default     = null
# }

variable "password_length" {
  description = "The length of the generated password"
  type        = number
  default     = null
}

variable "password_reset_required" {
  description = "Whether the user should be forced to reset the generated password on first login."
  type        = bool
  default     = true
}
variable "access_key_status" {
  description = "Whether to create IAM access key"
  type        = string
  default     = null
}

variable "create_ssh_key" {
  description = "Whether to upload a public ssh key to IAM user"
  type        = bool
  default     = "false"
}

variable "ssh_key_encoding" {
  description = "Specifies the public key encoding format to use in the response. To retrieve the public key in ssh-rsa format, use SSH. To retrieve the public key in PEM format, use PEM"
  type        = string
  default     = "SSH"
}

variable "ssh_public_key" {
  description = "The SSH public key. The public key must be encoded in ssh-rsa format or PEM format"
  type        = string
  default     = ""
}

#Inline policy

variable "create_inline_policy"{
  description = "whether to create inline policy"
  type        = bool
  default     = false
}

variable "source_inline_policy_documents"{
  description = "List of IAM policy documents that are merged together into the expoted documets.statement must have unquie `sid`"
  type        = list(string)
  default     = []
}

variable "override_inline_policy_documents"{
  description = "List of IAM policy documents that are merged together into the expoted documets.statement with non-blank `sid`will override statements with same `sid`"
  type        = list(string)
  default     = []
}

variable "inline_policy_permissions"{
  description = "map of IAM policy"
  type        = map(object({
    sid = optional(string)
    actions = optional(string)
    not_actions = optional(list(string))
    effect = optional(string, "Allow")
    resources = optional(list(string))
    not_resources = optional(list(string))
    principals = optional(list(object({
      type = string
      indentifiers = list(string)
    })))
    not_principals = optional(list(object({
      type = string
      identifiers = list(string)
    })))
    condition = optional(list(object({
      test = string
      variable = string
      values = list(string)
    })))
  }))
  default     = null
}

variable "mandatory_tags" {
  description = "A mapping of mandatory tags to assign to all resources."
  type        = object({
    CostCenter         = string
    DataClassification = string
    Application        = string
    Environment        = string
    Function           = string
  })
  nullable = false
}

variable "prefix" {
  description = "prefix for the secret Manager naming pattern"
  type        = string
}
