FROM lordgarbage/debian:testing

MAINTAINER Christian Brauner christianvanbrauner[at]gmail.com

RUN printf "\ndeb http://ftp.de.debian.org/debian testing main contrib non-free\n deb-src http://ftp.de.debian.org/debian testing main contrib non-free\n\n deb http://ftp.debian.org/debian/ jessie-updates main contrib non-free\n deb-src http://ftp.debian.org/debian/ jessie-updates main contrib non-free\n\n deb http://security.debian.org/ jessie/updates main contrib non-free\n deb-src http://security.debian.org/ jessie/updates main contrib non-free\n" > etc/apt/sources.list \
&& export DEBIAN_FRONTEND=noninteractive \
&& printf "\npath-exclude=/usr/share/locale/*" >> /etc/dpkg/dpkg.cfg.d/excludes \
&& printf "\npath-include=/usr/share/locale/en*" >> /etc/dpkg/dpkg.cfg.d/excludes \
&& printf "\npath-include=/usr/share/locale/locale.alias" >> /etc/dpkg/dpkg.cfg.d/excludes \
&& printf "\npath-exclude=/usr/share/man/*" >> /etc/dpkg/dpkg.cfg.d/excludes \
&& printf "\npath-include=/usr/share/man/en*" >> /etc/dpkg/dpkg.cfg.d/excludes \
&& printf "\npath-include=/usr/share/man/man[1-9]/*" >> /etc/dpkg/dpkg.cfg.d/excludes \
&& apt-get update -qq -y \
&& apt-get install -y --no-install-recommends \
   locales \
&& apt-get install -y --no-install-recommends \
   bzip2 \
   cmake \
   gcc \
   g++ \
   gfortran \
   git \
   m4 \
   make \
   patch \
   python \
   wget \
# 3D support
   mesa-utils \
   i965-va-driver \
   libegl1-mesa \
   libgl1-mesa-dri \
   libgl1-mesa-glx \
   libopenvg1-mesa \
   libglu1-mesa-dev \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

RUN cd /tmp \
&& git clone git://github.com/JuliaLang/julia.git \
&& cd /tmp/julia \
&& printf "prefix=/usr/local" > Make.user \
&& printf "\nJULIA_CPU_TARGET=core-avx-i" > Make.user \
&& printf "\nMARCH=ivybridge\n" > Make.user \
&& make \
&& make install \
&& cd \
&& rm -rf /tmp/julia

# Add user
RUN echo "root:test" | chpasswd \
&& useradd -u 1000 -m docker \
&& echo "docker:test" | chpasswd \
&& usermod -s /bin/bash docker \
&& usermod -a -G 100 docker \
# && usermod -a -G sudo docker \
# On my system the gid of group video is 91. I need to change gid of group
# video on ubuntu in order to allow access to video devices when I add them to
# the container.
&& groupmod -g 91 video \
&& usermod -a -G video docker \
&& printf "\nen_IE.UTF-8 UTF-8\n" >> etc/locale.gen \
&& locale-gen \
# set vim as default editor; vi-editing mode for bash
&& cd \
&& printf "# If not running interactively, don't do anything\n[[ \$- != *i* ]] && return\n\nalias ls='ls --color=auto'\n\nalias grep='grep --color=auto'\n\nPS1='[\u@\h \W]\\$ '\n\ncomplete -cf sudo\n\n# Set default editor.\nexport EDITOR=vim xterm\n\n# Enable vi editing mode.\nset -o vi" > /home/docker/.bashrc \
# Set vi-editing mode
&& printf "set editing-mode vi\n\nset keymap vi-command" > /home/docker/.inputrc

ENV LANG en_IE.UTF-8
ENV HOME /home/docker
WORKDIR /home/docker
USER docker

ENTRYPOINT ["/usr/local/bin/julia"]
