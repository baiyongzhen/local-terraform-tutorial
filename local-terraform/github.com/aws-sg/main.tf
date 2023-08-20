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

module "security_group_label" {
  source = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.24.1"

  namespace  = var.namespace
  environment= var.environment
  stage      = var.stage
  name       = var.name
  attributes = concat(var.attributes, ["sg"])
}

module "security_group" {
  source                                                   = "terraform-aws-modules/security-group/aws"
  version                                                  = "4.0.0"

  name                                                     = module.security_group_label.id
  description                                              = var.description
  use_name_prefix                                           = var.use_name_prefix
  vpc_id                                                   = var.vpc_id

  ingress_with_self                                        = var.ingress_with_self
  ingress_with_cidr_blocks                                 = var.ingress_with_cidr_blocks
  ingress_with_ipv6_cidr_blocks                            = var.ingress_with_ipv6_cidr_blocks
  computed_ingress_with_source_security_group_id           = var.computed_ingress_with_source_security_group_id
  number_of_computed_ingress_with_source_security_group_id = length(var.computed_ingress_with_source_security_group_id)

  egress_rules                                             = var.egress_rules

  tags                                                     = module.security_group_label.tags
}