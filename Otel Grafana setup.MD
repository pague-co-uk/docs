# Setting up OTel Collector + Grafana OSS (no Docker)

Assumes Ubuntu/Debian with systemd and sudo access. You already have MySQL, Redis, and RabbitMQ running — this adds four new services: Prometheus (metrics store), Loki (logs store), Tempo (traces store), the OTel Collector (receives from your apps, fans out to the three stores above), and Grafana itself (dashboards over all three).

Run everything as your normal sudo user; each service gets its own dedicated system user for security, following the same pattern as MySQL/Redis running under their own accounts rather than root.

This version incorporates the fixes found while actually standing this up: a Loki config typo, a Tempo config regression, a Tempo/Loki port collision, a missing hardcoded directory Tempo needs, a deprecated collector exporter, and a corrupted APT source line. Each fix is called out inline so it's clear why the config looks the way it does, not just what to type.

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

# The OTel Collector pushes metrics here via remote-write,
# so no scrape_configs are needed for your app services directly.
EOF
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml
```

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

**Verify:** `curl http://localhost:9090/-/healthy` → `Prometheus Server is Healthy.`

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

Config file. Note `allow_structured_metadata: true` under `limits_config` — this is required because we're sending logs to Loki via its **native OTLP endpoint** (see the collector section below), and OTLP log attributes land as structured metadata, not plain labels:

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
  allow_structured_metadata: true
EOF
sudo chown loki:loki /etc/loki/loki-config.yml
```

> **Careful when pasting this block manually.** A one-character typo here (`auth_enabled` → `uth_enabled`) is exactly what caused Loki to fail on first boot during setup — the error was `field uth_enabled not found in type loki.ConfigWrapper`. If Loki fails to start, `sudo journalctl -u loki -n 50` will show this kind of error immediately; check the YAML character-for-character against this block rather than assuming the structure is wrong.

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

**Verify:** `curl http://localhost:3100/ready` → `ready`.

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

**Important — a hardcoded path Tempo needs regardless of your config.** Some Tempo modules (`live-store` in recent versions) write a shutdown-marker file to a hardcoded default path, `/var/tempo`, completely separate from whatever you set under `storage.trace.local.path`. Create and own it now or Tempo will fail with `mkdir /var/tempo: permission denied`:

```bash
sudo mkdir -p /var/tempo
sudo chown -R tempo:tempo /var/tempo
```

Config file. **Two things removed/changed from what you'd get by following Tempo's own docs literally, both found by testing against Tempo 3.0.2:**

1. **No top-level `compactor:` block.** As of this Tempo release there's an open upstream regression ([grafana/tempo#6384](https://github.com/grafana/tempo/issues/6384)) where a documented, previously-working top-level `compactor:` config gets rejected with `field compactor not found in type app.Config`. Omit it and let Tempo use its defaults until upstream fixes this — you lose explicit retention/compaction tuning for now, not core functionality.
2. **Explicit `grpc_listen_port: 9096`.** Tempo's default internal gRPC port is `9095` — which collides with Loki, which also defaults to `9095`. Pin Tempo to a different port rather than leaving it on the default.

```bash
sudo tee /etc/tempo/tempo-config.yml > /dev/null <<'EOF'
server:
  http_listen_port: 3200
  grpc_listen_port: 9096

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
EOF
sudo chown tempo:tempo /etc/tempo/tempo-config.yml
```

The OTLP ports here (4327/4328) are deliberately different from the collector's own OTLP ports (4317/4318) below — the collector receives from your apps on 4317/4318, then forwards to Tempo on 4327/4328, so they can't collide on the same host.

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

**Verify:** `curl http://localhost:3200/ready` → `ready`.

If it still fails, `sudo journalctl -u tempo -n 100 --no-pager` and check specifically for `level=error` lines — with this version, module startup failures can cascade (one failed module causes several dependent ones to report failed/stopping too), so the first `level=error` line is usually the real root cause and the rest are downstream noise.

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

We use the **contrib** distribution because it includes the Prometheus remote-write exporter — the core distribution doesn't ship it.

**Important — the dedicated `loki` exporter is deprecated and no longer available.** It's been removed in favor of sending logs to Loki's own native OTLP ingestion endpoint (added in Loki 3.0+), using the standard `otlp_http` exporter pointed at Loki's `/otlp` path instead of a Loki-specific component. This is also genuinely the currently-recommended approach, not just a workaround.

Config file (using the current, non-deprecated component names — `otlp_grpc`, `otlp_http`, `prometheus_remote_write` rather than their older aliases, which the collector will warn about but still accept):

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
  otlp_grpc/tempo:
    endpoint: localhost:4327
    tls:
      insecure: true

  prometheus_remote_write:
    endpoint: http://localhost:9090/api/v1/write

  otlp_http/loki:
    endpoint: http://localhost:3100/otlp
    tls:
      insecure: true

service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlp_grpc/tempo]
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [prometheus_remote_write]
    logs:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlp_http/loki]
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

