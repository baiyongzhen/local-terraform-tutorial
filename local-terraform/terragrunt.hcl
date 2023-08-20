terraform {
  extra_arguments "-var-file" {
    commands = get_terraform_commands_that_need_vars()

    optional_var_files = [
      "${find_in_parent_folders("globals.tfvars", "ignore")}",
      "${find_in_parent_folders("locals.tfvars", "ignore")}"
    ]
  }

}

# consul
remote_state {
    backend = "consul"
    config = {
        path = "dev/${path_relative_to_include()}/terraform.tfstate"
        # access_token = "e33eweqeq"
        address = "consul:8500"
        scheme = "http"
        datacenter = "dc1"
    }
}
