# java6dev
#
# VERSION               0.1.0

FROM ubuntu:14.04

MAINTAINER whybe <ahsky2@gmail.com>

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /root/

COPY update-alternatives.sh /root/

# change sourcelist into korean mirror
RUN sed -i 's/archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list
RUN apt-get update

# install java ppg
RUN  apt-get install -y --no-install-recommends software-properties-common && \
  add-apt-repository -y ppa:webupd8team/java && \
  # apt-get update && \
  apt-get autoremove -y software-properties-common && \
  apt-get clean -yq && \
  rm -rf /var/lib/apt/lists/*

# accept-java-license
RUN echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

# install lastest oracle-java6
RUN apt-get update && \
  apt-get install -y --no-install-recommends oracle-java6-installer

# install 6u13-b03
# http://download.oracle.com/otn/java/jdk/6u13-b03/jdk-6u13-linux-x64.bin
RUN apt-get install -y --no-install-recommends wget && \
  wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/6u13-b03/jdk-6u13-linux-x64.bin" && \
  chmod +x ./jdk-6u13-linux-x64.bin && \
  echo "./jdk-6u13-linux-x64.bin < <(echo y)" > ./unpack && \
  /bin/bash ./unpack && \
  rm -f ./unpack && \
  mkdir -p /usr/lib/jvm/ && \
  mv -f ./jdk1.6.0_13 /usr/lib/jvm/ && \
  rm -f ./jdk-6u13-linux-x64.bin && \
  /bin/bash ./update-alternatives.sh jdk1.6.0_13 1 && \
  echo "Oracle jdk1.6.0_13 installed" && \
  apt-get clean -yq && \
  rm -rf /var/lib/apt/lists/*