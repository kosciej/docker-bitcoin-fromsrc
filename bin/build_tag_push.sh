#!/bin/bash

set -exuo pipefail

#TAG=${1:-latest}
TAG=0.15.0

docker build --no-cache -t juanjux/bitcoind:${TAG} .
docker login
docker push juanjux/bitcoind:${TAG}
