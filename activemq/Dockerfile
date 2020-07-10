# Apache-ActiveMQ Container Image
FROM ubuntu:16.04

MAINTAINER Intuz Cloud Support

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en
ENV ACTIVEMQ_VERSION 5.15.6
ENV ACTIVEMQ apache-activemq-$ACTIVEMQ_VERSION
ENV ACTIVEMQ_TCP=61616 ACTIVEMQ_AMQP=5672 ACTIVEMQ_STOMP=61613 ACTIVEMQ_MQTT=1883 ACTIVEMQ_WS=61614 ACTIVEMQ_UI=8161
ENV ACTIVEMQ_HOME /opt/activemq
ENV USER activemq \
    GROUP activemq \
    UID 10003 \
    GID 10003 \

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y software-properties-common aptitude screen htop nano nmap net-tools wget tar zip vim bash-completion apt-utils sudo
RUN apt-get install -y --no-install-recommends openjdk-8-jdk git curl apt-transport-https

## Programm and packages install
RUN set -x && \
    mkdir -p /opt && \
    curl https://archive.apache.org/dist/activemq/$ACTIVEMQ_VERSION/$ACTIVEMQ-bin.tar.gz -o $ACTIVEMQ-bin.tar.gz

RUN tar xzf $ACTIVEMQ-bin.tar.gz -C  /opt && \
    ln -s /opt/$ACTIVEMQ $ACTIVEMQ_HOME && \
    #groupadd  activemq && useradd  -f activemq -b $ACTIVEMQ_HOME activemq && \
    #chown -R activemq:activemq /opt/$ACTIVEMQ && \
    #chown -h activemq:activemq $ACTIVEMQ_HOME && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apk/*


WORKDIR $ACTIVEMQ_HOME
EXPOSE $ACTIVEMQ_TCP $ACTIVEMQ_AMQP $ACTIVEMQ_STOMP $ACTIVEMQ_MQTT $ACTIVEMQ_WS $ACTIVEMQ_UI

CMD ["/bin/sh", "-c", "bin/activemq console"]

