output "enabled" {
  description = "Whether the module is enabled"
  value       = local.enabled
}

output "id" {
  description = "ID of the internet gateway"
  value       = try(aws_internet_gateway.this[0].id, null)
}

output "arn" {
  description = "ARN of the internet gateway"
  value       = try(aws_internet_gateway.this[0].arn, null)
}
