CMD bash -c "\
  echo 'Starting Git process...'; \
  git config --global user.email 'bot@example.com' && \
  git config --global user.name 'GitHub Bot' && \
  git clone https://github.com/$GITHUB_REPO && \
  cd $(basename $GITHUB_REPO) && \
  echo 'Some change $(date)' >> trigger.txt && \
  git add trigger.txt && \
  git commit -m 'chore(tag): trigger new version'; \
  echo 'Before tagging, current tags:' && git tag -l && \
  export NEW_TAG=v$(date +'%Y%m%d%H%M%S')-$(openssl rand -hex 3) && \
  echo 'Creating new tag: $NEW_TAG' && \
  git tag $NEW_TAG && \
  echo 'After tagging, current tags:' && git tag -l && \
  git push origin main && \
  echo 'Pushing new tag: $NEW_TAG' && \
  git push origin $NEW_TAG"
