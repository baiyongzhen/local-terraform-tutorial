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

locals {
  associate_public_ip_address = var.associate_eip ? true : var.associate_public_ip_address
  #ami                         = var.ami == "" ? data.aws_ami.this.id : var.ami
}

#data "aws_ami" "this" {
#  most_recent = true
#  owners      = ["self", "amazon"]
#
#  filter {
#    name = "name"
#
#    values = [
#      "${var.base_ami_tag_name}-*",
#    ]
#  }
#}

module "instance_label" {
  source = "cloudposse/label/null"
  version = "0.25.0"

  namespace   = var.namespace
  environment = var.environment
  stage       = var.stage
  name        = var.name
  attributes  = ["ec2", var.suffix_name]
  tags        = merge(tomap({"Service":"${var.name}"}), var.tags)
}

module "volume_label" {
  source = "cloudposse/label/null"
  version = "0.25.0"

  namespace   = var.namespace
  environment = var.environment
  stage       = var.stage
  name        = var.name
  attributes  = ["vol", var.suffix_name]
  tags        = merge(tomap({"Service":"${var.name}"}), var.tags)
}

module "instance" {
  source                               = "terraform-aws-modules/ec2-instance/aws"
  version                              = "3.5.0"
  
  create                               = var.create
  name                                 = module.instance_label.id
  #ami                                  = local.ami
  ami   = var.ami
  associate_public_ip_address          = var.associate_public_ip_address
  availability_zone                    = var.availability_zone
  capacity_reservation_specification   = var.capacity_reservation_specification
  cpu_credits                          = var.cpu_credits
  disable_api_termination              = var.disable_api_termination
  ebs_block_device                     = var.ebs_block_device
  ebs_optimized                        = var.ebs_optimized
  enclave_options_enabled              = var.enclave_options_enabled
  ephemeral_block_device               = var.ephemeral_block_device
  get_password_data                    = var.get_password_data
  hibernation                          = var.hibernation
  host_id                              = var.host_id
  iam_instance_profile                 = var.iam_instance_profile
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  instance_type                        = var.instance_type
  ipv6_address_count                   = var.ipv6_address_count
  ipv6_addresses                       = var.ipv6_addresses
  key_name                             = var.key_name
  launch_template                      = var.launch_template
  metadata_options                     = var.metadata_options
  monitoring                           = var.monitoring
  network_interface                    = var.network_interface
  placement_group                      = var.placement_group
  private_ip                           = var.private_ip
  root_block_device                    = var.root_block_device
  secondary_private_ips                = var.secondary_private_ips
  source_dest_check                    = var.source_dest_check
  subnet_id                            = var.subnet_id
  tags                                 = module.instance_label.tags
  tenancy                              = var.tenancy
  user_data                            = var.user_data
  user_data_base64                     = var.user_data_base64
  volume_tags                          = module.volume_label.tags
  enable_volume_tags                   = var.enable_volume_tags
  vpc_security_group_ids               = var.vpc_security_group_ids
  timeouts                             = var.timeouts
  cpu_core_count                       = var.cpu_core_count
  cpu_threads_per_core                 = var.cpu_threads_per_core
    
  #Spotinstancerequest
  create_spot_instance                = var.create_spot_instance
  spot_price                          = var.spot_price
  spot_wait_for_fulfillment           = var.spot_wait_for_fulfillment
  spot_type                           = var.spot_type
  spot_launch_group                   = var.spot_launch_group
  spot_block_duration_minutes         = var.spot_block_duration_minutes
  spot_instance_interruption_behavior = var.spot_instance_interruption_behavior
  spot_valid_until                    = var.spot_valid_until
  spot_valid_from                     = var.spot_valid_from
  putin_khuylo                        = var.putin_khuylo                                    
}

module "instance_eip_label" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  enabled    = var.associate_eip

  namespace   = var.namespace
  environment = var.environment
  stage       = var.stage
  name        = var.name
  attributes  = ["eip", var.suffix_name]
  tags        = merge(tomap({"Service":"${var.name}"}), var.tags)
}

resource "aws_eip" "this" {
  count = var.associate_eip ? 1 : 0
  vpc   = true
  tags  = module.instance_eip_label.tags
}

resource "aws_eip_association" "this" {
  count         = var.associate_eip ? 1 : 0
  instance_id   = module.instance.id
  allocation_id = element(aws_eip.this.*.id, count.index)
}