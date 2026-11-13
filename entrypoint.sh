#!/bin/sh
set -e
PORT=${PORT:-10000}
if [ -z "$UUID" ]; then
  echo "UUID env var is required" >&2
  exit 1
fi
mkdir -p /etc/xray
cat > /etc/xray/config.json <<INNER_EOF
{
  "log": {"loglevel": "warning"},
  "inbounds": [
    {
      "port": $PORT,
      "protocol": "vless",
      "settings": {
        "clients": [{"id": "$UUID", "level": 0}],
        "decryption": "none"
      },
      "streamSettings": {"network": "ws", "wsSettings": {"path": "/vless"}}
    }
  ],
  "outbounds": [{"protocol": "freedom"}]
}
INNER_EOF
exec /usr/local/bin/xray -config /etc/xray/config.json
