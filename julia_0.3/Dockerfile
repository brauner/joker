FROM ubuntu:latest

MAINTAINER Christian Brauner christianvanbrauner[at]gmail.com

RUN apt-get update -qq \
&& apt-get install -y --no-install-recommends \
   bash-completion \
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
&& git checkout release-0.3 \
&& printf "prefix=/usr/local\n\nMARCH=core2\n" > Make.user \
&& make \
&& make install \
&& rm -rf /tmp/julia \
&& apt-get autoremove -y git \
&& apt-get clean

# Add user
RUN echo "root:test" | chpasswd \
&& useradd -m j3 \
&& echo "j3:test" | chpasswd \
&& usermod -s /bin/bash j3 \
&& usermod -aG sudo j3

ENV HOME /home/j3
WORKDIR /home/j3
USER j3

ENTRYPOINT ["/usr/local/bin/julia"]
