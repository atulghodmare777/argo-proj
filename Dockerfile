FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y curl gnupg2 lsb-release ca-certificates jq git bash


RUN LATEST_VERSION=$(curl -s https://api.github.com/repos/cli/cli/releases/latest | jq -r .tag_name) && \
    curl -fsSL "https://github.com/cli/cli/releases/download/${LATEST_VERSION}/gh_${LATEST_VERSION#v}_linux_amd64.deb" -o gh-cli.deb && \
    dpkg -i gh-cli.deb && \
    apt-get install -f -y


ARG PERSONAL_ACCESS_TOKEN
ENV GH_TOKEN=$PERSONAL_ACCESS_TOKEN
ENV GITHUB_REPO="atulghodmare777/argo-proj"


CMD gh workflow run second.yml --ref main --repo "$GITHUB_REPO"
