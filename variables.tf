variable "vpc_id" {
  description = "ID of the VPC to attach the IGW to"
  type        = string
  validation {
    condition     = length(var.vpc_id) > 0
    error_message = "vpc_id must not be empty."
  }
}
