#!/bin/bash
while true
do
  echo "Connecting to Localtunnel..."
  # Use 127.0.0.1 instead of localhost for WSL stability
  npx localtunnel --port 8080 --local-host 127.0.0.1
  echo "Tunnel crashed. Restarting in 3 seconds..."
  sleep 3
done
