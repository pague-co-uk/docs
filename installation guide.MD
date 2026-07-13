# SMS gateway infrastructure — CentOS/RHEL/Rocky installation guide

Covers MySQL, Redis, RabbitMQ, and the full telemetry stack (Prometheus, Loki, Tempo, OTel Collector, Grafana OSS) on CentOS Stream / RHEL / Rocky Linux, no Docker. Assumes version 9 (`el9`) unless noted — swap `el9`/`9` for `el8`/`8` in URLs if you're on an older release, and confirm the exact current package/RPM filenames against each vendor's own download page before running, since these are the kind of details that go stale.

Run everything with `sudo`; each service gets its own dedicated system user.

---

## 1. MySQL

```bash
sudo dnf update -y

# Get the exact current RPM filename from https://dev.mysql.com/downloads/repo/yum/
# before running this — the version number in the filename changes over time.
sudo dnf install -y https://dev.mysql.com/get/mysql80-community-release-el9-x.noarch.rpm

sudo dnf install -y mysql-community-server
sudo systemctl start mysqld
sudo systemctl enable mysqld
sudo systemctl status mysqld

# MySQL generates a temporary root password on first start — grab it here:
sudo grep 'temporary password' /var/log/mysqld.log

sudo mysql_secure_installation
```

`mysql_secure_installation` will prompt you to set a real root password (using the temporary one above to authenticate first), remove anonymous users, disable remote root login, and remove the test database — say yes to all of these for anything beyond a throwaway dev box.

**Firewall (if MySQL needs to be reachable from other hosts, e.g. your control-plane/ingestion API servers):**
```bash
sudo firewall-cmd --permanent --add-port=3306/tcp
sudo firewall-cmd --reload
```
Scope this to your app hosts' source IPs rather than opening broadly — see the firewall section at the end for the rich-rule pattern.

---

## 2. Redis

```bash
sudo dnf install -y dnf-utils
sudo rpm --import https://packages.redis.io/gpg

sudo tee /etc/yum.repos.d/redis.repo > /dev/null <<'EOF'
[redis]
name=Redis
baseurl=https://packages.redis.io/rpm/rhel9
enabled=1
gpgcheck=1
EOF

sudo dnf install -y redis
sudo systemctl enable --now redis
sudo systemctl status redis --no-pager
```

Use `baseurl=https://packages.redis.io/rpm/rhel8` in the repo file instead if you're on RHEL/Rocky 8.

**Verify:** `redis-cli ping` → `PONG`.

Given Redis is doing real work in your architecture (float balance cache, rate-limit counters, SMPP credential cache), it's worth setting a password (`requirepass` in `/etc/redis/redis.conf`) and binding it to a private interface rather than leaving it open, even in early development — this is exactly the kind of service that gets accidentally exposed and scraped if left on defaults.

---

## 3. RabbitMQ

RabbitMQ needs a modern Erlang/OTP release first — the Erlang shipped in standard CentOS/RHEL repos is typically too old. Both come from RabbitMQ's own signed repos.

```bash
# Import the signing keys
sudo rpm --import 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/rabbitmq-release-signing-key.asc'
sudo rpm --import 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-erlang.E495BB49CC4BBE5B.key'
sudo rpm --import 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-server.9F4587F226208342.key'
```

Create the repo file — this is the **el9** configuration (RHEL/Rocky/CentOS Stream 9 and 10):

