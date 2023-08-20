FROM amazonlinux:2

USER root
LABEL "purpose"="local"
# Default Time Zone Change
# install required yum package
# install direnv
# install tfswitch for terraform version
# install tgswitch for terragrunt version
# install checkov for security policy
# install infracost
RUN rm -f /etc/localtime && ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \
    yum install -y wget unzip tar gzip git vim jq graphviz && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    JQ=/usr/bin/jq && \
    curl -L curl -sfL https://direnv.net/install.sh | bash && \
    echo 'eval "$(direnv hook bash)"' >> /root/.bashrc && \
    curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash && tfswitch 0.14.7 && \
    curl -L https://raw.githubusercontent.com/warrensbox/tgswitch/release/install.sh | bash && tgswitch 0.28.7 && \
    amazon-linux-extras install -y python3.8 && \
    curl -O https://bootstrap.pypa.io/get-pip.py && \
    python3.8 get-pip.py && \
    pip install awscli boto3 checkov && \
    curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh