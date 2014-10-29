FROM ubuntu:latest

MAINTAINER Christian Brauner christianvanbrauner[at]gmail.com

# Update repos
RUN apt-get update -qq \
&& apt-get install -y \
   software-properties-common \
&& apt-get install -y --no-install-recommends \
# Some basic tools
   mupdf \
   vim \
# Julia dependencies and other useful packages
   bash-completion \
   bison \
   curl \
   debhelper \
   gcc \
   g++ \
   gfortran \
   git \
   m4 \
   python \
   wget

# Download julia from Github
RUN cd /tmp \
&& git clone git://github.com/JuliaLang/julia.git \
&& cd /tmp/julia \
&& make \
&& make install \
&& rm -rf /tmp/julia

# Add user so that no root-login is required; change username and password
# accordingly
RUN echo "root:test" | chpasswd \
&& useradd -m j \
&& echo "j:test" | chpasswd \
&& usermod -s /bin/bash j \
&& usermod -aG sudo j

ENV HOME /home/j
WORKDIR /home/j
USER j

# Make julia run as default process.
ENTRYPOINT ["/usr/local/bin/julia"]