```bash
sudo tee /etc/yum.repos.d/rabbitmq.repo > /dev/null <<'EOF'
##
## Zero dependency Erlang RPM
##
[modern-erlang]
name=modern-erlang-el9
baseurl=https://yum1.rabbitmq.com/erlang/el/9/$basearch
        https://yum2.rabbitmq.com/erlang/el/9/$basearch
repo_gpgcheck=1
enabled=1
gpgkey=https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-erlang.E495BB49CC4BBE5B.key
gpgcheck=1
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
pkg_gpgcheck=1
autorefresh=1
type=rpm-md

[modern-erlang-noarch]
name=modern-erlang-el9-noarch
baseurl=https://yum1.rabbitmq.com/erlang/el/9/noarch
        https://yum2.rabbitmq.com/erlang/el/9/noarch
repo_gpgcheck=1
enabled=1
gpgkey=https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-erlang.E495BB49CC4BBE5B.key
       https://github.com/rabbitmq/signing-keys/releases/download/3.0/rabbitmq-release-signing-key.asc
gpgcheck=1
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
pkg_gpgcheck=1
autorefresh=1
type=rpm-md

##
## RabbitMQ Server
##
[rabbitmq-el9]
name=rabbitmq-el9
baseurl=https://yum2.rabbitmq.com/rabbitmq/el/9/$basearch
        https://yum1.rabbitmq.com/rabbitmq/el/9/$basearch
repo_gpgcheck=1
enabled=1
gpgkey=https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-server.9F4587F226208342.key
       https://github.com/rabbitmq/signing-keys/releases/download/3.0/rabbitmq-release-signing-key.asc
gpgcheck=1
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
pkg_gpgcheck=1
autorefresh=1
type=rpm-md

[rabbitmq-el9-noarch]
name=rabbitmq-el9-noarch
baseurl=https://yum2.rabbitmq.com/rabbitmq/el/9/noarch
        https://yum1.rabbitmq.com/rabbitmq/el/9/noarch
repo_gpgcheck=1
enabled=1
gpgkey=https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-server.9F4587F226208342.key
       https://github.com/rabbitmq/signing-keys/releases/download/3.0/rabbitmq-release-signing-key.asc
gpgcheck=1
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
pkg_gpgcheck=1
autorefresh=1
type=rpm-md
EOF
```

> If you're on RHEL/Rocky/CentOS Stream **8** instead, replace every `el/9` with `el/8` and `el9` with `el8` in the block above (both in the `baseurl` paths and the `name`/section-header values) — the repo layout is otherwise identical.

Install and start:

```bash
sudo dnf install -y rabbitmq-server erlang
sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server
sudo systemctl status rabbitmq-server --no-pager
```

