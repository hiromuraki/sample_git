FROM moby/buildkit:buildx-stable-1

RUN apk add --no-cache ca-certificates curl

# 复制证书到系统信任目录
# BuildKit 的 Alpine 系统是 /usr/local/share/ca- 是 Alpine
COPY .github/buildkit/server.crt /usr/local/share/ca-certificates/my-ca.crt

# 更新系统证书信任库
RUN update-ca-certificates
RUN update-ca-trust