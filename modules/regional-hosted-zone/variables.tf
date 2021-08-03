variable "aws_region" {
  description = "AWS region, used as the name of the Hosted Zone"
  type        = string
}

variable "parent_zone_name" {
  description = "The name of the Hosted Zone to delegate NS records in"
  type        = string
}
