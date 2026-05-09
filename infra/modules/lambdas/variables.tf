variable "project_name" {
  type = string
}

variable "lambda_package_path" {
  type        = string
  description = "Path to zip file with Lambda code"
}

variable "threat_table_name" {
  type = string
}

variable "sns_topic_arn" {
  type = string
}

variable "guardduty_event_rule_arn" {
  type = string
}

variable "guardduty_event_rule_name" {
  type = string
}

