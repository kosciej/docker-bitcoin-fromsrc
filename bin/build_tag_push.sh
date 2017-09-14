#!/bin/bash

set -exuo pipefail

TAG=${1:-latest}

docker build --no-cache -t juanjux/bitcoind:${TAG} .
docker login
docker push juanjux/bitcoind:${TAG}
