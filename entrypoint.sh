#!/bin/bash

# Start Prometheus
echo "Starting Prometheus..."
nohup /bin/prometheus --config.file=/etc/prometheus/prometheus.yml >/dev/null 2>&1 &

# Wait for Prometheus to start (you can adjust the sleep duration as needed)
sleep 5

# Start Node Exporter
echo "Starting Node Exporter..."
nohup /bin/node_exporter --path.procfs=/host/proc --path.sysfs=/host/sys --collector.filesystem.ignored-mount-points='^/(sys|proc|dev|host|etc)($$|/)' >/dev/null 2>&1 &

# Start Grafana
echo "Starting Grafana..."
exec /usr/share/grafana/bin/grafana-server --homepath=/usr/share/grafana cfg:default.paths.logs=/var/log/grafana cfg:default.paths.data=/grafana data=/grafana
