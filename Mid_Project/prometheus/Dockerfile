# Use the official Prometheus base image
FROM prom/prometheus

# Copy the Prometheus configuration file into the container
COPY prometheus.yml /etc/prometheus/prometheus.yml

# Expose Prometheus port
EXPOSE 9090

# Start Prometheus correctly with the config file
CMD ["--config.file=/etc/prometheus/prometheus.yml"]
