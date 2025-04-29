FROM ubuntu:20.04

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y curl gnupg2 lsb-release ca-certificates jq git bash

# Install GitHub CLI
RUN LATEST_VERSION=$(curl -s https://api.github.com/repos/cli/cli/releases/latest | jq -r .tag_name) && \
    curl -fsSL "https://github.com/cli/cli/releases/download/${LATEST_VERSION}/gh_${LATEST_VERSION#v}_linux_amd64.deb" -o gh-cli.deb && \
    dpkg -i gh-cli.deb && \
    apt-get install -f -y

# Accept a build-time argument
ARG PERSONAL_ACCESS_TOKEN

# Set it as ENV so it persists into runtime
ENV GH_TOKEN=$PERSONAL_ACCESS_TOKEN
ENV GITHUB_REPO="atulghodmare777/argo-proj"

# This should not be done at build time!
# Don't do RUN gh auth login here, do it in CMD or entrypoint

# Default command: login and run workflow
CMD echo "$GH_TOKEN" | gh auth login --with-token && \
    gh workflow run second.yml --ref main --repo $GITHUB_REPO
