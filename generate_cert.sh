#!/bin/bash
# 检查是否安装了openssl
if ! command -v openssl &> /dev/null
then
    echo "OpenSSL未安装。正在尝试安装OpenSSL。"
    sudo apt-get update && sudo apt-get install -y openssl
    if ! command -v openssl &> /dev/null
    then
        echo "OpenSSL安装失败。请手动安装OpenSSL后再运行此脚本。"
        exit 1
    fi
fi

# 询问用户的IP地址
read -p "请输入您的IP地址或域名（如果有证书请跳过此步骤）: " IP_ADDRESS

# 可选更改，下面的证书的一些信息
COUNTRY="CN"
STATE="YourState"
LOCALITY="YourLocality"
ORGANIZATION="YourOrganization"
ORGANIZATIONAL_UNIT="YourOrganizationalUnit"
COMMON_NAME="$IP_ADDRESS"
EMAIL="YourEmail"

# 生成私钥
openssl genrsa -out mumble-web.key 4096

# 生成自签名证书
openssl req -new -x509 -days 365 -key mumble-web.key -out mumble-web.crt \
    -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGANIZATIONAL_UNIT/CN=$COMMON_NAME/emailAddress=$EMAIL"

# 打印完成消息
echo "自签名证书和私钥已生成。"
