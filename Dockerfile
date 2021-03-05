FROM jenkins/jenkins:lts
#FROM jenkins

USER root

#install ruby、make
RUN apt-get update && apt-get install -y ruby make

#install ansiblde
RUN apt-get install -y ansible

RUN mkdir -p /var/jenkins_home 
WORKDIR /var/jenkins_home

#Time
ENV TW=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TW /etc/localtime && echo $TW > /etc/timezone

EXPOSE 8080
EXPOSE 50000
