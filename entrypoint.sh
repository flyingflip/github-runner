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
    sudo -u runner ./config.sh remove --unattended --token ${RUNNER_TOKEN}
  }
  trap 'cleanup; exit 130' INT
  trap 'cleanup; exit 143' TERM

  if [ ! -f config.sh ]; then
    cp -rf /home/github-actions/* /home/runner/.
    chown -R runner:runner /home/runner
    #ln -s /home/github-actions/bin /home/runner/bin
    #ln -s /home/github-actions/config.sh /home/runner/config.sh
    #ln -s /home/github-actions/env.sh /home/runner/env.sh
    #ln -s /home/github-actions/externals /home/runner/externals
    #ln -s /home/github-actions/run-helper.cmd.template /home/runner/run-helper.cmd.template
    #ln -s /home/github-actions/run-helper.sh.template /home/runner/run-helper.sh.template
    #ln -s /home/github-actions/run.sh /home/runner/run.sh
    #ln -s /home/github-actions/safe_sleep.sh /home/runner/safe_sleep.sh
    #ln -s /home/github-actions/.credentials
    #ln -s /home/github-actions/.credentials_rsaparams
    #ln -s /home/github-actions/.env
    #ln -s /home/github-actions/.path
    #ln -s /home/github-actions/.runner
    #ln -s /home/github-actions/_diag
    #ln -s /home/github-actions/run-helper.sh
    #ln -s /home/github-actions/svc.sh
  fi
  sudo -u runner ./config.sh \
    --url "$RUNNER_REPOSITORY_URL" \
    --token "$RUNNER_TOKEN" \
    --name "$RUNNER_NAME" \
    --work "/home/runner" \
    --unattended
fi

echo "Runner registered. Starting..."

sudo -u runner ./run.sh
