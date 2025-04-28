# Use basic image
FROM ubuntu:20.04

# Install curl
RUN apt-get update && apt-get install -y curl

# Set environment variables inside docker (optional, or you can pass them during docker run)
ENV GITHUB_TOKEN="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"
ENV GITHUB_REPO="atulghodmare777/argo-proj"
ENV EVENT_TYPE="trigger-second-workflow"

# Your normal commands
RUN echo "Running some setup commands..." \
    && echo "Doing something important..." 

# After normal commands, trigger second workflow
CMD curl -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: token $GITHUB_TOKEN" \
    https://api.github.com/repos/$GITHUB_REPO/dispatches \
    -d "{\"event_type\":\"$EVENT_TYPE\"}"
