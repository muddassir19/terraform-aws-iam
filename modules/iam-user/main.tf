resource "aws_iam_user" "this" {
  count = var.create ? 1 : 0

  name                 = var.name
  path                 = var.path
  force_destroy        = var.force_destroy
  permissions_boundary = var.permissions_boundary

  tags = merge(
    var.mandatory_taggs,
    {CreatedThrough = "Terraform"},
    {Deployment = "New2"},
    {"Name" = var.name}
  )
}

resource "aws_iam_user_policy_attachment" "additional" {
  for_each = { for k, v in var.policies : k => v if var.create }
  user     = aws_iam_user.this[0].name
  policy_arn = each.value
}
# IAM User Inline Policy
locals {
  create_inline_policy = var.create && var.create_inline_policy
}

data "aws_iam_policy_document" "inline" {
  count = local.create_inline_policy ? 1 : 0

  source_policy_documents = var.source_inline_policy_documents
  override_policy_documents = var.override_inline_policy_documents

  dynamic "statement" {
    for_each = var.inline_policy_permissions != null ? var.inline_policy_permissions : {}

    content {
      sid           = try(coalesce(statement.value.sid, statement.key))
      actions       = statement.value.actions
      not_actions   = statement.value.not-actions
      effect        = statement.value.effect
      resources     = statement.value.resources
      not_resources = statement.value.not_resources

      dynamic "principals" {
        for_each = statement.value.principals != null ? statement.value.principals : []

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = statement.value.not_principals != null ? statement.value.not_principals : []

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = statement.value.condition != null ? statement.value.condition : []

        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }
}

resource "aws_iam_user_policy" "inline" {
  count = local.create_inline_policy ? 1 : 0

  user = aws_iam_user.this[0].name
  name = var.name
  policy = data.aws_iam_policy_document.inline[0].json
}

resource "aws_iam_user_login_profile" "this" {
  count = var.create && var.create_login_profile ? 1 : 0

  user                    = aws_iam_user.this[0].name
  pgp_key                 = var.pgp_key
  password_length         = var.password_length
  password_reset_required = var.password_reset_required

  # TODO: Remove once https://github.com/hashicorp/terraform-provider-aws/issues/23567 is resolved
  # lifecycle {
    #vignore_changes = [password_reset_required]
  # }
}

resource "aws_iam_access_key" "this" {
  count = var.create_user && var.create_access_key ? 1 : 0

  user    = aws_iam_user.this[0].name
  pgp_key = var.pgp_key
  status  = var.access_key_status
}

# resource "aws_iam_access_key" "this_no_pgp" {
  # count = var.create_user && var.create_iam_access_key && var.pgp_key == "" ? 1 : 0
#
 # user   = aws_iam_user.this[0].name
 # status = var.iam_access_key_status
# }

resource "aws_iam_user_ssh_key" "this" {
  count = var.create && var.create_ssh_key ? 1 : 0

  username   = aws_iam_user.this[0].name
  encoding   = var.ssh_key_encoding
  public_key = var.ssh_public_key
}

resource "aws_iam_user_policy_attachment" "this" {
  for_each = { for k, v in var.policy_arns : k => v if var.create }

  user       = aws_iam_user.this[0].name
  policy_arn = each.value
}

resource "aws_secretsmanager_secret" "this {
  count = var.create && var.create_access_key && var.pgp_key == null ? 1 : 0

  name = join("-", [aws_iam_user.this[0].name, "access-keys"])

  tags = merge(
    var.mandatory_tags,
    {CreatedThrough = "Terraform"},
    {Deployment = "New2"},
    {"Name" = join("-", [aws_iam_user.this[0].name, "access-keys"])},
    {"Notes" = "Crated by aws-iam for ${aws_iam_user.this[0].name} iam-user"}
  )
}

resource "aws_secretsmanager_secret_version" "this" {
  count = var.create && var.create_access_key && var.pgp_key == null ? 1 : 0

  secret_id = aws_secretmanager_secret.this[0].id
  secret_string = jsonencode({"AccessKey" = aws_iam_access_key.this[0].id, "SecretAccessKey" = aws_iam_access_key.this[0].secret})
}
