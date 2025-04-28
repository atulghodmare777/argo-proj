# Use basic image
FROM ubuntu:20.04

# Install curl, gnupg2, and dependencies
RUN apt-get update && \
    apt-get install -y curl gnupg2 lsb-release ca-certificates

# Add GitHub CLI repository and key
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive.key | tee /etc/apt/trusted.gpg.d/githubcli-archive.key && \
    echo "deb [arch=amd64] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list && \
    apt-get update

# Install GitHub CLI
RUN apt-get install -y gh

# Set environment variables inside docker (optional, or you can pass them during docker run)
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

