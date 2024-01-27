# 使用 Ubuntu 最新版作为基础镜像
FROM ubuntu:latest

# 安装必要的软件包和依赖项
RUN apt-get update && apt-get install libnice-dev -y \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# 将当前目录下的 libssl1.1 Debian 包复制到容器中
COPY libssl1.1_1.1.1f-1ubuntu2.17_amd64.deb /tmp/

# 安装复制进来的 libssl 包
RUN dpkg -i /tmp/libssl1.1_1.1.1f-1ubuntu2.17_amd64.deb || apt-get install -f -y

# 清理临时文件
RUN rm /tmp/libssl1.1_1.1.1f-1ubuntu2.17_amd64.deb

# 安装 mumble-web-proxy，可能需要从源代码编译或者安装预编译的二进制文件
# 这里假设有一个 mumble-web-proxy 的可执行文件在当前目录下
# 如果不是这样，您需要修改这一部分以正确安装 mumble-web-proxy
COPY mumble-web-proxy /usr/local/bin/

# 暴露 mumble-web-proxy 使用的 WebSocket 端口
EXPOSE 64737

# 设置环境变量默认值
ENV ICE_IPV4=0.0.0.0

# 当容器启动时运行 mumble-web-proxy
CMD ["sh", "-c", "mumble-web-proxy --listen-ws 64737 --server localhost:64738 --ice-port-min 20000 --ice-port-max 21000 --ice-ipv4 ${ICE_IPV4} --accept-invalid-certificate"]
