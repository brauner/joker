FROM ubuntu:latest

MAINTAINER Christian Brauner christianvanbrauner[at]gmail.com

# Update repos
RUN apt-get update -qq && apt-get install -y \
    software-properties-common \
    && apt-get install -y --no-install-recommends \
# Some basic tools
    mupdf \
    vim \
# Julia dependencies and other useful packages
    bash-completion \
    bison \
    curl \
    debhelper \
    gcc \
    g++ \
    gfortran \
    git \
    m4 \
    python \
    wget \
# 3D support through /dev/dri. Note that this will not happen
# automatically. You will need to add the devices in /dev/dri when you run
# your container.
    mesa-utils \
# put appropriate dirver for your distribution here:
    i965-va-driver \
    libegl1-mesa \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libopenvg1-mesa

# Download julia from Github
RUN cd /tmp && git clone git://github.com/JuliaLang/julia.git \
# Use specific Julia version by following specific release
# && cd /tmp/julia && git checkout release-0.3 \
# # Use specific Julia version by using a specific tag
# RUN cd /tmp/julia && cd julia && git checkout v0.3.0-rc4
# Compile julia from source
# Set MARCH flag to your needs as it will be passed to ./configure and the
# JULIA_CPU_TARGET flag wich determines options for the JIT. If you fail
# to do so you might not be able to run Julia on your system.
    && cd /tmp/julia && printf "prefix=/usr/local\n\nMARCH=core-avx-i\n" > Make.user \
    && cd /tmp/julia && make && make install

# Add user so that no root-login is required; change username and password
# accordingly
RUN echo "root:test" | chpasswd \
    && useradd -m chbj \
    && echo "chbj:test" | chpasswd \
    && usermod -s /bin/bash chbj \
    && usermod -aG sudo chbj \
# On my system the gid of group video is 91. I need to change gid of group
# video on ubuntun in order to allow access to video devices then I add
# them to the container.
    && groupmod -g 91 video \
    && usermod -aG video chbj \
    && locale-gen en_IE.UTF-8 \
# set vim as default editor; vi-editing mode for bash
    && cd && printf "# If not running interactively, don't do anything\n[[ \$- != *i* ]] && return\n\nalias ls='ls --color=auto'\n\nalias grep='grep --color=auto'\n\nPS1='[\u@\h \W]\\$ '\n\ncomplete -cf sudo\n\n# Set default editor.\nexport EDITOR=vim xterm\n\n# Enable vi editing mode.\nset -o vi" > /home/chbj/.bashrc \
# Set vi-editing mode
    && cd && printf "set editing-mode vi\n\nset keymap vi-command" > /home/chbj/.inputrc
ENV LANG en_IE.UTF-8
ENV HOME /home/chbj
WORKDIR /home/chbj
USER chbj

# Make julia run as default process.
ENTRYPOINT ["/usr/local/bin/julia"]
