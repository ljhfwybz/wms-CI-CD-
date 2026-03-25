#!/bin/bash

cd $(dirname $0)/../docker

echo "[$(date)] Stopping WMS services..."

docker-compose down

echo "[$(date)] WMS services stopped!"
