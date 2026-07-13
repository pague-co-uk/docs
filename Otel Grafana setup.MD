# Setting up OTel Collector + Grafana OSS (no Docker)

Assumes Ubuntu/Debian with systemd and sudo access. You already have MySQL, Redis, and RabbitMQ running — this adds four new services: Prometheus (metrics store), Loki (logs store), Tempo (traces store), the OTel Collector (receives from apps, fans out to the three stores above), and Grafana itself (dashboards over all three).

Run everything as your normal sudo user; each service gets its own dedicated system user for security, following the same pattern as MySQL/Redis running under their own accounts rather than root.

---

## 0. Create a shared observability directory structure

```bash
sudo mkdir -p /opt/observability/{prometheus,loki,tempo,otelcol}
sudo mkdir -p /etc/{prometheus,loki,tempo,otelcol}
sudo mkdir -p /var/lib/{prometheus,loki,tempo}
```

---

## 1. Prometheus (metrics store)

```bash
# Get the latest version number
PROM_VERSION=$(curl -s https://api.github.com/repos/prometheus/prometheus/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
echo "Installing Prometheus $PROM_VERSION"

cd /tmp
curl -LO "https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz"
tar xzf "prometheus-${PROM_VERSION}.linux-amd64.tar.gz"
cd "prometheus-${PROM_VERSION}.linux-amd64"

sudo useradd --no-create-home --shell /usr/sbin/nologin prometheus
sudo cp prometheus promtool /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/prometheus /usr/local/bin/promtool
sudo chown -R prometheus:prometheus /var/lib/prometheus /etc/prometheus
```

Config file:

```bash
sudo tee /etc/prometheus/prometheus.yml > /dev/null <<'EOF'
global:
  scrape_interval: 15s

# The OTel Collector will push metrics here via remote-write,
# so no scrape_configs are needed for your app services directly.
EOF
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml
```

Enable remote-write receiving (required for the collector to push into Prometheus):

Systemd unit:

```bash
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<'EOF'
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --web.enable-remote-write-receiver \
  --web.listen-address=0.0.0.0:9090

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now prometheus
sudo systemctl status prometheus --no-pager
```

Verify: `curl http://localhost:9090/-/healthy` should return `Prometheus Server is Healthy.`

---

## 2. Loki (logs store)

```bash
LOKI_VERSION=$(curl -s https://api.github.com/repos/grafana/loki/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
echo "Installing Loki $LOKI_VERSION"

cd /tmp
curl -LO "https://github.com/grafana/loki/releases/download/v${LOKI_VERSION}/loki-linux-amd64.zip"
sudo apt-get install -y unzip
unzip loki-linux-amd64.zip
sudo mv loki-linux-amd64 /usr/local/bin/loki
sudo chmod +x /usr/local/bin/loki

sudo useradd --no-create-home --shell /usr/sbin/nologin loki
sudo chown -R loki:loki /var/lib/loki /etc/loki
```

Config file (single-binary, filesystem storage — fine for a single-node setup; revisit if you outgrow it):

```bash
sudo tee /etc/loki/loki-config.yml > /dev/null <<'EOF'
auth_enabled: false

server:
  http_listen_port: 3100

common:
  path_prefix: /var/lib/loki
  storage:
    filesystem:
      chunks_directory: /var/lib/loki/chunks
      rules_directory: /var/lib/loki/rules
  replication_factor: 1
  ring:
    kvstore:
      store: inmemory

schema_config:
  configs:
    - from: 2024-01-01
      store: tsdb
      object_store: filesystem
      schema: v13
      index:
        prefix: index_
        period: 24h

limits_config:
  retention_period: 168h
EOF
sudo chown loki:loki /etc/loki/loki-config.yml
```

Systemd unit:

