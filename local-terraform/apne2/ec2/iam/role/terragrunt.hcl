terraform {
    source = "../../../../github.com/aws-iam/iam-role"
}

include {
  path = find_in_parent_folders()
}

dependency "policy" {
  config_path = "../policy"
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

inputs ={
  name          = "nginx"
  attributes    = ["ec2"]

  create_role             = true
  role_requires_mfa       = false
  create_instance_profile = true

  trusted_role_services = [
    "ec2.amazonaws.com"
  ]

  custom_role_policy_arns = [
    "${dependency.policy.outputs.arn}",
    #local.common_vars.ssm_policy_arn
  ]

  tags = {
      Service = "nginx"
  }

}