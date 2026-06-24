#!/bin/bash

set -e

NODE_EXPORTER_VERSION="1.11.1"

echo "Creating node_exporter user.."
sudo useradd --no-create-home --shell /bin/false node_exporter 2>/dev/null || true

echo "Downloading Node Exporter.."
wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz

sleep 3

echo "Extracting package.."
tar -xzf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz

echo "Installing binary..."
sudo cp node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/

echo "Creating systemd service..."
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo "Reloading systemd.."
sudo systemctl daemon-reload

sleep 3

echo "Enabling and starting Node Exporter.."
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

echo "Checking service status..."
sudo systemctl status node_exporter --no-pager

echo ""
echo "Node Exporter installed successfully!"
echo "Metrics URL:"
echo "http://$(hostname -I | awk '{print $1}'):9100/metrics"