```bash
sudo tee /etc/systemd/system/loki.service > /dev/null <<'EOF'
[Unit]
Description=Loki
Wants=network-online.target
After=network-online.target

[Service]
User=loki
Group=loki
Type=simple
ExecStart=/usr/local/bin/loki -config.file=/etc/loki/loki-config.yml

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now loki
sudo systemctl status loki --no-pager
```

Verify: `curl http://localhost:3100/ready` should return `ready`.

---

## 3. Tempo (traces store)

```bash
TEMPO_VERSION=$(curl -s https://api.github.com/repos/grafana/tempo/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
echo "Installing Tempo $TEMPO_VERSION"

cd /tmp
curl -LO "https://github.com/grafana/tempo/releases/download/v${TEMPO_VERSION}/tempo_${TEMPO_VERSION}_linux_amd64.tar.gz"
tar xzf "tempo_${TEMPO_VERSION}_linux_amd64.tar.gz"
sudo mv tempo /usr/local/bin/tempo
sudo chmod +x /usr/local/bin/tempo

sudo useradd --no-create-home --shell /usr/sbin/nologin tempo
sudo chown -R tempo:tempo /var/lib/tempo /etc/tempo
```

Config file:

```bash
sudo tee /etc/tempo/tempo-config.yml > /dev/null <<'EOF'
server:
  http_listen_port: 3200

distributor:
  receivers:
    otlp:
      protocols:
        grpc:
          endpoint: 0.0.0.0:4327
        http:
          endpoint: 0.0.0.0:4328

storage:
  trace:
    backend: local
    local:
      path: /var/lib/tempo/traces
    wal:
      path: /var/lib/tempo/wal

compactor:
  compaction:
    block_retention: 168h
EOF
sudo chown tempo:tempo /etc/tempo/tempo-config.yml
```

Note the OTLP ports here (4327/4328) are deliberately different from the collector's own OTLP ports (4317/4318) below — the collector receives from your apps on 4317/4318, then forwards to Tempo on 4327/4328, so they can't collide on the same host.

Systemd unit:

```bash
sudo tee /etc/systemd/system/tempo.service > /dev/null <<'EOF'
[Unit]
Description=Tempo
Wants=network-online.target
After=network-online.target

[Service]
User=tempo
Group=tempo
Type=simple
ExecStart=/usr/local/bin/tempo -config.file=/etc/tempo/tempo-config.yml

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now tempo
sudo systemctl status tempo --no-pager
```

Verify: `curl http://localhost:3200/ready` should return `ready`.

---

## 4. OTel Collector (receives from your apps, forwards to all three)

```bash
OTEL_VERSION=$(curl -s https://api.github.com/repos/open-telemetry/opentelemetry-collector-releases/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
echo "Installing OTel Collector (contrib) $OTEL_VERSION"

cd /tmp
curl -LO "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v${OTEL_VERSION}/otelcol-contrib_${OTEL_VERSION}_linux_amd64.tar.gz"
tar xzf "otelcol-contrib_${OTEL_VERSION}_linux_amd64.tar.gz"
sudo mv otelcol-contrib /usr/local/bin/otelcol
sudo chmod +x /usr/local/bin/otelcol

sudo useradd --no-create-home --shell /usr/sbin/nologin otelcol
sudo chown -R otelcol:otelcol /etc/otelcol
```

We're using the **contrib** distribution specifically because it includes the Prometheus remote-write exporter and the Loki exporter — the core distribution doesn't ship those.

Config file:

```bash
sudo tee /etc/otelcol/config.yml > /dev/null <<'EOF'
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318

processors:
  batch:
    timeout: 5s
    send_batch_size: 1000

exporters:
  # Traces -> Tempo
  otlp/tempo:
    endpoint: localhost:4327
    tls:
      insecure: true

  # Metrics -> Prometheus, via remote-write
  prometheusremotewrite:
    endpoint: http://localhost:9090/api/v1/write

  # Logs -> Loki
  loki:
    endpoint: http://localhost:3100/loki/api/v1/push

service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlp/tempo]
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [prometheusremotewrite]
    logs:
      receivers: [otlp]
      processors: [batch]
      exporters: [loki]
EOF
sudo chown otelcol:otelcol /etc/otelcol/config.yml
```

