# outputs.tf

output "aws_zone_ns" {
  value       = aws_route53_zone.aws_zone.name_servers
  description = "NS records for hosted zone"
}

output "aws_zone_id" {
  value       = aws_route53_zone.aws_zone.id
  description = "hosted zone ID"
}
