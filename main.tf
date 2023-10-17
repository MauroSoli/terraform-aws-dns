# dns/main.tf
###################################################################################################

# Manage resources related to Route53 DNS zones and records
resource "aws_route53_zone" "aws_zone" {
  name          = var.dns_zone
  comment       = "DNS zone for resources on AWS"
  force_destroy = false
}

# Manage NS records
resource "aws_route53_record" "aws_zone" {
  allow_overwrite = true
  name            = aws_route53_zone.aws_zone.name
  ttl             = 172800
  type            = "NS"
  zone_id         = aws_route53_zone.aws_zone.zone_id

  records = [
    aws_route53_zone.aws_zone.name_servers[0],
    aws_route53_zone.aws_zone.name_servers[1],
    aws_route53_zone.aws_zone.name_servers[2],
    aws_route53_zone.aws_zone.name_servers[3],
  ]
}

# For registered domain only
# Terraform destroy will not remove this registered domain
resource "aws_route53domains_registered_domain" "aws_zone" {
  count       = var.is_it_a_registered_domain != false ? 1 : 0
  domain_name = aws_route53_zone.aws_zone.name

  name_server {
    name = aws_route53_zone.aws_zone.name_servers[0]
  }
  name_server {
    name = aws_route53_zone.aws_zone.name_servers[1]
  }
  name_server {
    name = aws_route53_zone.aws_zone.name_servers[2]
  }
  name_server {
    name = aws_route53_zone.aws_zone.name_servers[3]
  }
}


# dns records
###################################################################################################

resource "aws_route53_record" "records" {
  for_each = { for record in var.records : join(".", [record[0], record[1]]) => record }

  zone_id = aws_route53_zone.aws_zone.zone_id
  name    = each.value[0] != "" ? "${each.value[0]}.${aws_route53_zone.aws_zone.name}" : aws_route53_zone.aws_zone.name
  type    = each.value[1]
  ttl     = each.value[2]
  records = each.value[3]
}

# alias records 
resource "aws_route53_record" "alias_records" {
  for_each = { for record in var.alias_records : join(".", [record[0], record[1]]) => record }

  zone_id = aws_route53_zone.aws_zone.zone_id
  name    = each.value[0] != "" ? "${each.value[0]}.${aws_route53_zone.aws_zone.name}" : aws_route53_zone.aws_zone.name
  type    = each.value[1]

  alias {
    name                   = each.value[2]
    zone_id                = each.value[3]
    evaluate_target_health = each.value[4]
  }
}
