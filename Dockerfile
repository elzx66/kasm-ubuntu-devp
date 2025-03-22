# 使用 linuxserver/wps-office:chinese-version-2025-03-21 作为基础镜像
FROM linuxserver/wps-office:chinese-version-2025-03-21

# USER root

# 设置环境变量
ENV PYCHARM_VERSION=2024.1.1
ENV PYCHARM_URL=https://download.jetbrains.com/python/pycharm-community-$PYCHARM_VERSION.tar.gz
ENV PYCHARM_HOME=/opt/pycharm

# 安装必要的依赖
RUN apt-get update || true && apt-get install -y --no-install-recommends \
    wget \
    tar \
    && rm -rf /var/lib/apt/lists/*

# 下载并解压 PyCharm 社区版
RUN wget -O pycharm.tar.gz $PYCHARM_URL && \
    mkdir -p $PYCHARM_HOME && \
    tar -xzf pycharm.tar.gz --strip-components=1 -C $PYCHARM_HOME && \
    rm pycharm.tar.gz

# 创建 PyCharm 设置的永久化文件夹
RUN mkdir -p /config/pycharm

# 添加启动 PyCharm 的脚本
RUN echo "#!/bin/bash" > /usr/local/bin/start-pycharm && \
    echo "$PYCHARM_HOME/bin/pycharm.sh -Didea.config.path=/config/pycharm/config -Didea.system.path=/config/pycharm/system" >> /usr/local/bin/start-pycharm && \
    chmod +x /usr/local/bin/start-pycharm

# 创建桌面快捷方式
RUN echo "[Desktop Entry]" > /usr/share/applications/pycharm.desktop && \
    echo "Name=PyCharm Community Edition" >> /usr/share/applications/pycharm.desktop && \
    echo "Comment=Python IDE" >> /usr/share/applications/pycharm.desktop && \
    echo "Exec=/usr/local/bin/start-pycharm" >> /usr/share/applications/pycharm.desktop && \
    echo "Icon=$PYCHARM_HOME/bin/pycharm.svg" >> /usr/share/applications/pycharm.desktop && \
    echo "Terminal=false" >> /usr/share/applications/pycharm.desktop && \
    echo "Type=Application" >> /usr/share/applications/pycharm.desktop && \
    echo "Categories=Development;IDE;" >> /usr/share/applications/pycharm.desktop

# 在 Xfce 任务栏添加 PyCharm 快捷方式
RUN mkdir -p /config/.config/xfce4/panel/launcher-1 && \
    ln -s /usr/share/applications/pycharm.desktop /config/.config/xfce4/panel/launcher-1/pycharm.desktop

# 设置工作目录
WORKDIR /config

USER kasm-user
