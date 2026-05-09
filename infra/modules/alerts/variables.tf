variable "project_name" {
  type = string
}

variable "email_subscriptions" {
  type    = list(string)
  default = []
}

