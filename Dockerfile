FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y curl gnupg2 lsb-release ca-certificates jq git bash

# Install GitHub CLI
RUN LATEST_VERSION=$(curl -s https://api.github.com/repos/cli/cli/releases/latest | jq -r .tag_name) && \
    curl -fsSL "https://github.com/cli/cli/releases/download/${LATEST_VERSION}/gh_${LATEST_VERSION#v}_linux_amd64.deb" -o gh-cli.deb && \
    dpkg -i gh-cli.deb && \
    apt-get install -f -y

# Accept arguments for personal access token
ARG PERSONAL_ACCESS_TOKEN

# Set environment variables
ENV GH_TOKEN=$PERSONAL_ACCESS_TOKEN
ENV GITHUB_REPO="atulghodmare777/argo-proj"

# Git authentication
RUN git config --global url."https://$GH_TOKEN@github.com".insteadOf "https://github.com"

# Trigger second workflow
CMD bash -c "\
  git config --global user.email 'bot@example.com' && \
  git config --global user.name 'GitHub Bot' && \
  git clone https://github.com/$GITHUB_REPO && \
  cd $(basename $GITHUB_REPO) && \
  echo 'some change $(date)' >> trigger.txt && \
  git add trigger.txt && \
  git commit -m 'chore(tag): trigger new version' && \
  git push origin main && \
  export NEW_TAG=v$(date +'%Y%m%d%H%M%S') && \
  git tag $NEW_TAG && \
  git push origin $NEW_TAG"
