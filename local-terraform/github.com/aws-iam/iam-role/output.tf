output "this_iam_role_arn" {
  description = "ARN of IAM role"
  value       = module.assume_role.this_iam_role_arn
}

output "this_iam_role_name" {
  description = "Name of IAM role"
  value       = module.assume_role.this_iam_role_name
}

output "this_iam_role_path" {
  description = "Path of IAM role"
  value       = module.assume_role.this_iam_role_path
}

output "role_requires_mfa" {
  description = "Whether IAM role requires MFA"
  value       = module.assume_role.role_requires_mfa
}

output "this_iam_instance_profile_arn" {
  description = "ARN of IAM instance profile"
  value       = module.assume_role.this_iam_instance_profile_arn
}

output "this_iam_instance_profile_name" {
  description = "Name of IAM instance profile"
  value       = module.assume_role.this_iam_instance_profile_name
}

output "this_iam_instance_profile_path" {
  description = "Path of IAM instance profile"
  value       = module.assume_role.this_iam_instance_profile_path
}

output "role_sts_externalid" {
  description = "STS ExternalId condition value to use with a role"
  value       = module.assume_role.role_sts_externalid
}