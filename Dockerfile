FROM ubuntu:latest

MAINTAINER Christian Brauner christianvanbrauner[at]gmail.com

# Update repos
RUN apt-get update -qq
# Run full system upgrade
RUN apt-get dist-upgrade -y

RUN apt-get install -y software-properties-common
# Some basic tools
RUN apt-get install -y --no-install-recommends mupdf
RUN apt-get install -y --no-install-recommends vim

# Julia dependencies and other useful packages
RUN apt-get install -y --no-install-recommends bash-completion
RUN apt-get install -y --no-install-recommends bison
RUN apt-get install -y --no-install-recommends curl
RUN apt-get install -y --no-install-recommends debhelper
RUN apt-get install -y --no-install-recommends gcc
RUN apt-get install -y --no-install-recommends g++
RUN apt-get install -y --no-install-recommends gfortran
RUN apt-get install -y --no-install-recommends git
RUN apt-get install -y --no-install-recommends m4
RUN apt-get install -y --no-install-recommends python
RUN apt-get install -y --no-install-recommends wget

# Download julia from Github
RUN cd /tmp && git clone git://github.com/JuliaLang/julia.git
# Compile julia from source
# Set MARCH flag to your needs as it will be passed to ./configure and the
# JULIA_CPU_TARGET flag wich determines options for the JIT. If you fail
# to do so you might not be able to run Julia on your system.
RUN cd /tmp/julia && printf "prefix=/usr/local\n\nMARCH=core-avx-i\n" > Make.user
RUN cd /tmp/julia && make && make install

# 3D support through /dev/dri. Note that this will not happen
# automatically. You will need to add the devices in /dev/dri when you run
# your container.
RUN apt-get install -y --no-install-recommends mesa-utils
# put appropriate dirver for your distribution here:
RUN apt-get install -y --no-install-recommends i965-va-driver
RUN apt-get install -y --no-install-recommends libegl1-mesa
RUN apt-get install -y --no-install-recommends libgl1-mesa-dri
RUN apt-get install -y --no-install-recommends libgl1-mesa-glx
RUN apt-get install -y --no-install-recommends libopenvg1-mesa

# Set root passwd; change passwd accordingly
RUN echo "root:test" | chpasswd

# Change to your needs
RUN locale-gen en_IE.UTF-8
ENV LANG en_IE.UTF-8

# Add user so that no root-login is required; change username and password
# accordingly
RUN useradd -m chbj
RUN echo "chbj:test" | chpasswd
RUN usermod -s /bin/bash chbj
RUN usermod -aG sudo chbj
ENV HOME /home/chbj
WORKDIR /home/chbj
USER chbj

# set vim as default editor; vi-editing mode for bash
RUN cd && printf "# If not running interactively, don't do anything\n[[ \$- != *i* ]] && return\n\nalias ls='ls --color=auto'\n\nalias grep='grep --color=auto'\n\nPS1='[\u@\h \W]\\$ '\n\ncomplete -cf sudo\n\n# Set default editor.\nexport EDITOR=vim xterm\n\n# Enable vi editing mode.\nset -o vi" > /home/chbj/.bashrc

# Set vi-editing mode for R
RUN cd && printf "set editing-mode vi\n\nset keymap vi-command" > /home/chbj/.inputrc

# Make julia run as default process. This is for Docker 1.2 for Docker 1.3
# this will change and the CMD [] will not be needed anymore.
CMD []
ENTRYPOINT ["/usr/local/bin/julia"]
