#!/bin/bash -eu

curl --request PUT --url http://localhost:8500/v1/agent/service/register \
  --data '{
    "name": "counter",
    "port": 9001,
    "connect": {
      "sidecar_service": {}
    }
  }'

PORT=9001 /vagrant/apps/bin/counter &

consul connect proxy -sidecar-for counter

echo "==> Cleaning Up"

kill $! # stop the counter

curl --request PUT --url http://localhost:8500/v1/agent/service/deregister/counter

echo "==> Done"
