#!/bin/bash

mkdir -p prometheus

cat << 'EOF' > prometheus/prometheus-config.yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
- job_name: 'rails'
  scheme: http
  metrics_path: '/metrics'
  static_configs:
    - targets:
      - 'host.docker.internal:3000'
EOF

if [ "$(docker ps -a -q -f name=prometheus)" ]; then
  # Stop and remove the existing container
  docker stop prometheus
  docker rm prometheus
fi

docker run --name prometheus -d -v $(pwd)/prometheus:/mnt/config -p 9090:9090 prom/prometheus:latest --config.file=/mnt/config/prometheus-config.yaml
until [ "`docker inspect -f {{.State.Running}} prometheus`"=="true" ]; do
    sleep 0.1;
done;

docker container ls
