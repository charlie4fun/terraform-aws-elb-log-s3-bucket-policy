output "target_group_arn" {
  description = "ARN of the target group. Useful for passing to your Auto Scaling group module."
  value       = data.aws_iam_policy_document.bucket_policy.json
}
