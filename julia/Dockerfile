FROM ubuntu:latest

MAINTAINER Christian Brauner christianvanbrauner[at]gmail.com

RUN apt-get update -qq \
&& apt-get install -y --no-install-recommends \
   gcc \
   g++ \
   gfortran \
   git \
   m4 \
   make \
   mupdf \
   patch \
   python \
   vim-tiny \
   wget \
&& apt-get clean

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
