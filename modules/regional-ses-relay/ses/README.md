# regional-ses-relay

Terraform module that provisions a regional SES mail relay. SES receives the emails and stores them in an S3 bucket. This then triggers a lambda which then forwards the mails based on the `var.forward_emails` mapping to the appropriate destination.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.31.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ses"></a> [ses](#module\_ses) | cloudposse/ses-lambda-forwarder/aws | 0.10.0 |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.ses](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket_public_access_block.ses](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_ses_domain_dkim.ses](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_dkim) | resource |
| [aws_ses_email_identity.emails](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_email_identity) | resource |
| [aws_route53_zone.ses](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region resources are deployed to | `string` | `"us-east-1"` | no |
| <a name="input_forward_emails"></a> [forward\_emails](#input\_forward\_emails) | Map of the email addresses that each recieving address will forward mail to, the relay will only function with the recieiving address is in this list | `map(list(string))` | <pre>{<br>  "ops@example.com": [<br>    "example@gmail.com"<br>  ]<br>}</pre> | no |
| <a name="input_hosted_zone"></a> [hosted\_zone](#input\_hosted\_zone) | The hosted zone to create MX and DKIM records in for sending and recieving | `string` | n/a | yes |
| <a name="input_lambda_runtime"></a> [lambda\_runtime](#input\_lambda\_runtime) | Lambda runtime | `string` | `"nodejs12.x"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | String to prefix resource names with | `string` | `""` | no |
| <a name="input_relay_email"></a> [relay\_email](#input\_relay\_email) | The address the relay will send as | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
