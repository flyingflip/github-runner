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

  ln -s /tmp/runner/bin /home/runner/bin
  ln -s /tmp/runner/config.sh /home/runner/config.sh
  ln -s /tmp/runner/env.sh /home/runner/env.sh
  ln -s /tmp/runner/externals /home/runner/externals
  ln -s /tmp/runner/run-helper.cmd.template /home/runner/run-helper.cmd.template
  ln -s /tmp/runner/run-helper.sh.template /home/runner/run-helper.sh.template
  ln -s /tmp/runner/run.sh /home/runner/run.sh
  ln -s /tmp/runner/safe_sleep.sh /home/runner/safe_sleep.sh

  ./config.sh \
    --url "$RUNNER_REPOSITORY_URL" \
    --token "$RUNNER_TOKEN" \
    --name "$RUNNER_NAME" \
    --work "$RUNNER_WORKDIR" \
    --unattended
fi

echo "Runner registered. Starting..."

./run.sh