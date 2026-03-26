#!/bin/bash

cd $(dirname $0)/../docker

DEPLOY_ENV=$1

if [ -z "$DEPLOY_ENV" ]; then
    echo "Usage: $0 <blue|green>"
    exit 1
fi

CURRENT_ENV=""
NEW_ENV=""

if [ "$DEPLOY_ENV" = "blue" ]; then
    CURRENT_ENV="green"
    NEW_ENV="blue"
else
    CURRENT_ENV="blue"
    NEW_ENV="green"
fi

echo "[$(date)] Starting blue-green deployment: deploying to $NEW_ENV"

echo "[$(date)] Starting $NEW_ENV environment..."
docker-compose up -d backend-$NEW_ENV

echo "[$(date)] Waiting for $NEW_ENV to be ready..."
sleep 30

echo "[$(date)] Checking $NEW_ENV health..."
if docker-compose ps | grep "backend-$NEW_ENV" | grep -q "Up"; then
    echo "[$(date)] $NEW_ENV is healthy, reloading nginx..."

    echo "[$(date)] Reloading Nginx configuration..."
    docker exec wms_nginx nginx -s reload

    echo "[$(date)] Traffic switch step completed (nginx reload issued)"

    echo "[$(date)] Stopping $CURRENT_ENV environment..."
    docker-compose stop backend-$CURRENT_ENV

    echo "[$(date)] Blue-green deployment completed successfully!"
else
    echo "[$(date)] $NEW_ENV is not healthy, rolling back..."
    docker-compose stop backend-$NEW_ENV
    echo "[$(date)] Rollback completed!"
    exit 1
fi
