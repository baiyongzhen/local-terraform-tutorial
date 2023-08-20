provider "aws" {
  region = var.aws_region

  # LocalStack 
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  
  # https://registry.terraform.io/providers/hashicorp/aws/5.1.0/docs/guides/custom-service-endpoints.html#available-endpoint-customizations
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
    elb            = "http://localstack:4566"
    elbv2          = "http://localstack:4566"

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

locals {
  type = {
    "application" = "alb"
    "network" = "nlb"
  }
}

module "alb_label" {
  source = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.24.1"

  namespace   = var.namespace
  environment = var.environment
  stage       = var.stage
  name        = var.name
  attributes  = concat(var.attributes, [lookup(local.type, var.load_balancer_type)])
  tags        = merge(tomap({"Service":"${var.name}"}), var.tags)
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.5.0"
  name = module.alb_label.id

  load_balancer_type = var.load_balancer_type
  internal = var.internal

  vpc_id             = var.vpc_id
  access_logs        = var.access_logs
  subnets            = var.subnets
  security_groups    = var.security_groups

  target_groups           = var.target_groups
  http_tcp_listeners      = var.http_tcp_listeners
  https_listeners         = var.https_listeners
  http_tcp_listener_rules = var.http_tcp_listener_rules
  https_listener_rules    = var.https_listener_rules
  extra_ssl_certs         = var.extra_ssl_certs

  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  tags = module.alb_label.tags
}