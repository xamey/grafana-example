#!/bin/bash

./install-and-run-grafana.sh $1
./install-and-run-loki.sh
./install-and-run-promtail.sh &
./install-and-run-influxdb.sh &
./install-and-run-prometheus.sh &
