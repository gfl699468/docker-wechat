ARG VERSION="latest"
FROM gfl699468/deepin-wine:i386-${VERSION}
LABEL maintainer='Fanglin <fanglin.gu@gmail.com>'


RUN apt-get update && \
    apt-get install -y --no-install-recommends procps deepin.com.wechat && \
    apt-get -y autoremove --purge && apt-get autoclean -y && apt-get clean -y && \
    find /var/lib/apt/lists -type f -delete && \
    find /var/cache -type f -delete && \
    find /var/log -type f -delete && \
    find /usr/share/doc -type f -delete && \
    find /usr/share/man -type f -delete

ENV APP=WeChat \
    AUDIO_GID=63 \
    VIDEO_GID=39 \
    GID=1000 \
    UID=1000 \
    DPI=96

RUN groupadd -o -g $GID wechat && \
    groupmod -o -g $AUDIO_GID audio && \
    groupmod -o -g $VIDEO_GID video && \
    useradd -d "/home/wechat" -m -o -u $UID -g wechat -G audio,video wechat && \
    mkdir /WeChatFiles && \
    chown -R wechat:wechat /WeChatFiles && \
    ln -s "/WeChatFiles" "/home/wechat/WeChat Files" && \
    #sed -i 's/WeChat.exe" &/WeChat.exe"/g' "/opt/deepinwine/tools/run.sh"
    INSERTLINE=$(awk '{if(match($0,/ExtractApp\(\)/)){f=1}else if(match($0,/^}\s?$/)&&f){f=0;print NR-2}}' /opt/deepinwine/tools/run_v2.sh) && \
    sed -i "${INSERTLINE}a\\\\tREGDPI=\$(printf '\"LogPixels\"=dword:%08x' \$DPI)\\n\\tsed -i \"s/\\\\\"LogPixels\\\\\"=.*$/\$REGDPI/g\" \$1/system.reg" /opt/deepinwine/tools/run_v2.sh


VOLUME ["/WeChatFiles"]

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
