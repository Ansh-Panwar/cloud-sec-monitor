output "vpc_id" {
  value = module.network.vpc_id
}

output "alb_dns_name" {
  value = module.app_container.alb_dns_name
}

output "threats_table_name" {
  value = module.data_store.threat_table_name
}

output "alerts_topic_arn" {
  value = module.alerts.alerts_topic_arn
}

