#!/bin/bash

brew update
brew install influxdb@1

brew tap influxdata/tap
brew install influxctl

influxctl database create prapi


kill -9 $(lsof -t -i :8086)
/opt/homebrew/opt/influxdb@1/bin/influxd &
