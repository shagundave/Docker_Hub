FROM ubuntu:16.04
MAINTAINER Shaggy_Dave

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install -y zip \
        apt-transport-https \
        ca-certificates \
        software-properties-common \
        curl \
        python3-pip \
        git \
        gnupg \
        python-software-properties \
        build-essential \
        wget

##Docker install on ubuntu

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update -y
RUN apt-get install -y docker-ce docker-ce-cli containerd.io

##AWS-CLI and Google SDK install

RUN pip3 install awscli
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update -y && apt-get install google-cloud-sdk -y

###Kubernetes install

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

##Cleanup packages
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["service", "docker", "start"]
