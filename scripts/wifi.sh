#!/bin/bash

STATE_FILE="$HOME/.cache/waybar_wifi_state"
STATE=$(cat "$STATE_FILE" 2>/dev/null || echo "ssid")

get_ssid() {
  nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2
}

get_iface() {
  nmcli -t -f DEVICE,TYPE,STATE dev | grep ':wifi:connected' | cut -d: -f1
}

if [[ "$1" == "toggle" ]]; then
  if [[ "$STATE" == "ssid" ]]; then
    echo "iface" > "$STATE_FILE"
  else
    echo "ssid" > "$STATE_FILE"
  fi
  exit 0
fi

STATE=$(cat "$STATE_FILE" 2>/dev/null || echo "ssid")

if [[ "$STATE" == "ssid" ]]; then
  SSID=$(get_ssid)
  if [[ -z "$SSID" ]]; then
    echo "睊 offline"
  else
    echo " $SSID"
  fi
else
  IFACE=$(get_iface)
  echo " $IFACE"
fi
