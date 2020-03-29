FROM alpine

MAINTAINER Walshipotamus <walshipotamus@gmail.com>

ENV TERM=xterm-256color

ADD https://www.noip.com/client/linux/noip-duc-linux.tar.gz /usr/local/src/

RUN true \
  && echo "http://dl-cdn.alpinelinux.org/alpine/v3.7/community" >> /etc/apk/repositories \
  && apk --update upgrade \
# Basics, including runit
  && apk add bash curl htop runit make build-base \
  && mkdir /files \
  && chmod a+rw /files \
  && chmod a+rwX /usr/local/src \
  && cd /usr/local/src/ \
  && tar -xvf /usr/local/src/noip-duc-linux.tar.gz \
  && cd /usr/local/src/noip-2.1.9-1/  \
  && mv Makefile Makefile.old \
# The noip installer will autolaunch after make so we remove those lines
  && sed '/\.conf$/d' Makefile.old > Makefile \
  && make \
  && make install

FROM alpine
COPY --from=0 /usr/local/bin/noip2 /usr/local/bin/noip2

# Needed by our code
RUN apk add expect libc6-compat \
  && rm -rf /var/cache/apk/* \
# RunIt stuff
  && adduser -h /home/user-service -s /bin/sh -D user-service -u 2000 \
  && chown user-service:user-service /home/user-service \
  && mkdir -p /etc/run_once /etc/service /files

# Boilerplate startup code
COPY ./boot.sh /sbin/boot.sh
RUN chmod +x /sbin/boot.sh
CMD [ "/sbin/boot.sh" ]

VOLUME ["/config"]


COPY ["parse_config_file.sh", "noip.conf", "create_config.exp", "/files/"]

# run-parts ignores files with "." in them
COPY parse_config_file.sh /etc/run_once/parse_config_file
RUN chmod +x /etc/run_once/parse_config_file
RUN chmod +x /files/parse_config_file.sh

COPY noip.sh /etc/service/noip/run
RUN chmod +x /etc/service/noip/run
