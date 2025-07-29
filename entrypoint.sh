#!/bin/bash

set -e

cd /home/runner

if [ ! -f .runner ]; then
  cd /tmp/runner
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
else
  cp /home/runner/.runner /tmp/runner/.runner
  cp /home/runner/.credentials /tmp/runner/.credentials
  cp /home/runner/.credentials_rsaparams /tmp/runner/.credentials_rsaparams
fi

echo "Runner registered. Starting..."

cd /tmp/runner

./run.sh &

sleep 15

cp /tmp/runner/.runner /home/runner/.runner
cp /tmp/runner/.credentials /home/runner/.credentials
cp /tmp/runner/.credentials_rsaparams /home/runner/.credentials_rsaparams


touch placeholder.txt
tail -f placeholder.txt

