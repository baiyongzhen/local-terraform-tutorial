provider "aws" {
  region = var.aws_region

  s3_force_path_style         = true
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


module "bucket_label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  namespace   = var.namespace
  stage       = var.stage
  name        = var.name
  environment = var.environment
  attributes  = concat(var.attributes, ["s3"])
  tags        = merge(tomap({"Service":"${var.name}"}), var.tags)
}

module "bucket" {
    source  = "terraform-aws-modules/s3-bucket/aws"
    version = "2.15.0"

    create_bucket                          = var.create_bucket
    attach_elb_log_delivery_policy         = var.attach_elb_log_delivery_policy
    attach_lb_log_delivery_policy          = var.attach_lb_log_delivery_policy
    attach_deny_insecure_transport_policy  = var.attach_deny_insecure_transport_policy
    attach_require_latest_tls_policy       = var.attach_require_latest_tls_policy
    attach_policy                          = var.attach_policy
    attach_public_policy                   = var.attach_public_policy
    bucket                                 = module.bucket_label.id
    bucket_prefix                          = var.bucket_prefix
    acl                                    = var.acl
    policy                                 = var.policy
    tags                                   = module.bucket_label.tags
    force_destroy                          = var.force_destroy
    acceleration_status                    = var.acceleration_status
    request_payer                          = var.request_payer
    website                                = var.website
    cors_rule                              = var.cors_rule
    versioning                             = var.versioning
    logging                                = var.logging
    grant                                  = var.grant
    lifecycle_rule                         = var.lifecycle_rule
    replication_configuration              = var.replication_configuration
    server_side_encryption_configuration   = var.server_side_encryption_configuration
    object_lock_configuration              = var.object_lock_configuration
    block_public_acls                      = var.block_public_acls
    block_public_policy                    = var.block_public_policy
    ignore_public_acls                     = var.ignore_public_acls
    restrict_public_buckets                = var.restrict_public_buckets
    control_object_ownership               = var.control_object_ownership
    object_ownership                       = var.object_ownership
}