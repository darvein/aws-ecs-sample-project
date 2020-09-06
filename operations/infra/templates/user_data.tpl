#!/bin/bash

{
  echo "ECS_CLUSTER=${cluster_name}"
  echo 'ECS_AVAILABLE_LOGGING_DRIVERS=${ecs_logging}'
} >> /etc/ecs/ecs.config

# Install Prometheus node_exporter

VERSION='1.0.0'
USER='prometheus'
APP_NAME='node_exporter'
BIN_PATH=/usr/local/bin/$APP_NAME
DIST_NAME="$APP_NAME-$VERSION.linux-amd64"

useradd --no-create-home --shell /bin/false $USER
cd /tmp/
curl -LO https://github.com/prometheus/node_exporter/releases/download/v$VERSION/$DIST_NAME.tar.gz
tar xzf $DIST_NAME.tar.gz
cp $DIST_NAME/$APP_NAME $BIN_PATH
chown $USER:$USER $BIN_PATH

cat << EOF > /etc/systemd/system/$APP_NAME.service
[Unit]
Description=Prometheus Node Exporter
After=network-online.target

[Service]
User=$USER
Restart=on-failure

ExecStart=/usr/local/bin/node_exporter --no-collector.textfile
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=node_exporter

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start $APP_NAME
systemctl enable $APP_NAME

# Append addition user-data script
${additional_user_data_script}
