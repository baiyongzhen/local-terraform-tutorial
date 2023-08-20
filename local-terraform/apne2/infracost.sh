#!/bin/bash

# Find the plan files
plans=($(find . -name plan.cache | tr '\n' ' '))

# Generate plan JSON files by running terragrunt show for each plan file
planjsons=()
for plan in "${plans[@]}"; do
  # Find the Terraform working directory for running terragrunt show
  # We want to take the dir of the plan file and strip off anything after the .terraform-cache dir
  # to find the location of the Terraform working directory that contains the Terraform code
  dir=$(dirname $plan)
  working_dir=$(echo "$dir" | sed 's/\(.*\)\/\.terragrunt-cache\/.*/\1/')

  echo "Running terragrunt show for $(basename $plan) for $working_dir";
  terragrunt show -json $(basename $plan) --terragrunt-working-dir $working_dir --terragrunt-no-auto-init > $working_dir/plan.json
  planjsons=(${planjsons[@]} "$working_dir/plan.json")
done

# Sort the plan JSONs so we get consistent project ordering in the config file
IFS=$'\n' planjsons=($(sort <<<"${planjsons[*]}"))

# Generate Infracost config file
echo -e "version: 0.1\n\nprojects:\n" > infracost.yml
for planjson in "${planjsons[@]}"; do
  echo -e "  - path: $planjson" >> infracost.yml
done

# Generate report
infracost breakdown --config-file=infracost.yml --format=json --out-file=infracost-base.json
infracost output --path infracost-base.json --format html --out-file report.html