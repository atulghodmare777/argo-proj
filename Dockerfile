FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y curl gnupg2 lsb-release ca-certificates jq git bash

# Install GitHub CLI (gh)
RUN LATEST_VERSION=$(curl -s https://api.github.com/repos/cli/cli/releases/latest | jq -r .tag_name) && \
    curl -fsSL "https://github.com/cli/cli/releases/download/${LATEST_VERSION}/gh_${LATEST_VERSION#v}_linux_amd64.deb" -o gh-cli.deb && \
    dpkg -i gh-cli.deb && \
    apt-get install -f -y

# ARG and ENV setup
ARG PERSONAL_ACCESS_TOKEN
ARG TAG_NAME

ENV GH_TOKEN=$PERSONAL_ACCESS_TOKEN
ENV GITHUB_REPO="atulghodmare777/argo-proj"
ENV TAG_NAME=$TAG_NAME

# Trigger the workflow by name, and pass the tag as input
CMD gh workflow run "Second Workflow" \
      --ref main \
      --repo $GITHUB_REPO \
      -f tag=$TAG_NAME

