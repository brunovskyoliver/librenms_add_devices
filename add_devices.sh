#!/bin/bash

LIBRENMS_API_URL="https://nms.novem.sk/api/v0/devices"
LIBRENMS_API_TOKEN=""

device_version="v2c"
device_community="uT3VHkP4"

csv_file="hostnames.csv"

while IFS=, read -r hostname
do
  [[ $hostname == "hostname" ]] && continue

  json_data=$(cat <<EOF
{
  "hostname": "$hostname",
  "version": "$device_version",
  "community": "$device_community"
}
EOF
  )

  response=$(curl -s -X POST -d "$json_data" -H "Content-Type: application/json" -H "X-Auth-Token: $LIBRENMS_API_TOKEN" $LIBRENMS_API_URL)

  http_status=$(echo "$response" | jq -r '.status')

  if [ "$http_status" = "ok" ]; then
    echo "pridane '$hostname'"
  else
    echo "'$hostname' error: $response"
  fi
done < "$csv_file"
