resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-security-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  for_each = toset(var.email_subscriptions)

  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = each.value
}

