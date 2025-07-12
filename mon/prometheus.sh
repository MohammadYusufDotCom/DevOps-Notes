#!/bin/bash

wget https://github.com/prometheus/prometheus/releases/download/v2.53.5/prometheus-2.53.5.linux-amd64.tar.gz
tar -xvzf prometheus-2.53.5.linux-amd64.tar.gz
mv prometheus-2.53.5.linux-amd64 prometheus

mkdir /var/lib/prometheus

mv prometheus/prometheus /usr/local/bin/
chmod 740 /usr/local/bin/prometheus 
mv prometheus /etc/prometheus 

cat <<EOF | sudo tee /usr/lib/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecReload=/bin/kill -HUP 
ExecStart=/usr/local/bin/prometheus  \
--config.file=/etc/prometheus/prometheus.yml \
--storage.tsdb.path=/var/lib/prometheus  \
--storage.tsdb.retention.time=7d \
--storage.tsdb.retention.size=10GB \
--web.console.templates=/etc/prometheus/consoles  \
--web.console.libraries=/etc/prometheus/console_libraries \
--web.listen-address=0.0.0.0:7072   \
--web.external-url=  \
--web.enable-lifecycle   \
--web.enable-admin-api \
--web.config.file=/etc/prometheus/web.yml

SyslogIdentifier=prometheus
Restart=always

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload; systemctl restart prometheus; systemctl enable prometheus; systemctl status prometheus;
