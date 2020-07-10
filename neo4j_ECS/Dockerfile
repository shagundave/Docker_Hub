#Ne04j Docker Container

FROM ubuntu:16.04
MAINTAINER Intuz CloudSupport <cloudsupport@intuz.com>

ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No
ENV LANG en_US.UTF-8

RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-8-jdk openjdk-8-jre-headless git curl apt-transport-https awscli

RUN apt-get install -y software-properties-common aptitude screen htop nano nmap net-tools wget tar zip vim bash-completion apt-utils sudo

RUN wget --no-check-certificate -O - https://debian.neo4j.org/neotechnology.gpg.key | apt-key add - && \
    echo 'deb http://debian.neo4j.org/repo stable/' \
      | tee /etc/apt/sources.list.d/neo4j.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y neo4j && \
    service neo4j stop && \
    service neo4j start && \
    sed -i "s|#dbms.connectors.default_listen_address=0.0.0.0|dbms.connectors.default_listen_address=0.0.0.0|g" /etc/neo4j/neo4j.conf && \
    ulimit -n 65536 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

VOLUME ["/var/lib/neo4j"]
VOLUME ["/etc/neo4j/"]
VOLUME ["/var/log/"]
EXPOSE 7474 1337 7687 7473
CMD service neo4j restart && tail -f /var/log/neo4j/neo4j.log

