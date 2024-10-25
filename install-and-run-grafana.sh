#!/bin/bash

# Update and install Grafana
brew update
brew install grafana

# Start Grafana service
brew services start grafana

# Check if a password argument is provided
if [ -z "$1" ]; then
  echo "No new password set, default is 'admin'"
else
  # Reset the admin password using provided argument
  /opt/homebrew/opt/grafana/bin/grafana-cli \
    --config /opt/homebrew/etc/grafana/grafana.ini \
    --homepath /opt/homebrew/opt/grafana/share/grafana \
    --configOverrides cfg:default.paths.data=/opt/homebrew/var/lib/grafana \
    admin reset-admin-password "$1"
fi

# Update the Grafana port
sed -i '' 's/;http_port = 3000/http_port = 3005/' /opt/homebrew/etc/grafana/grafana.ini

# Restart Grafana service to apply changes
brew services restart grafana

echo "Visit grafana at http://localhost:3005. Default login is 'admin'"
