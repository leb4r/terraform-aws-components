variable "admin_users" {
  description = "Map of users to grant ability to assume the Administrator role for the account"
  type = list(object({
    user_name = string
    pgp_key   = string
  }))
  default = []
}
