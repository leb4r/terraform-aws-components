module "ses" {
  source  = "cloudposse/ses-lambda-forwarder/aws"
  version = "0.10.0"

  name           = join("-", [var.name_prefix, "ses"])
  region         = var.aws_region
  relay_email    = var.relay_email
  domain         = var.hosted_zone
  forward_emails = var.forward_emails
  lambda_runtime = var.lambda_runtime
}

resource "aws_ses_domain_dkim" "ses" {
  domain = var.hosted_zone
}

data "aws_route53_zone" "ses" {
  name = var.hosted_zone
}

resource "aws_route53_record" "ses" {
  count   = 3
  zone_id = data.aws_route53_zone.ses.id
  name    = "${element(aws_ses_domain_dkim.ses.dkim_tokens, count.index)}._domainkey.${var.hosted_zone}"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.ses.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

resource "aws_s3_bucket_public_access_block" "ses" {
  bucket                  = module.ses.s3_bucket_id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_ses_email_identity" "emails" {
  for_each = toset(compact(flatten(values(var.forward_emails))))
  email    = each.value
}
