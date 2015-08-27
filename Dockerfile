#FROM ubuntu:14.04  ## Uncomment if you want to build for amd64
FROM danielchalef/armhf-ros-jade-base-docker
MAINTAINER Daniel Chalef <daniel.chalef@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update; apt-get upgrade -y

#RUN apt-get install ros-jade-mobile ros-jade-perception


