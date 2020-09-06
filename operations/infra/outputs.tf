output "ecr_api" {
  value = aws_ecr_repository.api.repository_url
}

output "ecr_web" {
  value = aws_ecr_repository.web.repository_url
}

output "rds_endpoint" {
  value = module.db.this_db_instance_endpoint
}

output "graylog_private_ip_addr" {
  value = aws_instance.graylog.private_ip
}

output "prometheus_private_ip_addr" {
  value = aws_instance.prometheus.private_ip
}

output "graylog_public_ip_addr" {
  value = aws_instance.graylog.public_ip
}

output "prometheus_public_ip_addr" {
  value = aws_instance.prometheus.public_ip
}

output "load_balancer" {
  value = module.alb.this_lb_dns_name
}

output "cdn_endpoint" {
  value = aws_cloudfront_distribution.cdn.domain_name
}
