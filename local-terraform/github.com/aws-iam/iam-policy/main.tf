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

module "policy_label" {
  source = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.24.1"

  namespace  = var.namespace
  environment= var.environment
  stage      = var.stage
  name       = var.name
  attributes = concat(var.attributes, ["policy"])
  tags       = var.tags
}

module "policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = module.policy_label.id
  path        = var.path
  description = var.description
  policy      = var.policy
  tags        = module.policy_label.tags
}