#!/bin/sh
set -e

# 如果指定了 volume 挂载路径，则复制文件到 volume
if [ -d "/assets" ]; then
    echo "Copying files to /assets volume..."
    cp -r /usr/share/nginx/html/* /assets/ || echo "Warning: Failed to copy files"
    echo "Files copied successfully"
fi

# 执行原始命令或启动 nginx
exec "$@"
