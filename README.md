# Terraform-aws-dns-terraform-module repository

This repo contains a Terraform module that manages an AWS Route53 Zone and its simple routing policy records.

## Features

* Manage AWS Route53 hosted zone
* Add/remove AWS Route53 records on the specified hosted zone

## Usage

```hcl
module dns {
  source  = "MauroSoli/dns/aws"

  dns_zone = "aws.example.com"

  records = [
   #[ "NAME",             "TYPE",  TTL,  [ "value" ]]
    [ "",                 "A",     600,  [ "123.123.123.123" ]],
    [ "record01",         "CNAME", 600,  [ "example.aws.example.com." ]],
    [ "record02",         "A",     600,  [ "143.204.9.89" ]],
    [ "email",            "TXT",   600,  [ "v=spf1 include:spf.protection.outlook.com -all" ]],
    [ "_sipexample._tcp", "SRV",   3600, [ "100 1 5050 example.com." ]],
    [ "999999t",          "MX",    3600, [ "10   mx.example.com." ]],
  ]

  alias_records = [
    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record#alias-record
    # The cloudfront hosted_zone_id is static: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/quickref-route53.html

    # [ "NAME", "TYPE", "ALIAS_NAME",             "ALIAS_ZONE_ID", EVALUATE_TARGET_HEALTH]
      [ "data", "A",    "example.cloudfront.net", "EXAMPLE",       false],
      [ "data", "AAAA", "example.cloudfront.net", "EXAMPLE",       false],
  ]
}

output "aws_ns_records" {
  value       = module.dns.aws_zone_ns
  description = "NS records for hosted zone"
}
```

**The records output from aws_ns_records must be added to the parent DNS Zone**

<br/>

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.41 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.41 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.aws_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.records](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.aws_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route53domains_registered_domain.aws_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53domains_registered_domain) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | AWS hosted zone name | `string` | n/a | yes |
| <a name="input_is_it_a_registered_domain"></a> [is\_it\_a\_registered\_domain](#input\_is\_it\_a\_registered\_domain) | Is the specified domain an AWS registered domain? | `bool` | `false` | no |
| <a name="input_records"></a> [records](#input\_records) | DNS records | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_zone_id"></a> [aws\_zone\_id](#output\_aws\_zone\_id) | hosted zone ID |
| <a name="output_aws_zone_ns"></a> [aws\_zone\_ns](#output\_aws\_zone\_ns) | NS records for hosted zone |
<!-- END_TF_DOCS -->
