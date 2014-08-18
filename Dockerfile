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
RUN apt-get install -y --no-install-recommends g++
RUN apt-get install -y --no-install-recommends gcc
RUN apt-get install -y --no-install-recommends gfortran
RUN apt-get install -y --no-install-recommends git
RUN apt-get install -y --no-install-recommends m4
RUN apt-get install -y --no-install-recommends wget

# Download julia from Github
RUN cd /tmp && git clone git://github.com/JuliaLang/julia.git
# Compile julia from source
RUN cd /tmp/julia && make && make install

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
CMD ["/usr/local/bin/julia"]
