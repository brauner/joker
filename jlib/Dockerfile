FROM busybox:latest

MAINTAINER Christian Brauner christianvanbrauner[at]gmail.com

RUN mkdir /home/docker \
&& mkdir /home/docker/.julia \
&& chown 1000:1000 /home/docker/.julia

VOLUME ["/home/docker/.julia"]
