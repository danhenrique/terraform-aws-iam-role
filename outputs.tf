output "role_arn" {
  description = "ARN da Role (null se role_name não for fornecido)"
  value       = var.role_name != null ? aws_iam_role.role[0].arn : null
}

output "role_name" {
  description = "Nome da Role (null se role_name não for fornecido)"
  value       = var.role_name != null ? aws_iam_role.role[0].name : null
}

output "policy_arns" {
  description = "ARNs das policies criadas"
  value = {
    for name, policy in aws_iam_policy.policies : name => policy.arn
  }
}
