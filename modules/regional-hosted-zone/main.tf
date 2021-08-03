module "regional_zone" {
  source  = "cloudposse/route53-cluster-zone/aws"
  version = "0.13.0"
  context = module.this.context

  name                       = var.aws_region
  parent_zone_name           = var.parent_zone_name
  parent_zone_record_enabled = true
  zone_name                  = "$${name}.$${parent_zone_name}"
}
