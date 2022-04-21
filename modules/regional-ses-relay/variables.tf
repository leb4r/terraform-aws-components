variable "aws_region" {
  description = "The AWS Region resources are deployed to"
  type        = string
  default     = "us-east-1"
}

variable "lambda_runtime" {
  description = "The Lambda runtime to use for the forwarder"
  type        = string
  default     = "nodejs12.x"
}

variable "hosted_zone" {
  description = "The hosted zone to create MX and DKIM records in for sending and recieving"
  type        = string
}

# emails

variable "relay_email" {
  description = "The address the relay will forward emails send as"
  type        = string
}

variable "forward_emails" {
  description = <<-EOT
    Map of the email addresses that each recieving address will forward mail to.
    The relay will only function with the recieiving addresses is in this list.
  EOT

  type = map(list(string))

  default = {
    "ops@example.com" = ["example@gmail.com"]
  }
}
