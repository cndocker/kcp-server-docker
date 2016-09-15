[![](https://images.microbadger.com/badges/version/cndocker/kcp-server.svg)](http://microbadger.com/images/cndocker/kcp-server "Get your own image badge on microbadger.com")[![](https://images.microbadger.com/badges/image/cndocker/kcp-server.svg)](http://microbadger.com/images/cndocker/kcp-server "Get your own version badge on microbadger.com")

# 一、Docker-kcp-server 服务端
##1、介绍
基于Dockerfile文件编译出一个kcp-server服务端的容器镜像。
##2、版本
[cndocker/kcp-server:latest](https://hub.docker.com/r/cndocker/kcp-server/)

[kcptun 20160912](https://github.com/xtaci/kcptun/tree/v20160912)
##3、问题
如何安装Docker

1)官网安装地址
```bash
curl -Lk https://get.docker.com/ | sh
```
2)阿里云安装地址
```bash
curl -sSL http://acs-public-mirror.oss-cn-hangzhou.aliyuncs.com/docker-engine/internet | sh -
```
RHEL、CentOS、Fedora的用户可以使用`setenforce 0`来禁用selinux以达到解决一些问题

如果你已经禁用了selinux并且使用的是最新版的Docker。

当你在issue 提交问题的时候请注意提供一下信息:
- 宿主机的发行版和版本号.
- 使用 `docker version` 命令来给出Docker版本信息.
- 使用 `docker info` 命令来给出进一步信息.
- 提供 `docker run` 命令的详情 (注意打码你的隐私信息).

# 二、安装
##1、基于docker的kcp-server服务端安装方法
直接使用我们在 [Dockerhub](https://hub.docker.com/r/cndocker/kcp-server/) 上通过自动构建生成的镜像是最为推荐的方式

```bash
docker pull cndocker/kcp-server:latest
```
##2、下载镜像导入
从我们的项目中下载docker images后导入，镜像下载地址：
```bash
wget --no-check-certificate https://github.com/cndocker/kcp-server-docker/raw/master/images/docker-kcp-server.tar
```

# 三、使用
##启动命令
```bash
docker run -dti --name=kcp-server \
-p 45678:45678/udp \
-e KCPTUN_LISTEN=45678 \
-e KCPTUN_SOCKS5_PORT=12948 \
-e KCPTUN_KEY=password \
-e KCPTUN_CRYPT=aes \
-e KCPTUN_MODE=fast2 \
-e KCPTUN_MTU=1350 \
-e KCPTUN_SNDWND=1024 \
-e KCPTUN_RCVWND=1024 \
-e KCPTUN_NOCOMP=false \
cndocker/kcp-server:latest
```

##变量说明（区分大小写）
| 变量名 | 默认值  | 描述 |
| :----------------- |:----------:| :----------------------------- |
| KCPTUN_LISTEN      |    45678   | 提供服务的端口，UDP协议           |
| KCPTUN_SOCKS5_PORT |    12948   | socks5透明代理端口，不需要对外开放。|
| KCPTUN_KEY         |  password  | 服务密码                        |
| KCPTUN_CRYPT       |    aes     | 加密方式，可选参数：aes, aes-128, aes-192, salsa20, blowfish, twofish, cast5, 3des, tea, xtea, xor |
| KCPTUN_MODE        |    fast2   | 加速模式，可选参数：fast3, fast2, fast, normal |
| KCPTUN_MTU         |    1350    | MTU值，建议范围：900~1400        |
| KCPTUN_SNDWND      |    1024    | 服务器端发送参数，对应客户端rcvwnd  |
| KCPTUN_RCVWND      |    1024    | 服务器端接收参数，对应客户端sndwnd  |
| KCPTUN_NOCOMP      |    false   | 是否开启压缩，值为false时开启压缩，为true时禁用压缩。 |
###带宽计算方法
    简单的计算带宽方法，以服务器发送带宽为例，其他类似：
    服务器发送带宽=SNDWND*MTU*8/1024/1024=1024*1350*8/1024/1024≈10M
###

