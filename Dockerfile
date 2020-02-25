FROM ubuntu:16.04
ENV TERRAFORM_VERSION 0.11.7
RUN apt-get update && apt-get install -y curl unzip git python-pip emacs24-nox rsync
RUN cd /usr/local/bin && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN pip install awscli boto3 botocore pyyaml pathlib
RUN apt-get install --reinstall groff-base
