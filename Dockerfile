FROM node:alpine3.20

WORKDIR /home/choreo/app
COPY . .

RUN apk update && apk upgrade && \
    apk add --no-cache openssl curl gcompat iproute2 coreutils bash && \
    npm install && \
    addgroup -g 10001 choreo && \
    adduser -u 10001 -G choreo -s /bin/sh -D choreo && \
    # 确保 /tmp 目录对 10001 用户完全可写
    chown -R 10001:10001 /tmp && \
    chmod 1777 /tmp

USER 10001
EXPOSE 3000
CMD ["node", "index.js"]