**Enable the management UI and create a real user** (don't run production traffic through the default `guest` account, which by default can only connect from localhost anyway):

```bash
sudo rabbitmq-plugins enable rabbitmq_management

sudo rabbitmqctl add_user smsgateway 'your-strong-password-here'
sudo rabbitmqctl set_user_tags smsgateway administrator
sudo rabbitmqctl set_permissions -p / smsgateway ".*" ".*" ".*"

sudo systemctl restart rabbitmq-server
```

**Verify:** `sudo rabbitmqctl status` should show `RabbitMQ version` and a running node with no errors.

**Firewall:**
```bash
sudo firewall-cmd --permanent --add-port=5672/tcp   # AMQP
sudo firewall-cmd --permanent --add-port=15672/tcp  # Management UI
sudo firewall-cmd --reload
```

**If it fails to start:** check `journalctl -fu rabbitmq-server` first. The most common cause on a fresh box is an Erlang/RabbitMQ version mismatch — confirm with `erl -version` that Erlang actually installed from the `modern-erlang` repo above rather than falling back to whatever (likely too old) version ships in CentOS's base repos.

---

## 4. Telemetry stack: Prometheus, Loki, Tempo, OTel Collector

These four install identically to the Ubuntu version of this guide — they're direct binary downloads from GitHub releases, not distro packages, so nothing about CentOS changes the install steps, the systemd units, or the config files. The fixes found while standing this up on the earlier Ubuntu box apply here too:

- **Loki** needs `allow_structured_metadata: true` under `limits_config` (required for native OTLP log ingestion).
- **Tempo** (as of 3.0.2): omit the top-level `compactor:` block — there's an open upstream regression ([grafana/tempo#6384](https://github.com/grafana/tempo/issues/6384)) rejecting it; also pin `grpc_listen_port: 9096` explicitly, since Tempo's default (`9095`) collides with Loki's default; and pre-create `/var/tempo` (`sudo mkdir -p /var/tempo && sudo chown -R tempo:tempo /var/tempo`) since a Tempo module writes a shutdown-marker there regardless of your configured storage path.
- **OTel Collector**: use the `-contrib` distribution; the dedicated `loki` exporter is deprecated — use `otlp_http` pointed at Loki's native `/otlp` endpoint instead; and use the current component names (`otlp_grpc`, `otlp_http`, `prometheus_remote_write`) rather than their deprecated aliases.

Run the exact same install commands and config files as the Ubuntu guide for Prometheus, Loki, Tempo, and the OTel Collector — `useradd`, the binary downloads, the systemd unit files, and the YAML configs are all distro-independent. The one CentOS-specific thing to watch for:

**SELinux.** If SELinux is enforcing (`getenforce`), a service binding to a non-standard port or writing to a non-standard path (like Tempo's hardcoded `/var/tempo`) can get silently blocked even when Unix file permissions are correct — and unlike the Ubuntu box, this won't necessarily show up in `journalctl` as a clear error. If any of these four services fails to start with output that doesn't match the errors described above, check:
```bash
sudo ausearch -m avc -ts recent
```
If SELinux denials show up there, either add a targeted policy exception (`audit2allow` can generate one from the denial) or, to quickly rule SELinux in or out while troubleshooting, temporarily set permissive mode:
```bash
sudo setenforce 0
```
Don't leave it in permissive mode for a production box — treat this as a diagnostic step, then write a proper policy once you've confirmed SELinux is actually the cause.

**Package name differences for prerequisites:** anywhere you need `unzip` (for the Loki download) or similar utilities:
```bash
sudo dnf install -y unzip wget gnupg2
```

---

## 5. Grafana OSS

CentOS uses an RPM repo instead of the APT one:

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

**Verify:** `curl http://localhost:3000/api/health` → `{"database": "ok", ...}`.

The data-source provisioning file and everything else in the Grafana section of the Ubuntu guide (config path `/etc/grafana/provisioning/datasources/datasources.yml`, pointing Grafana at Prometheus/Loki/Tempo) is identical — Grafana's own directory structure doesn't change between distros, only how the package got installed.

**Firewall:**
```bash
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --reload
```
Ideally behind a reverse proxy with TLS and auth rather than exposed directly, same recommendation as before.

---

## 6. Point your NestJS/Node services at the collector

No change from the Ubuntu guide:

```bash
OTEL_EXPORTER_OTLP_ENDPOINT=http://<collector-host>:4318
OTEL_SERVICE_NAME=ingestion-api
```

---

## Firewall summary (firewalld)

CentOS/RHEL/Rocky ship `firewalld`, not `ufw`. Open only what needs to be reachable, and scope to your actual app-host IPs rather than the whole internet wherever possible:

```bash
# Open broadly (development / same-network testing)
sudo firewall-cmd --permanent --add-port=3306/tcp   # MySQL
sudo firewall-cmd --permanent --add-port=6379/tcp   # Redis
sudo firewall-cmd --permanent --add-port=5672/tcp   # RabbitMQ AMQP
sudo firewall-cmd --permanent --add-port=15672/tcp  # RabbitMQ management UI
sudo firewall-cmd --permanent --add-port=4317/tcp --add-port=4318/tcp   # OTel Collector
sudo firewall-cmd --permanent --add-port=9090/tcp   # Prometheus
sudo firewall-cmd --permanent --add-port=3100/tcp   # Loki
sudo firewall-cmd --permanent --add-port=3200/tcp --add-port=4327/tcp --add-port=4328/tcp --add-port=9096/tcp  # Tempo
sudo firewall-cmd --permanent --add-port=3000/tcp   # Grafana
sudo firewall-cmd --reload
```

For production, scope each rule to a source instead of opening it globally, e.g.:
```bash
sudo firewall-cmd --permanent --zone=trusted --add-source=<app-host-ip>/32
sudo firewall-cmd --permanent --zone=trusted --add-port=5672/tcp
sudo firewall-cmd --reload
```
Repeat per source IP/subnet that legitimately needs access. None of MySQL, Redis, RabbitMQ, the OTel Collector, Prometheus, Loki, or Tempo should ever be reachable from the public internet — only Grafana's UI is meant to be user-facing, and even that should sit behind a reverse proxy with TLS rather than exposed raw on 3000.