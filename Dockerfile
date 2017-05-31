FROM ubuntu:14.04

MAINTAINER Eranga Bandara (erangaeb@gmail.com)

# install java and other required packages
RUN apt-get update -y
RUN apt-get install -y python-software-properties
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update -y

# install java
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN apt-get install -y oracle-java8-installer
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /var/cache/oracle-jdk7-installer

# set JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# log stash version
ENV LS_PKG logstash-2.4.0

# download and install logstash
RUN cd /
RUN wget https://download.elasticsearch.org/logstash/logstash/$LS_PKG.tar.gz
RUN tar xvzf $LS_PKG.tar.gz
RUN rm -f $LS_PKG.tar.gz
RUN mv /$LS_PKG /logstash

# logstash config dir 
RUN mkdir /config

# add logstash.conf to config 
ADD logstash.conf /config/logstash.conf

EXPOSE 5044

# working dir
WORKDIR /config

# as a volume at the end
VOLUME ["/config"]

# start logstash
CMD ["/logstash/bin/logstash", "agent", "-f", "/config/"]
