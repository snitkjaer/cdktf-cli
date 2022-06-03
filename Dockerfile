FROM python:3.7-slim

ARG TF_VERSION="1.2.2"

LABEL author="Bo Snitkjaer Nielsen"
LABEL maintainer="https://github.com/snitkjaer/cdktf-cli"
LABEL name="cdktf-cli"

# Python
RUN pip install pipenv

# Update
RUN apt-get update
RUN apt-get upgrade

# Terraform prereqs
RUN apt-get install curl -y
RUN apt-get install gnupg2 -y
RUN apt-get install unzip
RUN apt-get install npm -y
RUN apt-get install python3-distutils -y

# Node.js
RUN npm install -g n
RUN n stable
RUN hash -r

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN ARCH=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) \
    && curl -o terraform.zip "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_${ARCH}.zip" \
	&& unzip -o terraform.zip \
	&& rm terraform.zip \
	&& mv terraform /usr/local/bin/

# Terraform CDK
RUN npm install --location=global cdktf-cli@latest