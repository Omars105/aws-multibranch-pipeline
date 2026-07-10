#!/usr/bin/env bash
set -e

docker-compose -f docker-compose.yaml up -d

echo "success"
