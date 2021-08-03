variable "aws_region" {
  description = "AWS Region resources are deployed to"
  type        = string
  default     = "us-east-1"
}

variable "lambda_runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "nodejs12.x"
}

variable "hosted_zone" {
  description = "The hosted zone to create MX and DKIM records in for sending and recieving"
  type        = string
}

# emails

variable "relay_email" {
  description = "The address the relay will send as"
  type        = string
}

variable "forward_emails" {
  description = <<-EOF
  Map of the email addresses that each recieving address will forward mail to, the relay will only function with the recieiving address is in this list
  EOF

  type = map(list(string))

  default = {
    "ops@example.com" = ["example@gmail.com"]
  }
}
