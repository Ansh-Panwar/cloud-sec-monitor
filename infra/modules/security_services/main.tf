resource "aws_guardduty_detector" "this" {
  enable = true
}

resource "aws_cloudwatch_event_rule" "guardduty_findings" {
  name        = "${var.project_name}-guardduty-findings"
  description = "Route GuardDuty findings to Lambda"

  event_pattern = jsonencode({
    source      = ["aws.guardduty"]
    detail_type = ["GuardDuty Finding"]
  })
}

