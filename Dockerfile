FROM tensorflow/tensorflow:latest-gpu-py3

# Essential stuff to run t2t.
RUN apt-get update && \
    apt-get install -y ffmpeg libsm6 libxext6 libxrender1 libfontconfig1 \
                       freeglut3-dev openssh-server
# Install t2t from pip just to get dependencies, then uninstall (will be
# installed later in develop mode).
RUN pip install tensor2tensor gym[atari] pygame && \
    pip uninstall -y tensor2tensor

# OpenSSH stuff.
RUN mkdir /var/run/sshd

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' \
        /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login.
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' \
        -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22

# User environment.
RUN apt-get install -y zsh tmux vim git openssh-client locales
RUN pip install dotfiles ipython ipdb
RUN chsh -s /usr/bin/zsh root
RUN echo "[url \"https://github.com/\"]\n\tinsteadOf = git@github.com:" >> /root/.gitconfig && \
    git clone --recursive https://github.com/koz4k/dotfiles ~/Dotfiles && \
    dotfiles --sync
RUN locale-gen en_US.UTF-8

# Add CUDA to LD_LIBRARY_PATH. Idk why this is necessary.
RUN echo "export LD_LIBRARY_PATH=/usr/local/nvidia/lib64" >> ~/.zshrc && \
    echo "export LD_LIBRARY_PATH=/usr/local/nvidia/lib64" >> ~/.bashrc

# Install t2t from mounted volume in develop mode. This is possible only after
# starting the container.
ENTRYPOINT echo "root:$PASSWORD" | chpasswd && cd /t2t && python setup.py develop && /usr/sbin/sshd -D
