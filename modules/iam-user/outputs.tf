#locals {
 # has_encrypted_password             = length(compact(aws_iam_user_login_profile.this[*].encrypted_password)) > 0
 # has_encrypted_secret               = length(compact(aws_iam_access_key.this[*].encrypted_secret)) > 0
 # has_encrypted_ses_smtp_password_v4 = length(compact(aws_iam_access_key.this[*].encrypted_ses_smtp_password_v4)) > 0
# }

output "name" {
  description = "The user's name"
  value       = try(aws_iam_user.this[0].name, null)
}

output "arn" {
  description = "The ARN assigned by AWS for this user"
  value       = try(aws_iam_user.this[0].arn, null)
}

output "unique_id" {
  description = "The unique ID assigned by AWS"
  value       = try(aws_iam_user.this[0].unique_id, null)
}

output "login_profile_password" {
  description = "The user password"
  value       = try(aws_iam_user_login_profile.this[0].password, null)
  sensitive   = true
}

output "login_profile_key_fingerprint" {
  description = "The fingerprint of the PGP key used to encrypt the password"
  value       = try(aws_iam_user_login_profile.this[0].key_fingerprint, null)
}

output "login_profile_encrypted_password" {
  description = "The encrypted password, base64 encoded"
  value       = try(aws_iam_user_login_profile.this[0].encrypted_password, null)
}

output "access_key_id" {
  description = "The access key ID"
  value       = try(aws_iam_access_key.this[0].id,  null)
}

output "access_key_key_fingerprint" {
  description = "The fingerprint of the PGP key used to encrypt the secret"
  value       = try(aws_iam_access_key.this[0].key_fingerprint, null)
}

output "access_key_key_status" {
  description = "Active or Inactive. Keys are initially active, but can be made inactive by other means."
  value       = try(aws_iam_access_key.this[0].status, null)
}




output "ssh_key_public_key_id" {
  description = "The unique identifier for the SSH public key"
  value       = try(aws_iam_user_ssh_key.this[0].ssh_public_key_id, null)
}

output "ssh_key_fingerprint" {
  description = "The MD5 message digest of the SSH public key"
  value       = try(aws_iam_user_ssh_key.this[0].fingerprint, null)
}
