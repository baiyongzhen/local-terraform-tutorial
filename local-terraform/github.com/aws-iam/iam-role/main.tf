provider "aws" {
  region = var.aws_region

  # LocalStack 
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = "http://localstack:4566"
    cloudformation = "http://localstack:4566"
    cloudwatch     = "http://localstack:4566"
    dynamodb       = "http://localstack:4566"
    es             = "http://localstack:4566"
    firehose       = "http://localstack:4566"
    iam            = "http://localstack:4566"
    kinesis        = "http://localstack:4566"
    lambda         = "http://localstack:4566"
    route53        = "http://localstack:4566"
    redshift       = "http://localstack:4566"
    s3             = "http://localstack:4566"
    secretsmanager = "http://localstack:4566"
    ses            = "http://localstack:4566"
    sns            = "http://localstack:4566"
    sqs            = "http://localstack:4566"
    ssm            = "http://localstack:4566"
    stepfunctions  = "http://localstack:4566"
    sts            = "http://localstack:4566"
    ec2            = "http://localstack:4566"
    rds            = "http://localstack:4566"
  }

}

 #terraform {
 #  # The configuration for this backend will be filled in by Terragrunt
 #  backend "s3" {}
 #}

terraform {
    # The configuration for this backend will be filled in by Terragrunt
    backend "consul" {}
}

module "assume_role_label" {
  source = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.24.1"

  namespace  = var.namespace
  environment= var.environment
  name       = var.name
  stage      = var.stage
  attributes = concat(var.attributes, ["role"])
}

module "assume_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "3.16.0"

  trusted_role_actions              = var.trusted_role_actions
  trusted_role_arns                 = var.trusted_role_arns
  trusted_role_services             = var.trusted_role_services
  mfa_age                           = var.mfa_age
  max_session_duration              = var.max_session_duration
  create_role                       = var.create_role
  create_instance_profile           = var.create_instance_profile
  role_name                         = module.assume_role_label.id
  role_path                         = var.role_path
  role_requires_mfa                 = var.role_requires_mfa
  role_permissions_boundary_arn     = var.role_permissions_boundary_arn
  tags                              = module.assume_role_label.tags
  custom_role_policy_arns           = var.custom_role_policy_arns
  number_of_custom_role_policy_arns = var.number_of_custom_role_policy_arns
  admin_role_policy_arn             = var.admin_role_policy_arn
  poweruser_role_policy_arn         = var.poweruser_role_policy_arn
  readonly_role_policy_arn          = var.readonly_role_policy_arn
  attach_admin_policy               = var.attach_admin_policy
  attach_poweruser_policy           = var.attach_poweruser_policy
  attach_readonly_policy            = var.attach_readonly_policy
  force_detach_policies             = var.force_detach_policies
  role_description                  = var.role_description
  role_sts_externalid               = var.role_sts_externalid
}