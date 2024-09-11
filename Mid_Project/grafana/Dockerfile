# Use Grafana as base image
FROM grafana/grafana

# Create the necessary directories in the container
RUN mkdir -p /etc/grafana/provisioning/datasources /etc/grafana/provisioning/dashboards

# Copy Grafana provisioning files
COPY provisioning/datasources /etc/grafana/provisioning/datasources
COPY provisioning/dashboards /etc/grafana/provisioning/dashboards

# Expose the Grafana port
EXPOSE 3000

# Run Grafana
CMD ["/run.sh"]
