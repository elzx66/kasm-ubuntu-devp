# 使用 kasmweb/core-debian-bookworm 作为基础镜像
FROM kasmweb/core-debian-bookworm:1.13.0

# 设置环境变量
ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

# 安装必要的依赖
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

# 下载并安装 PyCharm 社区版
RUN wget -O pycharm.tar.gz "https://download.jetbrains.com/python/pycharm-community-2024.2.2.tar.gz" \
    && tar -xzf pycharm.tar.gz -C /opt \
    && rm pycharm.tar.gz

# 创建 PyCharm 快捷方式到桌面
RUN mkdir -p $HOME/Desktop
RUN echo "[Desktop Entry]\nName=PyCharm Community Edition\nComment=Python IDE\nExec=/opt/pycharm-community-2024.2.2/bin/pycharm.sh\nIcon=/opt/pycharm-community-2024.2.2/bin/pycharm.svg\nTerminal=false\nType=Application\nCategories=Development;" > $HOME/Desktop/pycharm.desktop
RUN chmod +x $HOME/Desktop/pycharm.desktop

# 设置 PyCharm 快捷方式
RUN ln -s /opt/pycharm-community-2024.2.2/bin/pycharm.sh /usr/local/bin/pycharm

# 清理
RUN apt-get clean

# 复制配置文件
COPY kasm_user $HOME
RUN chown -R 1000:0 $HOME

# 设置权限
RUN $STARTUPDIR/set_user_permission.sh $HOME

# 暴露端口（如果需要）
EXPOSE 8080

# 启动命令
CMD ["/usr/local/bin/pycharm"]
