FROM ubuntu:latest

MAINTAINER Christian Brauner christianvanbrauner[at]gmail.com

RUN export DEBIAN_FRONTEND=noninteractive \
&& export DEBCONF_NONINTERACTIVE_SEEN=true \
&& cd /etc/dpkg/dpkg.cfg.d \
&& printf '\npath-exclude=/usr/share/locale/*' >> excludes \
&& printf '\npath-include=/usr/share/locale/en*' >> excludes \
&& printf '\npath-include=/usr/share/locale/locale.alias' >> excludes \
&& printf '\npath-exclude=/usr/share/man/*' >> excludes \
&& printf '\npath-include=/usr/share/man/en*' >> excludes \
&& printf '\npath-include=/usr/share/man/man[1-9]/*' >> excludes \
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
&& cd /var/lib/apt/lists \
&& rm -rf *

RUN cd /tmp \
&& git clone git://github.com/JuliaLang/julia.git \
&& cd /tmp/julia \
&& git checkout release-0.3 \
&& printf 'prefix=/usr/local\n\nMARCH=core2\n' > Make.user \
&& make \
&& make install \
&& cd /tmp \
&& rm -rf julia

# Add user
RUN echo 'root:test' | chpasswd \
&& useradd -u 1000 -m docker \
&& echo 'docker:test' | chpasswd \
&& usermod -s /bin/bash docker \
&& usermod -a -G 100 docker
# && usermod -a -G sudo docker

ENV HOME /home/docker
WORKDIR /home/docker
USER docker

ENTRYPOINT ["/usr/local/bin/julia"]
