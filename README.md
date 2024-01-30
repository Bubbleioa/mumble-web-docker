# mumble-web-docker

mumble 全平台部署脚本，[mumble](https://www.mumble.info/downloads/) 本身支持 Linux/Windows/MacOS，Android 上也有第三方客户端。

但是作为一款功能单一的软件，web 端无疑是更方便的。

感谢 [mumble-web](https://github.com/Johni0702/mumble-web) 和 [mumble-web-prebuild](https://git.termer.net/termer/mumble-web-prebuilt) 使 web 端的 mumble 成为可能，本仓库就是让 mumble-web 的搭建变得更加简单。


## quick start

> 要求系统已经安装 docker 和 docker-compose
> docker 的安装方法请参考[官方文档](https://docs.docker.com/engine/install/)

```shell
git clone https://github.com/Bubbleioa/mumble-web-docker.git
cd mumble-web-docker
```

或者你也可以下载本仓库的压缩包然后在服务器上解压。

### 配置修改

请根据注释，修改`docker-compose.yaml`，`generate_cert.sh`，`mumble-web.conf`中的配置。

### 安装 nginx

> 如果已经安装过请跳过这一步

```shell
sudo apt update -y
sudo apt install nginx -y 
```

### 生成证书

首先生成自签名证书，如果有域名并且有证书的话，可以跳过这一步。

```shell
./generate_cert.sh
sudo mkdir /etc/nginx/cert
sudo cp mumble-web.crt mumble-web.key /etc/nginx/cert
```

### 配置 mumble

```shell
sudo cp mumble-web.conf /etc/nginx/sites-available/mumble-web
sudo ln -s /etc/nginx/sites-available/mumble-web /etc/nginx/sites-enabled
sudo cp -r mumble-web /usr/share/nginx/

# nginx 配置检查，确保没问题之后重启 nginx
sudo nginx -t 
sudo systemctl restart nginx

mkdir ./mumble-data
sudo chmod 777 mumble-data
sudo docker-compose up -d
```

mumble 的配置文件在 ./mumble-data/mumble_server_config.ini，具体配置请看[官方文档](https://wiki.mumble.info/wiki/Murmur.ini)

## mumble web 用法介绍

目前除了 iOS 都有对应的客户端，除非需要自己编译，均可以[前往官网下载](https://www.mumble.info/downloads/)。

网页端功能基本上就是桌面端的一个子集，可以自行摸索。

比较方便的一个功能是连接预填选项，例如：

https://yoursite/?username=myfrind&channelName=abcd%2Fsub_channel&token=kirakira

我们可以在 url 指定三个参数，username 是名字，channelName 是你频道的路径，比如我们现在是在 Root->abcd->sub_channel,那么就忽略 Root, 直接写成 abcd/sub_channel, 但是斜杠在 url 里面要变成 %2f，token 是你的令牌。