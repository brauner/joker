FROM ubuntu:latest

MAINTAINER Christian Brauner christianvanbrauner[at]gmail.com

RUN printf "\npath-exclude=/usr/share/locale/*" >> /etc/dpkg/dpkg.cfg.d/excludes \
&& printf "\npath-include=/usr/share/locale/en*" >> /etc/dpkg/dpkg.cfg.d/excludes \
&& printf "\npath-include=/usr/share/locale/locale.alias" >> /etc/dpkg/dpkg.cfg.d/excludes \
&& printf "\npath-exclude=/usr/share/man/*" >> /etc/dpkg/dpkg.cfg.d/excludes \
&& printf "\npath-include=/usr/share/man/en*" >> /etc/dpkg/dpkg.cfg.d/excludes \
&& printf "\npath-include=/usr/share/man/man[1-9]/*" >> /etc/dpkg/dpkg.cfg.d/excludes \
&& apt-get update -qq -y \
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
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

RUN cd /tmp \
&& git clone git://github.com/JuliaLang/julia.git \
&& cd /tmp/julia \
&& printf "prefix=/usr/local\n\nMARCH=core2\n" > Make.user \
&& make \
&& make install \
&& rm -rf /tmp/julia

RUN echo "root:test" | chpasswd \
&& useradd -u 1000 -m docker \
&& echo "docker:test" | chpasswd \
&& usermod -s /bin/bash docker \
&& usermod -a -G 100 docker
# && usermod -a -G sudo docker

ENV HOME /home/docker
WORKDIR /home/docker
USER docker

ENTRYPOINT ["/usr/local/bin/julia"]
