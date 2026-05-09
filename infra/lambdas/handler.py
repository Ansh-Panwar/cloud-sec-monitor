import json
import os
import boto3
from datetime import datetime, timezone
from decimal import Decimal


dynamodb = boto3.resource("dynamodb")
table_name = os.environ.get("THREAT_TABLE_NAME", "")
sns_topic_arn = os.environ.get("SNS_TOPIC_ARN", "")

table = dynamodb.Table(table_name) if table_name else None
sns = boto3.client("sns") if sns_topic_arn else None


def _decimal_default(obj):
    if isinstance(obj, Decimal):
        return float(obj)
    raise TypeError


def classify_severity(detail: dict) -> str:
    """
    Basic mapping from GuardDuty numeric severity to labels.
    """
    sev = detail.get("severity", 0)
    try:
        sev = float(sev)
    except Exception:
        sev = 0

    if sev >= 7:
        return "Critical"
    if sev >= 4:
        return "High"
    if sev >= 2:
        return "Medium"
    return "Low"


def lambda_handler(event, context):
    """
    Entry point for GuardDuty findings via EventBridge.
    Normalises the finding and stores it in DynamoDB.
    Sends an SNS notification for High/Critical findings.
    """
    if not table:
        print("THREAT_TABLE_NAME not configured, skipping write")
        return {"statusCode": 500, "body": "Table not configured"}

    records = event.get("detail") or event

    # GuardDuty event from EventBridge has detail as a single finding
    if isinstance(records, dict) and "id" in records:
        findings = [records]
    elif isinstance(records, list):
        findings = records
    else:
        findings = []

    written_ids = []

    for finding in findings:
        finding_id = finding.get("id") or finding.get("FindingId") or ""
        title = finding.get("title") or finding.get("Title") or "Unknown finding"
        description = finding.get("description") or finding.get("Description") or ""
        resource = (
            finding.get("resource", {})
            .get("resourceType")
        )

        severity_label = classify_severity(finding)

        item = {
            "id": finding_id or f"auto-{datetime.now(timezone.utc).isoformat()}",
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "severity": severity_label,
            "title": title,
            "description": description,
            "service": "GuardDuty",
            "resource": resource or "unknown",
            "raw": json.dumps(finding, default=_decimal_default),
        }

        table.put_item(Item=item)
        written_ids.append(item["id"])

        if sns and severity_label in ("High", "Critical"):
            msg = f"[{severity_label}] {title}\nResource: {item['resource']}\nDescription: {description}"
            sns.publish(
                TopicArn=sns_topic_arn,
                Subject=f"Cloud Security Alert: {severity_label}",
                Message=msg,
            )

    return {
        "statusCode": 200,
        "body": json.dumps({"written": written_ids}),
    }

