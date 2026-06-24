#!/bin/bash

set -e

echo "Updating packages..."
sudo apt update

echo "Installing dependencies..."
sudo apt install -y apt-transport-https software-properties-common wget

echo "Adding Grafana GPG key..."
wget -q -O - https://apt.grafana.com/gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/grafana.gpg

echo "Adding Grafana repository..."
echo "deb [signed-by=/usr/share/keyrings/grafana.gpg] https://apt.grafana.com stable main" | \
sudo tee /etc/apt/sources.list.d/grafana.list

echo "Updating package list..."
sudo apt update

echo "Installing Grafana..."
sudo apt install grafana -y

echo "Starting Grafana service..."
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

echo "Checking Grafana status..."
sudo systemctl status grafana-server --no-pager

echo "Grafana installation completed!"
echo "Access: http://<IP>:3000"
echo "Default Username: admin"
echo "Default Password: admin"
