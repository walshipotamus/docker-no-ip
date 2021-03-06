#!/bin/bash

GENERATED_CONFIG_FILE=/config/no-ip2.generated.conf

#-----------------------------------------------------------------------------------------------------------------------

function ts {
  echo [`date '+%b %d %X'`]
}

#-----------------------------------------------------------------------------------------------------------------------

if [ ! -f "$GENERATED_CONFIG_FILE" ]; then
  echo "Generated config file not found, proceeding to generate new config"
  /files/parse_config_file.sh
fi

while true
do
  echo "$(ts) Launching the noip2 daemon"
  /usr/local/bin/noip2 -c "$GENERATED_CONFIG_FILE"

  # Give it a few seconds to do the first update. This helps avoid questions about "Last IP Address set 0.0.0.0"
  sleep 5

  while true
  do
    output=$(/usr/local/bin/noip2 -c "$GENERATED_CONFIG_FILE" -S 2>&1)

    echo "$(ts) Current status"
    echo "$output"

    if [[ "$output" != *"started as"* ]]; then
      echo "$(ts) ERROR: noip2 daemon has stopped running. Restarting it in 60 seconds."
      sleep 60
      break
    fi

    sleep 60
  done
done
