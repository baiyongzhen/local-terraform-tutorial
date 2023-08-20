output "id" {
  description = "The policy's ID"
  value       = module.policy.id
}

output "arn" {
  description = "The ARN assigned by AWS to this policy"
  value       = module.policy.arn
}

output "description" {
  description = "The description of the policy"
  value       = module.policy.description
}

output "name" {
  description = "The name of the policy"
  value       = module.policy.name
}

output "path" {
  description = "The path of the policy in IAM"
  value       = module.policy.path
}

output "policy" {
  description = "The policy document"
  value       = module.policy.policy
}