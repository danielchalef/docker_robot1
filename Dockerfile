FROM danielchalef/armhf-ros-jade-base-docker
MAINTAINER Daniel Chalef <daniel.chalef@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update; apt-get upgrade -y

RUN apt-get install ros-jade-robot ros-jade-perception ros-jade-robot-localization ros-jade-opencv3 ros-jade-rospy

WORKDIR /root/catkin_ws/
RUN cd src && git clone https://github.com/danielchalef/neato_robot.git

RUN catkin_make && catkin_make install
