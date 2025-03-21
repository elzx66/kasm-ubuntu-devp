# 使用 linuxserver/wps-office:11.1.0 作为基础镜像
FROM linuxserver/wps-office:11.1.0

# 设置环境变量
ENV PYCHARM_VERSION=2024.1.1
ENV PYCHARM_URL=https://download.jetbrains.com/python/pycharm-community-$PYCHARM_VERSION.tar.gz
ENV PYCHARM_HOME=/opt/pycharm

# 安装必要的依赖
RUN apt-get update && apt-get install -y \
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

# 设置工作目录
WORKDIR /config

# 暴露端口（如果 PyCharm 需要）
EXPOSE 8080

# 启动 PyCharm
CMD ["start-pycharm"]
