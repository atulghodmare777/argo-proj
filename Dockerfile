FROM ubuntu:20.04
# Ensure you have necessary packages installed
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    git

# Install GitHub CLI
RUN LATEST_VERSION=$(curl -s https://api.github.com/repos/cli/cli/releases/latest | jq -r .tag_name) && \
    curl -fsSL "https://github.com/cli/cli/releases/download/${LATEST_VERSION}/gh_${LATEST_VERSION#v}_linux_amd64.deb" -o gh-cli.deb && \
    dpkg -i gh-cli.deb && \
    apt-get install -f -y

# Authenticate with GitHub CLI using an environment variable (GH_TOKEN will be passed in CI/CD)
RUN gh auth login --with-token <<< "$PERSONAL_ACCESS_TOKEN"

# Run workflow with GitHub CLI
RUN gh workflow run second.yml \
    --ref main \
    --repo atulghodmare777/argo-proj

