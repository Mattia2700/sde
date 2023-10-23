# Use a base image for Prometheus and Node Exporter
FROM prom/prometheus:latest as prometheus
FROM prom/node-exporter:latest as node-exporter

# Build Grafana from source
FROM grafana/grafana-enterprise:latest as grafana

# Copy Prometheus configuration file to the image
COPY ./prometheus-config.yml /etc/prometheus/prometheus.yml

# Set up Grafana configurations, data sources, and dashboards
# This step involves copying your Grafana configurations, data sources, and dashboards to the appropriate locations inside the Grafana image.

# Final image
FROM debian:bullseye-slim

# Install required packages
RUN apt-get update && apt-get install -y procps

# Copy Prometheus and Node Exporter binaries from their respective images
COPY --from=prometheus /bin/prometheus /bin/prometheus
COPY --from=node-exporter /bin/node_exporter /bin/node_exporter

# Copy Grafana files from the build stage
COPY --from=grafana /usr/share/grafana /usr/share/grafana

# Copy Prometheus configuration file
COPY --from=grafana /etc/prometheus/prometheus.yml /etc/prometheus/prometheus.yml

# Set up volumes and network mode
VOLUME [ "/grafana", "/data" ]
EXPOSE 3000 9090 9100

# Entry point script to start services
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

