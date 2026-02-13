FROM moby/buildkit:latest

RUN apk add --no-cache ca-certificates

# 复制证书到系统信任目录
# BuildKit 的 Alpine 系统是 /usr/local/share/ca- 是 Alpine
COPY .github/buildkit/ca.crt /usr/local/share/ca-certificates/ca.crt

# 更新系统证书信任库
RUN update-ca-certificates