variable "project_name" {
  type        = string
  description = "Prefix for all resources"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR for VPC"
}

variable "public_subnets" {
  type        = list(string)
  description = "CIDRs for public subnets"
}

variable "private_subnets" {
  type        = list(string)
  description = "CIDRs for private subnets"
}

variable "alert_emails" {
  type        = list(string)
  description = "Email addresses to subscribe to SNS alerts"
  default     = []
}

variable "frontend_image" {
  type        = string
  description = "ECR image URI (with tag) for frontend"
}

variable "backend_image" {
  type        = string
  description = "ECR image URI (with tag) for backend"
}

variable "jwt_secret" {
  type        = string
  description = "JWT secret for backend"
  sensitive   = true
}

