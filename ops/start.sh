#!/bin/bash

cd $(dirname $0)/../docker

echo "[$(date)] Starting WMS services..."

docker-compose up -d

echo "[$(date)] Waiting for services to be ready..."
sleep 15

echo "[$(date)] Checking service status..."
docker-compose ps

echo "[$(date)] WMS services started successfully!"
