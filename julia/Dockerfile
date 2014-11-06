FROM ubuntu:latest

MAINTAINER Christian Brauner christianvanbrauner[at]gmail.com

RUN apt-get update -qq \
&& apt-get install -y --no-install-recommends \
   gcc \
   g++ \
   gfortran \
   m4 \
   make \
   mupdf \
   patch \
   python \
   vim-tiny \
   wget \
&& apt-get clean

RUN apt-get install -y --no-install-recommends git \
&& cd /tmp \
&& git clone git://github.com/JuliaLang/julia.git \
&& cd /tmp/julia \
&& printf "prefix=/usr/local\n\nMARCH=core2\n" > Make.user \
&& make \
&& make install \
&& rm -rf /tmp/julia \
&& apt-get autoremove -y git \
&& apt-get clean

RUN echo "root:test" | chpasswd \
&& useradd -m j \
&& echo "j:test" | chpasswd \
&& usermod -s /bin/bash j \
&& usermod -aG sudo j

ENV HOME /home/j
WORKDIR /home/j
USER j

ENTRYPOINT ["/usr/local/bin/julia"]
