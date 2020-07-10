FROM ubuntu:16.04

MAINTAINER Intuz Cloud Support

ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No
ENV LANG en_US.UTF-8

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y software-properties-common aptitude screen htop nano nmap net-tools wget tar zip vim bash-completion apt-utils sudo
RUN apt-get install -y --no-install-recommends openjdk-8-jdk git curl 
RUN wget -qO - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add - && \
    echo 'deb http://pkg.jenkins-ci.org/debian binary/' \
      | tee /etc/apt/sources.list.d/jenkins.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y jenkins && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    update-rc.d -f jenkins disable

ENV JENKINS_HOME /var/jenkins
VOLUME /var/jenkins
EXPOSE 8080 50000

CMD ["/usr/bin/java", "-jar", "/usr/share/jenkins/jenkins.war"]
