output "admin_users_keybase_password_decrypt_command" {
  description = "Command that can be used to decrypt users' password"
  value = tomap({
    for k, admin in module.admin_user : k => admin.keybase_password_decrypt_command
  })
}
