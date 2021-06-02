微信版本：2.6.8

### 准备工作

允许所有用户访问X11服务,运行命令:

```bash
    xhost +
```

## 查看系统audio gid

```bash
  cat /etc/group | grep audio
```

fedora 26 结果：

```bash
audio:x:63:
```

### 更新

进入docker容器：docker exec -it wechat bash
运行以下命令更新深度软件包：

```bash
apt-get update

apt-get install -y deepin.com.wechat

```

### 运行

### docker-compose

```yml
version: '2'
services:
  wechat:
    image: jicki/docker-wechat:20210602
    hostname: wechat    # 可选，用于好看
    container_name: wechat
    ipc: host
    devices:
      - /dev/snd        # 声音设备
    volumes:
      - /tmp/.X11-unix:/tmp/.X11-unix
      - .wechatroot:/WeChatFiles
      - .wechathome:/HostHome # 可选，用于发送文件
    environment:
      DISPLAY: unix$DISPLAY
      QT_IM_MODULE: fcitx
      XMODIFIERS=@im: fcitx
      GTK_IM_MODULE: fcitx
      AUDIO_GID: 29 # 可选 执行 `getent group audio | cut -d: -f3` 命令获取本机 id
      GID: 1000 # 可选 默认1000 主机当前用户 gid 解决挂载目录访问权限问题
      UID: 1000 # 可选 默认1000 主机当前用户 uid 解决挂载目录访问权限问题
      DPI: 128 # 可选 微信显示字体大小 默认96
```

或

```bash
    docker run -d --name wechat --device /dev/snd --ipc="host"\
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v .wechatroot:/WeChatFiles \
    -v .wechathome:/HostHome \
    -e DISPLAY=unix$DISPLAY \
    -e XMODIFIERS=@im=fcitx \
    -e QT_IM_MODULE=fcitx \
    -e GTK_IM_MODULE=fcitx \
    -e AUDIO_GID=`getent group audio | cut -d: -f3` \
    -e GID=`id -g` \
    -e UID=`id -u` \
    -e DPI=128 \
    jicki/docker-wechat:20210602
```
