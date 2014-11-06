FROM ubuntu:latest

MAINTAINER Christian Brauner christianvanbrauner[at]gmail.com

RUN apt-get update -qq \
   gcc \
   g++ \
   gfortran \
   m4 \
   make \
   mupdf \
   patch \
   vim-tiny \
   wget \
# 3D support
   mesa-utils \
   i965-va-driver \
   libegl1-mesa \
   libgl1-mesa-dri \
   libgl1-mesa-glx \
   libopenvg1-mesa \
&& apt-get clean

RUN apt-get install -y --no-install-recommends git \
&& cd /tmp \
&& git clone git://github.com/JuliaLang/julia.git \
&& cd /tmp/julia \
&& printf "prefix=/usr/local\n\nMARCH=core-avx-i\n" > Make.user \
&& make \
&& make install \
&& rm -rf /tmp/julia \
&& apt-get autoremove -y git \
&& apt-get clean

# Add user
RUN echo "root:test" | chpasswd \
&& useradd -m j \
&& echo "j:test" | chpasswd \
&& usermod -s /bin/bash j \
&& usermod -aG sudo j \
# On my system the gid of group video is 91. I need to change gid of group
# video on ubuntu in order to allow access to video devices when I add them to
# the container.
&& groupmod -g 91 video \
&& usermod -aG video j \
&& locale-gen en_IE.UTF-8 \
# set vim as default editor; vi-editing mode for bash
&& cd \
&& printf "# If not running interactively, don't do anything\n[[ \$- != *i* ]] && return\n\nalias ls='ls --color=auto'\n\nalias grep='grep --color=auto'\n\nPS1='[\u@\h \W]\\$ '\n\ncomplete -cf sudo\n\n# Set default editor.\nexport EDITOR=vim xterm\n\n# Enable vi editing mode.\nset -o vi" > /home/j/.bashrc \
# Set vi-editing mode
&& printf "set editing-mode vi\n\nset keymap vi-command" > /home/j/.inputrc

ENV LANG en_IE.UTF-8
ENV HOME /home/j
WORKDIR /home/j
USER j

ENTRYPOINT ["/usr/local/bin/julia"]
