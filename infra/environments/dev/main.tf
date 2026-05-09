module "network" {
  source          = "../../modules/network"
  project_name    = var.project_name
  vpc_cidr_block  = var.vpc_cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "logging" {
  source       = "../../modules/logging"
  project_name = var.project_name
  vpc_id       = module.network.vpc_id
}

module "security_services" {
  source              = "../../modules/security_services"
  project_name        = var.project_name
  logs_bucket_arn     = module.logging.cloudtrail_bucket_arn
}

module "data_store" {
  source       = "../../modules/data_store"
  project_name = var.project_name
}

module "alerts" {
  source              = "../../modules/alerts"
  project_name        = var.project_name
  email_subscriptions = var.alert_emails
}

module "lambdas" {
  source                    = "../../modules/lambdas"
  project_name              = var.project_name
  threat_table_name         = module.data_store.threat_table_name
  sns_topic_arn             = module.alerts.alerts_topic_arn
  guardduty_event_rule_arn  = module.security_services.guardduty_event_rule_arn
  guardduty_event_rule_name = module.security_services.guardduty_event_rule_name
  lambda_package_path       = "${path.module}/../../lambdas/threat_ingest.zip"
}

module "ecr" {
  source       = "../../modules/ecr"
  project_name = var.project_name
}

module "app_container" {
  source             = "../../modules/app_container"
  project_name       = var.project_name
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
  aws_region         = var.aws_region

  frontend_image    = var.frontend_image
  backend_image     = var.backend_image
  threat_table_name = module.data_store.threat_table_name
  jwt_secret        = var.jwt_secret
}

module "monitoring" {
  source        = "../../modules/monitoring"
  project_name  = var.project_name
  lambda_name   = module.lambdas.lambda_name
  sns_topic_arn = module.alerts.alerts_topic_arn
}


