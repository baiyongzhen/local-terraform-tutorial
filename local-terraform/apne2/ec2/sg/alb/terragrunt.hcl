terraform {
    source = "../../../../github.com/aws-sg"
}

include {
  path = find_in_parent_folders()
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

inputs ={
  name          = "nginx"
  #vpc_id        = dependency.vpc.outputs.vpc_id
  vpc_id       = "${local.common_vars.vpc_id}"
  attributes    = ["alb"]

  ingress_with_cidr_blocks = [
    {
      rule        = "https-443-tcp"
      cidr_blocks = "0.0.0.0/0"
    },    
    {
      rule             = "https-443-tcp"
      description      = "home network"
      cidr_blocks      = "21.149.116.11/32"
    },
    {
      rule             = "https-443-tcp"
      description      = "home network"
      cidr_blocks      = "66.32.106.22/32"
    },
  ]

  tags = {
      Service         = "nginx"
  }
}