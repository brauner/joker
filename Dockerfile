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
# # Use specific Julia version by following specific release
# RUN cd /tmp/julia && git checkout release-0.3
# # Use specific Julia version by using a specific tag
# RUN cd /tmp/julia && cd julia && git checkout v0.3.0-rc4
# Compile julia from source
RUN cd /tmp/julia && printf "prefix=/usr/local\n\nJULIA_CPU_TARGET=core2\n" > Make.user
RUN cd /tmp/julia && make && make install

# 3D support through /dev/dri. Note this will not happen automatically.
# You will need to add the device when you run your container.
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

# set standard repository to download packages from
RUN cd && printf "options(repos=structure(c(CRAN='http://stat.ethz.ch/CRAN/')))\n" > /home/chbj/.Rprofile

# set vim as default editor; vi-editing mode for bash
RUN cd && printf "# If not running interactively, don't do anything\n[[ \$- != *i* ]] && return\n\nalias ls='ls --color=auto'\n\nalias grep='grep --color=auto'\n\nPS1='[\u@\h \W]\\$ '\n\ncomplete -cf sudo\n\n# Set default editor.\nexport EDITOR=vim xterm\n\n# Enable vi editing mode.\nset -o vi" > /home/chbj/.bashrc

# Set vi-editing mode for R
RUN cd && printf "set editing-mode vi\n\nset keymap vi-command" > /home/chbj/.inputrc

# Make julia start everytime the a container is started from the resulting
# image
CMD []
ENTRYPOINT ["/usr/local/bin/julia"]
