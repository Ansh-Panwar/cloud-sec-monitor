data "aws_iam_policy_document" "lambda_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.project_name}-threat-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "threat_ingest" {
  function_name = "${var.project_name}-threat-ingest"
  role          = aws_iam_role.lambda_role.arn
  handler       = "handler.lambda_handler"
  runtime       = "python3.11"
  filename      = var.lambda_package_path

  environment {
    variables = {
      THREAT_TABLE_NAME = var.threat_table_name
      SNS_TOPIC_ARN     = var.sns_topic_arn
    }
  }
}

resource "aws_cloudwatch_event_target" "guardduty_target" {
  rule      = var.guardduty_event_rule_name
  target_id = "threat-ingest"
  arn       = aws_lambda_function.threat_ingest.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.threat_ingest.function_name
  principal     = "events.amazonaws.com"
  source_arn    = var.guardduty_event_rule_arn
}

