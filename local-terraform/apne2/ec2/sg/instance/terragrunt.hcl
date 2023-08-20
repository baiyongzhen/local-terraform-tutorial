terraform {
    source = "../../../../github.com/aws-sg"
}

include {
  path = find_in_parent_folders()
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

dependency "sg_alb" {
  config_path = "../alb"
}

inputs ={
  name          = "nginx"
  vpc_id       = "${local.common_vars.vpc_id}"
  attributes    = ["ec2"]

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-8080-tcp"
      source_security_group_id = "${dependency.sg_alb.outputs.this_security_group_id}"
    }
  ]

  tags = {
      Service = "nginx"
  }
}