#!/bin/bash

set -e

cd /home/runner

if [ ! -f .runner ]; then
  if [[ -z "$RUNNER_NAME" || -z "$RUNNER_REPOSITORY_URL" || -z "$RUNNER_TOKEN" ]]; then
    echo "Missing required environment variables: RUNNER_NAME, RUNNER_REPOSITORY_URL, or RUNNER_TOKEN"
    exit 1
  fi

  cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${RUNNER_TOKEN}
  }
  trap 'cleanup; exit 130' INT
  trap 'cleanup; exit 143' TERM

  ./config.sh \
    --url "$RUNNER_REPOSITORY_URL" \
    --token "$RUNNER_TOKEN" \
    --name "$RUNNER_NAME" \
    --work "$RUNNER_WORKDIR" \
    --unattended
fi

echo "Runner registered. Starting..."

./run.sh