project_name   = "cloud-sec-monitor"
aws_region     = "us-east-1"

vpc_cidr_block = "10.0.0.0/16"

public_subnets = [
  "10.0.21.0/24",
  "10.0.22.0/24",
]

private_subnets = [
  "10.0.31.0/24",
  "10.0.32.0/24",
]

alert_emails = [
  "anshpanwar197@gmail.com",
]

frontend_image = "767398040636.dkr.ecr.us-east-1.amazonaws.com/cloud-sec-monitor-frontend:dev"
#backend_image  = "767398040636.dkr.ecr.us-east-1.amazonaws.com/cloud-sec-monitor-backend:dev"

#frontend_image = "nginxdemos/hello"
backend_image = "nginxdemos/hello"


jwt_secret = "aaaaaaabbbbbbfffffhhhhhhhh"

