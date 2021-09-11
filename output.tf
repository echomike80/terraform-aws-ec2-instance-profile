output "instance_profile_arn" {
  description = "ARN of Instance Profile used to reference the created objects in aws_instance resources"
  value       = aws_iam_instance_profile.ec2.arn
}

output "instance_profile_id" {
  description = "ID of Instance Profile used to reference the created objects in aws_instance resources"
  value       = aws_iam_instance_profile.ec2.id
}