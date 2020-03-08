#!/bin/bash -eu

curl --request PUT --url http://localhost:8500/v1/agent/service/register \
  --data '{
  "name": "dashboard",
  "port": 9002,
  "connect": {
    "sidecar_service": {
      "proxy": {
        "upstreams": [
          { "destination_name": "counter", "local_bind_port": 8080 }
        ]
      }
    }
  }
}'

PORT=9002 COUNTING_SERVICE_URL="http://localhost:8080" /vagrant/apps/bin/dashboard &

consul connect proxy -sidecar-for dashboard

echo "==> Cleaning Up"

kill $! # stop the dashboard-proxy
curl --request PUT --url http://localhost:8500/v1/agent/service/deregister/dashboard

echo "==> Done"
