FROM node:alpine3.20

# 1. 设置工作目录到非 root 用户有权访问的地方
WORKDIR /home/choreo/app

# 2. 复制项目文件
COPY . .

# 3. 安装依赖（并在同一层处理权限）
# Choreo 容器要求非 root 用户，这里我们使用 UID 10001
RUN apk update && apk upgrade && \
    apk add --no-cache openssl curl gcompat iproute2 coreutils bash && \
    npm install && \
    # 关键步骤：确保 10001 用户拥有该目录的所有权
    addgroup -g 10001 choreo && \
    adduser -u 10001 -G choreo -s /bin/sh -D choreo && \
    chown -R 10001:10001 /home/choreo/app

# 4. 切换到非 root 用户（Choreo 强制要求）
USER 10001

# 5. 暴露端口
EXPOSE 3000

# 6. 启动命令
CMD ["node", "index.js"]