Systemd unit:

```bash
sudo tee /etc/systemd/system/otelcol.service > /dev/null <<'EOF'
[Unit]
Description=OpenTelemetry Collector
Wants=network-online.target
After=network-online.target prometheus.service loki.service tempo.service

[Service]
User=otelcol
Group=otelcol
Type=simple
ExecStart=/usr/local/bin/otelcol --config=/etc/otelcol/config.yml

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now otelcol
sudo systemctl status otelcol --no-pager
```

Verify: `curl http://localhost:4318/v1/traces -X POST -H "Content-Type: application/json" -d '{}'` should return a `400` (proves the endpoint is listening and parsing, an empty body is just invalid input) rather than a connection error.

---

## 5. Grafana OSS

Install via the official APT repository so you get updates through normal `apt upgrade` rather than manually re-downloading tarballs:

```bash
sudo apt-get install -y apt-transport-https software-properties-common wget
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etcsudo mkdir -p /etc/apt/keyrings/
/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

sudo apt-get update
sudo apt-get install -y grafana

sudo systemctl enable --now grafana-server
sudo systemctl status grafana-server --no-pager
```

Verify: `curl http://localhost:3000/api/health` should return `{"database": "ok", ...}`.

Grafana's web UI is now at `http://<your-server-ip>:3000` — default login is `admin` / `admin`, and it'll force a password change on first login.

---

## 6. Wire up Grafana's data sources

Rather than clicking through the UI, provision them as config so they survive a reinstall:

```bash
sudo mkdir -p /etc/grafana/provisioning/datasources
sudo tee /etc/grafana/provisioning/datasources/datasources.yml > /dev/null <<'EOF'
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://localhost:9090
    isDefault: true

  - name: Loki
    type: loki
    access: proxy
    url: http://localhost:3100

  - name: Tempo
    type: tempo
    access: proxy
    url: http://localhost:3200
EOF

sudo systemctl restart grafana-server
```

Log into Grafana, go to **Connections → Data sources**, and confirm all three show a green "Data source is working" test result.

---

## 7. Point your NestJS/Node services at the collector

In each service, the OTel SDK's OTLP exporter endpoint is the collector's address, not Prometheus/Loki/Tempo directly — the collector is the single thing your apps talk to:

```bash
# Environment variable every service reads in its telemetry bootstrap
OTEL_EXPORTER_OTLP_ENDPOINT=http://<collector-host>:4318
OTEL_SERVICE_NAME=ingestion-api   # unique per service
```

If the collector runs on the same host as the app during early development, `localhost:4318` works; once services are on separate machines, use the collector host's actual address (and make sure your firewall/security group allows 4317/4318 inbound from your app hosts specifically, not the public internet).

---

## Sanity check the whole pipeline

1. Start any one of your Nest services with the OTel SDK wired up and the env vars above set.
2. Trigger a request that generates a trace, a log line, and a metric increment.
3. In Grafana: **Explore → Tempo**, search for your service name — you should see the trace.
4. **Explore → Loki**, query `{service_name="ingestion-api"}` — you should see the log line, ideally with the trace ID attached so you can jump between them.
5. **Explore → Prometheus**, query anything your app exports — you should see the metric.

If any of these come back empty, check `journalctl -u otelcol -f` first — the collector's own logs will usually show whether it received the data and whether the export to the backend succeeded or errored.

---

## Firewall note

None of these services should be reachable from the public internet except Grafana's UI (and even that ideally behind a reverse proxy with TLS and auth, not exposed directly on 3000). Lock down 4317/4318 (collector), 9090 (Prometheus), 3100 (Loki), and 3200/4327/4328 (Tempo) to only your application hosts, using `ufw` or your cloud provider's security groups.