**Verify:** `curl -X POST http://localhost:4318/v1/traces -H "Content-Type: application/json" -d '{}'` → `{"partialSuccess":{}}` (an empty-but-valid OTLP payload is accepted with nothing to report; a connection error means the collector isn't listening, and `journalctl -u otelcol` will show why).

---

## 5. Grafana OSS

```bash
sudo apt-get install -y apt-transport-https software-properties-common wget
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
```

Add the APT source. **Write this as a single, complete `echo` line** — if it's split across multiple lines or another command gets pasted in the middle, APT will reject the resulting file with `Malformed entry ... ([option] not assignment)`. Confirm the file's contents afterward before moving on:

```bash
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
cat /etc/apt/sources.list.d/grafana.list
```

That should print exactly:
```
deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main
```

Also worth a quick sanity check that the GPG key actually downloaded (a network hiccup here silently produces an empty or HTML file instead of key data):

```bash
file /etc/apt/keyrings/grafana.gpg
```

Then install:

```bash
sudo apt-get update
sudo apt-get install -y grafana

sudo systemctl enable --now grafana-server
sudo systemctl status grafana-server --no-pager
```

**Verify:** `curl http://localhost:3000/api/health` → `{"database": "ok", ...}`.

Grafana's web UI is now at `http://<your-server-ip>:3000` — default login is `admin` / `admin`, forced password change on first login.

---

## 6. Wire up Grafana's data sources

Provisioned as config rather than clicked through the UI, so they survive a reinstall:

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

```bash
# Environment variables every service reads in its telemetry bootstrap
OTEL_EXPORTER_OTLP_ENDPOINT=http://<collector-host>:4318
OTEL_SERVICE_NAME=ingestion-api   # unique per service
```

`localhost:4318` works if the collector runs on the same host as the app during early development; once services move to separate machines, use the collector host's actual address, and restrict inbound access on 4317/4318 to your app hosts specifically.

---

## Sanity check the whole pipeline

1. Start any one Nest service with the OTel SDK wired up and the env vars above set.
2. Trigger a request that generates a trace, a log line, and a metric increment.
3. Grafana **Explore → Tempo**, search by service name — trace should appear.
4. Grafana **Explore → Loki**, query `{service_name="ingestion-api"}` — log line should appear, ideally with a trace ID attached.
5. Grafana **Explore → Prometheus**, query anything your app exports — metric should appear.

If any of these come back empty, check `journalctl -u otelcol -f` first — it'll usually show whether the collector received the data and whether the export downstream succeeded or errored.

---

## CentOS / RHEL variant

Everything above targets Ubuntu/Debian. The Prometheus, Loki, Tempo, and OTel Collector steps are **unchanged on CentOS/RHEL** — they're direct binary/tarball downloads from GitHub releases, not distro packages, and the systemd units are identical across distros. Only Grafana's install method, prerequisite package installs, firewalling, and one SELinux consideration differ. This section covers just those differences; follow the rest of the guide as written.

### Prerequisite packages

Anywhere the main guide says `apt-get install -y <package>`, use `dnf` instead (or `yum` on CentOS 7):

```bash
sudo dnf install -y wget gnupg2 unzip
```

### Grafana OSS via the RPM repo

Replace all of Section 5 with:

```bash
sudo tee /etc/yum.repos.d/grafana.repo > /dev/null <<'EOF'
[grafana]
name=grafana
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF

sudo dnf install -y grafana
sudo systemctl enable --now grafana-server
sudo systemctl status grafana-server --no-pager
```

**Verify:** `curl http://localhost:3000/api/health` → `{"database": "ok", ...}`, same as the Ubuntu path.

Section 6 (data source provisioning) and Section 7 (pointing your services at the collector) are unchanged — same file paths, same config.

### SELinux — the one CentOS-specific failure mode to watch for

If SELinux is enforcing (`getenforce`), it can silently block a service even when Unix file permissions (`chown`) are correct — this is the most likely new failure mode you'll hit on CentOS that doesn't exist on Ubuntu. It's especially worth checking on:

- **Tempo's `/var/tempo` directory** — a hardcoded path outside the ones this guide explicitly sets ownership on, and non-standard paths are exactly what SELinux tends to flag.
- **Any binary running from `/usr/local/bin`** — some SELinux policies restrict execution from non-package-managed locations.

If a service fails to start and `journalctl -u <service>` shows nothing useful (permission-denied-shaped errors with no clear cause, similar to the `mkdir /var/tempo: permission denied` error found while building this guide, but happening even after `chown` is confirmed correct), check for SELinux denials specifically:

```bash
sudo ausearch -m avc -ts recent
```

If that shows denials, either add a proper policy exception (`audit2allow` can generate one from the denial log), or, for a quick unblock while testing, temporarily set permissive mode:

```bash
sudo setenforce 0
```

Don't leave it in permissive mode in production — this is a diagnostic step, not a fix. Once you know SELinux is the actual blocker, write a targeted policy exception rather than disabling enforcement.

### Firewall — `firewalld` instead of `ufw`

```bash
sudo firewall-cmd --permanent --add-port=4317/tcp --add-port=4318/tcp   # OTel Collector
sudo firewall-cmd --permanent --add-port=9090/tcp                       # Prometheus
sudo firewall-cmd --permanent --add-port=3100/tcp                       # Loki
sudo firewall-cmd --permanent --add-port=3200/tcp --add-port=4327/tcp --add-port=4328/tcp --add-port=9096/tcp  # Tempo
sudo firewall-cmd --reload
```

As with the Ubuntu/`ufw` version, this opens the ports broadly — for production, scope these to your application hosts' source IPs using a rich rule instead of a plain port, e.g.:

```bash
sudo firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="<app-host-ip>/32" port protocol="tcp" port="4318" accept'
```

repeated per port and per app host, rather than opening the port to the whole zone.

---

## Firewall note

None of these services should be reachable from the public internet except Grafana's UI (and even that ideally sits behind a reverse proxy with TLS and auth, not exposed directly on 3000). Lock down the following to only your application hosts, via `ufw` or your cloud provider's security groups:

- **4317 / 4318** — OTel Collector (receives from apps)
- **9090** — Prometheus
- **3100** — Loki
- **3200 / 4327 / 4328 / 9096** — Tempo (HTTP, OTLP grpc/http, and its internal gRPC port)
