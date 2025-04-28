# Use basic image
FROM ubuntu:20.04

# Install necessary dependencies including git and jq for JSON parsing
RUN apt-get update && \
    apt-get install -y curl gnupg2 lsb-release ca-certificates jq git

# Install GitHub CLI directly via dynamic version download
RUN LATEST_VERSION=$(curl -s https://api.github.com/repos/cli/cli/releases/latest | jq -r .tag_name) && \
    curl -fsSL "https://github.com/cli/cli/releases/download/${LATEST_VERSION}/gh_${LATEST_VERSION#v}_linux_amd64.deb" -o gh-cli.deb && \
    dpkg -i gh-cli.deb && \
    apt-get install -f -y

# Set environment variables inside docker (optional)
ENV GITHUB_TOKEN="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"
ENV GITHUB_REPO="atulghodmare777/argo-proj"
ENV EVENT_TYPE="trigger-second-workflow"

# Authenticate gh CLI using the GitHub token
RUN gh auth login --with-token <<< "$GITHUB_TOKEN"

# Your normal commands
RUN echo "Running some setup commands..." \
    && echo "Doing something important..."

# After normal commands, trigger second workflow using gh CLI
CMD gh workflow run second.yaml \
    --ref main \
    --repo $GITHUB_REPO

