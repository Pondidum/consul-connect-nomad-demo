#!/bin/sh -eu

echo "==> Configuring Consul"
(
cat <<-EOF
{
  "data_dir": "/var/consul",
  "client_addr": "127.0.0.1 {{ GetInterfaceIP \"eth0\" }}",
  "bind_addr": "{{ GetInterfaceIP \"eth0\" }}",
  "ui": true,
  "server": true,
  "bootstrap_expect": 3,
  "retry_join": [ "one.karhu.xyz", "two.karhu.xyz", "three.karhu.xyz" ],
  "connect": {
    "enabled": true
  }
}
EOF
) | tee /etc/consul/consul.json

rc-update add consul
rc-service consul start

sleep 2 # allow agent to start

echo "    Waiting for cluster to form"
while [ "$(consul operator raft list-peers | grep -c leader)" != "1" ]; do
  sleep 1
done

echo "    Done"
