#!/bin/bash

REDIS_CONTAINER="wms_redis"
MYSQL_CONTAINER="wms_mysql"
BACKEND_CONTAINER="wms_backend"
FRONTEND_CONTAINER="wms_frontend"
ALERT_EMAIL="admin@example.com"

check_container() {
    local container_name=$1
    local status=$(docker inspect -f '{{.State.Status}}' $container_name 2>/dev/null)

    if [ "$status" = "running" ]; then
        echo "[$(date)] $container_name is running"
        return 0
    else
        echo "[$(date)] $container_name is NOT running!"
        return 1
    fi
}

check_redis() {
    if docker exec $REDIS_CONTAINER redis-cli ping &> /dev/null; then
        echo "[$(date)] Redis is healthy"
        return 0
    else
        echo "[$(date)] Redis is NOT healthy!"
        return 1
    fi
}

check_mysql() {
    if docker exec $MYSQL_CONTAINER mysqladmin ping -hlocalhost -uroot -pljh &> /dev/null; then
        echo "[$(date)] MySQL is healthy"
        return 0
    else
        echo "[$(date)] MySQL is NOT healthy!"
        return 1
    fi
}

check_backend() {
    if curl -s http://localhost:9999/warehouse/captcha/captchaImage &> /dev/null; then
        echo "[$(date)] Backend is healthy"
        return 0
    else
        echo "[$(date)] Backend is NOT healthy!"
        return 1
    fi
}

check_frontend() {
    if curl -s http://localhost:80 &> /dev/null; then
        echo "[$(date)] Frontend is healthy"
        return 0
    else
        echo "[$(date)] Frontend is NOT healthy!"
        return 1
    fi
}

send_alert() {
    local message=$1
    echo "[$(date)] ALERT: $message"
}

echo "[$(date)] Starting health check..."

check_container $REDIS_CONTAINER || send_alert "$REDIS_CONTAINER is down"
check_container $MYSQL_CONTAINER || send_alert "$MYSQL_CONTAINER is down"
check_container $BACKEND_CONTAINER || send_alert "$BACKEND_CONTAINER is down"
check_container $FRONTEND_CONTAINER || send_alert "$FRONTEND_CONTAINER is down"

check_redis || send_alert "Redis health check failed"
check_mysql || send_alert "MySQL health check failed"
check_backend || send_alert "Backend health check failed"
check_frontend || send_alert "Frontend health check failed"

echo "[$(date)] Health check completed!"
