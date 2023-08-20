terraform {
    source = "../../../github.com/aws-ec2"
}

include {
    path = find_in_parent_folders()
}

dependency "sg_instance" {
  config_path = "../sg/instance"
}

dependency "iam_role" {
  config_path = "../iam/role"
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

inputs = {
    name                    = "nginx"
    suffix_name             = "01"
    ami                     = "ami-0d57c0143330e1fa7"
    instance_type           = "t3.small"
    vpc_security_group_ids  = [
      dependency.sg_instance.outputs.this_security_group_id
    ]
    subnets                 = [
      local.common_vars.public_subnets[0], 
      local.common_vars.public_subnets[1]]
    iam_instance_profile    = dependency.iam_role.outputs.this_iam_instance_profile_name

    associate_public_ip_address = true
    associate_eip               = true

    user_data = templatefile("./user_data.tpl",    {
      aws_region            = "ap-southeast-1",
    })

    # https://github.com/localstack/localstack/issues/6062
    #root_block_device = [
    #  {
    #      delete_on_termination = true
    #      iops                  = 3000
    #      volume_size           = 20
    #      volume_type           = "gp3"
    #  }
    #]

    ebs_block_device = [{
      device_name           = "/dev/xvda"
      volume_size           = "50"
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }]

    key_name          = local.common_vars.ssh_key_name

    tags = {
      Service         = "nginx"
    }
}