
#!/bin/bash

set -e

PROM_VERSION="3.12.0"

echo "Updating..."
sudo apt update -y
sudo apt upgrade -y

echo "Creating Prometheus user..."
sudo useradd --no-create-home --shell /bin/false prometheus || true

echo "Creating directories..."
sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus

echo "Downloading..."
wget https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz

sleep 3
echo "Extracting..."
tar -xvf prometheus-${PROM_VERSION}.linux-amd64.tar.gz

cd prometheus-${PROM_VERSION}.linux-amd64

echo "Copying binaries..."
sudo cp prometheus /usr/local/bin/
sudo cp promtool /usr/local/bin/

echo "Copying configuration..."
sudo cp prometheus.yml /etc/prometheus/

echo "Setting permissions..."
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus

echo "Creating systemd service..."
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]
Description=Prometheus
After=network.target

[Service]
User=prometheus
Group=prometheus

ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus

Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo "Starting Prometheus..."
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

sleep 5
echo "Checking status..."
sudo systemctl status prometheus --no-pager

echo "Prometheus Installed Successfully"
echo "Access: http://<IP>:9090"
