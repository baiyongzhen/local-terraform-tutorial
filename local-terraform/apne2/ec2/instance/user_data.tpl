#!/bin/bash
exec > /tmp/user_data.log 2>&1
set -x

mkdir ~/.aws
echo "[default]
region = ${aws_region}" > ~/.aws/config

# git ssh key
# .ssh/config
# ansible playbook