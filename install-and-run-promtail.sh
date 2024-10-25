#!/bin/bash

brew install promtail

mkdir -p promtail

cat << 'EOF' > promtail/promtail-config.yaml
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://localhost:3100/loki/api/v1/push

scrape_configs:
- job_name: system
  static_configs:
    - targets:
        - localhost
      labels:
        job: varlogs  # A `job` label is fairly standard in prometheus and useful for linking metrics and logs.
        host: yourhost # A `host` label will help identify logs from this machine vs others
        __path__: /var/log/*.log  # The path matching uses a third party library: https://github.com/bmatcuk/doublestar
EOF

kill -9 $(lsof -t -i:9080)

promtail --config.file=promtail/promtail-config.yaml
