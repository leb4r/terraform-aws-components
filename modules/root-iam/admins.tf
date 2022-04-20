locals {
  admin_users = {
    for admin in var.admin_users : admin.user_name => admin
  }
}

## admin role

module "admin_role" {
  source  = "cloudposse/iam-role/aws"
  version = "0.16.1"

  name = format("%s-admin", module.this.id)

  role_description = "Administrator role"

  policy_document_count = 0 # do not attach a policy to role

  principals = {
    AWS = [
      format("arn:%s:iam::%s:root", local.partition, local.account_id)
    ]
  }
}

resource "aws_iam_role_policy_attachment" "admin" {
  role       = module.admin_role.name
  policy_arn = format("arn:%s:iam::aws:policy/AdministratorAccess", local.partition)
}

## admin group

data "aws_iam_policy_document" "assume_admin" {
  statement {
    sid    = "AllowAssumeAdminRole"
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      module.admin_role.arn
    ]
  }
}

resource "aws_iam_policy" "assume_admin" {
  name        = format("%s-assume-admin", module.this.id)
  description = "Allow assumption of ${module.admin_role.name}"
  policy      = data.aws_iam_policy_document.assume_admin.json
}

resource "aws_iam_group" "admins" {
  name = format("%s-admins", module.this.id)
}

resource "aws_iam_group_policy_attachment" "assume_admin" {
  group      = aws_iam_group.admins.name
  policy_arn = aws_iam_policy.assume_admin.arn
}

## admin users

module "admin_user" {
  source  = "cloudposse/iam-user/aws"
  version = "0.8.1"

  for_each = local.admin_users

  user_name             = each.value.user_name
  pgp_key               = lookup(each.value, "pgp_key", null)
  login_profile_enabled = lookup(each.value, "login_profile_enabled", null)
  groups                = [aws_iam_group.admins.name]
}
