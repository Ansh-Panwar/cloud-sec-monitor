output "guardduty_event_rule_arn" {
  value = aws_cloudwatch_event_rule.guardduty_findings.arn
}

output "guardduty_event_rule_name" {
  value = aws_cloudwatch_event_rule.guardduty_findings.name
}

