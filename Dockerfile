# Use basic image
FROM ubuntu:20.04

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y curl gnupg2 lsb-release ca-certificates

# Install GitHub CLI directly via .deb package
RUN curl -fsSL https://github.com/cli/cli/releases/latest/download/gh_2.19.2_linux_amd64.deb -o gh-cli.deb && \
    dpkg -i gh-cli.deb && \
    apt-get install -f -y

# Set environment variables inside docker (optional)
ENV GITHUB_TOKEN="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"
ENV GITHUB_REPO="atulghodmare777/argo-proj"
ENV EVENT_TYPE="trigger-second-workflow"

# Authenticate gh CLI using the GitHub token
RUN echo $GITHUB_TOKEN | gh auth login --with-token

# Your normal commands
RUN echo "Running some setup commands..." \
    && echo "Doing something important..."

# After normal commands, trigger second workflow using gh CLI
CMD gh workflow run second.yaml \
    --ref main \
    --repo $GITHUB_REPO

