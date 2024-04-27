#checkov:skip=CKV_DOCKER_2: "Ensure that HEALTHCHECK instructions have been added to container images"
#checkov:skip=CKV_DOCKER_3: "Ensure that a user for the container has been created"
FROM debian:bookworm-slim

# Common tools
#checkov:skip=CKV_DOCKER_9: "Ensure that APT isn't used"
RUN apt update && apt install -y ca-certificates curl gnupg make gcc zip unzip apt-utils apt-transport-https software-properties-common \
    python3 python3-pip \
    --no-install-recommends

# AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "tmp/awscliv2.zip"
RUN cd /tmp && unzip awscliv2.zip
RUN ./tmp/aws/install

# Terraform
ARG TERRAFORM_VERSION
RUN curl -o /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin && \
    rm /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Setup Nodejs
ARG NODE_MAJOR
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

# Install Nodejs
RUN apt-get update && apt-get install -y nodejs --no-install-recommends
