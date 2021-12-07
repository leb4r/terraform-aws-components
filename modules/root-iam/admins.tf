## admin role

module "admin_role" {
  source  = "cloudposse/iam-role/aws"
  version = "0.10.0"

  name = "${module.this.id}-admin"

  role_description = "Administrator role"

  policy_document_count = 0
  policy_description    = "Administrator access"
  principals = {
    AWS = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]
  }
}

resource "aws_iam_role_policy_attachment" "admin" {
  role       = module.admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
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
  name        = "${module.this.id}-assume-admin"
  description = "Allow assumption of ${module.admin_role.name}"
  policy      = data.aws_iam_policy_document.assume_admin.json
}

resource "aws_iam_group" "admins" {
  name = "${module.this.id}-admins"
}

resource "aws_iam_group_policy_attachment" "assume_admin" {
  group      = aws_iam_group.admins.name
  policy_arn = aws_iam_policy.assume_admin.arn
}

## admin users

module "admin_user" {
  source  = "cloudposse/iam-user/aws"
  version = "0.8.1"

  for_each = { for admin in var.admin_users : admin.user_name => admin }

  user_name             = each.value.user_name
  pgp_key               = lookup(each.value, "pgp_key", null)
  login_profile_enabled = lookup(each.value, "login_profile_enabled", null)
  groups                = [aws_iam_group.admins.name]
}
