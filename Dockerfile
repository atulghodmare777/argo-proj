FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl gnupg2 lsb-release ca-certificates jq git bash

# Install GitHub CLI
RUN LATEST_VERSION=$(curl -s https://api.github.com/repos/cli/cli/releases/latest | jq -r .tag_name) && \
    curl -fsSL "https://github.com/cli/cli/releases/download/${LATEST_VERSION}/gh_${LATEST_VERSION#v}_linux_amd64.deb" -o gh-cli.deb && \
    dpkg -i gh-cli.deb && \
    apt-get install -f -y

# Accept arguments
ARG PERSONAL_ACCESS_TOKEN
ARG TAG_NAME

# Set environment variables
ENV GH_TOKEN=$PERSONAL_ACCESS_TOKEN
ENV GITHUB_REPO="atulghodmare777/argo-proj"
ENV TAG_NAME=$TAG_NAME

# Trigger second workflow
CMD gh workflow run second.yml --ref main --repo $GITHUB_REPO -f tag=$TAG_NAME
