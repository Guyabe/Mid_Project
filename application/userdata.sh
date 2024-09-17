version: '3'
services:
  prometheus:
    image: gabecasis/prometheus:2
    ports:
      - "9090:9090"
    networks:
      - app-network
    restart: always
    volumes:
      - ./prometheus:/prometheus  # Persistent storage for Prometheus data
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml  # Custom Prometheus config

  grafana:
    image: gabecasis/grafana:2
    ports:
      - "3000:3000"
    networks:
      - app-network
    restart: always
    volumes:
      - ./grafana:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    depends_on:
      - loki

  loki:
    image: gabecasis/loki:2
    container_name: loki
    ports:
      - "3100:3100"
    networks:
      - app-network
    restart: always
    volumes:
      - ./loki/data:/loki

  promtail:
    image: gabecasis/promtail:2
    container_name: promtail
    ports:
      - "9080:9080"
    volumes:
      - ./promtail/config/config.yml:/etc/promtail/config.yml
      - ./loki/data:/var/log/loki
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
