locals {
  account_id = data.aws_caller_identity.current.account_id
  partition  = data.aws_partition.current.partition
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

resource "aws_iam_account_alias" "this" {
  account_alias = "${module.this.id}-account"
}

resource "aws_iam_account_password_policy" "this" {
  allow_users_to_change_password = true
  hard_expiry                    = false
  minimum_password_length        = 14 # do not use a value less than 14
  require_symbols                = true
  require_uppercase_characters   = true
  require_lowercase_characters   = true
  require_numbers                = true
}

data "aws_iam_policy_document" "manage_credentials" {
  statement {
    sid    = "AllowViewAccountInfo"
    effect = "Allow"
    actions = [
      "iam:GetAccountPasswordPolicy",
      "iam:GetAccountSummary"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowManageOwnPasswords"
    effect = "Allow"
    actions = [
      "iam:ChangePassword",
      "iam:GetUser"
    ]
    resources = [
      "arn:${local.partition}:iam::*:user/$${aws:username}"
    ]
  }

  statement {
    sid    = "AllowManageOwnKeys"
    effect = "Allow"
    actions = [
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:ListAccessKeys",
      "iam:UpdateAccessKey"
    ]
    resources = [
      "arn:${local.partition}:iam::*:user/$${aws:username}"
    ]
  }

  statement {
    sid    = "AllowManageOwnSSHPublicKeys"
    effect = "Allow"
    actions = [
      "iam:DeleteSSHPublicKey",
      "iam:GetSSHPublicKey",
      "iam:ListSSHPublicKeys",
      "iam:UpdateSSHPublicKey",
      "iam:UploadSSHPublicKey"
    ]

    resources = [
      "arn:${local.partition}:iam::*:user/$${aws:username}"
    ]
  }

  statement {
    sid    = "AllowListActions"
    effect = "Allow"
    actions = [
      "iam:ListUsers",
      "iam:ListVirtualMFADevices"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowIndividualUserToListOnlyTheirOwnMFA"
    effect = "Allow"
    actions = [
      "iam:ListMFADevices"
    ]
    resources = [
      "arn:${local.partition}:iam::*:mfa/$${aws:username}",
      "arn:${local.partition}:iam::*:user/$${aws:username}"
    ]
  }

  statement {
    sid    = "AllowIndividualUserTomanageTheirOwnMFA"
    effect = "Allow"
    actions = [
      "iam:CreateVirtualMFADevice",
      "iam:DeleteVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice"
    ]
    resources = [
      "arn:${local.partition}:iam::*:mfa/$${aws:username}",
      "arn:${local.partition}:iam::*:user/$${aws:username}"
    ]
  }

  statement {
    sid    = "AllowIndividualUserToDeactivateOnlyTheirMFAOnlyWhenUsingMFA"
    effect = "Allow"
    actions = [
      "iam:DeactivateMFADevice"
    ]
    resources = [
      "arn:${local.partition}:iam::*:mfa/$${aws:username}",
      "arn:${local.partition}:iam::*:user/$${aws:username}"
    ]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }

  statement {
    sid    = "BlockMostAccessUnlessSignedInWithMFA"
    effect = "Deny"
    not_actions = [
      "iam:ChangePassword",
      "iam:CreateVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ListMFADevices",
      "iam:ListUsers",
      "iam:ListVirtualMFADevices",
      "iam:ResyncMFADevice"
    ]
    resources = ["*"]

    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["false"]
    }
  }
}

resource "aws_iam_policy" "manage_credentials" {
  name        = "${module.this.id}-manage-credentials"
  description = "Allow user to manage credentials"
  policy      = data.aws_iam_policy_document.manage_credentials.json
}

resource "aws_iam_group_policy_attachment" "manage_credentials" {
  group      = aws_iam_group.admins.name
  policy_arn = aws_iam_policy.manage_credentials.arn
}
