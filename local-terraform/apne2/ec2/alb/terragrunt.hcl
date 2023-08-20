terraform {
    source = "../../../github.com/aws-alb"
}

include {
  path = find_in_parent_folders()
}

dependency "sg_alb" {
  config_path = "../sg/alb"
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

inputs ={
  name            = "nginx"
  vpc_id          = "${local.common_vars.vpc_id}"
  subnets         = [local.common_vars.public_subnets[0], local.common_vars.public_subnets[1]]
  security_groups = [
    dependency.sg_alb.outputs.this_security_group_id,
  ]

  load_balancer_type = "application"

  target_groups = [    {
      name             = "dev-apne2-kr-nginx-80"
      backend_protocol = "HTTP"
      backend_port     = 80

      health_check = {
        enabled             = true
        protocol            = "HTTP"
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        interval            = 10
      }

      deregistration_delay = 5
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "${local.common_vars.certificate_arn}"
      target_group_index = 0
    }
  ]

  tags = {
      Service = "nginx"
  }
}