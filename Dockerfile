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

CMD bash -c "\
  git config --global user.email 'github-actions@example.com' && \
  git config --global user.name 'github-actions' && \
  git clone https://x-access-token:$GH_TOKEN@github.com/$GITHUB_REPO repo && \
  cd repo && \
  echo \"Triggered at $(date)\" >> tag-log.txt && \
  git add tag-log.txt && \
  git commit -m 'Trigger tag for second workflow' && \
  TAG_NAME=v$(date +%Y%m%d%H%M%S) && \
  git tag $TAG_NAME && \
  git push origin main --follow-tags && \
  echo \"Pushed tag: $TAG_NAME\""
