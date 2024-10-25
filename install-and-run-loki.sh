#!/bin/bash

mkdir -p loki

curl https://raw.githubusercontent.com/grafana/loki/v3.0.0/cmd/loki/loki-local-config.yaml -o loki/loki-config.yaml

if [ "$(docker ps -a -q -f name=loki)" ]; then
  # Stop and remove the existing container
  docker stop loki
  docker rm loki
fi

docker run --name loki -d -v $(pwd)/loki:/mnt/config -p 3100:3100 grafana/loki:3.0.0 -config.file=/mnt/config/loki-config.yaml
until [ "`docker inspect -f {{.State.Running}} loki`"=="true" ]; do
    sleep 0.1;
done;

docker container ls
