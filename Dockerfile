FROM danielchalef/armhf-ros-jade-base-docker
MAINTAINER Daniel Chalef <daniel.chalef@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update; apt-get upgrade -y

RUN apt-get install --no-install-recommends ros-jade-robot ros-jade-perception ros-jade-robot-localization ros-jade-opencv3 ros-jade-rospy -y

WORKDIR /root/catkin_ws/
RUN cd src && git clone https://github.com/danielchalef/neato_robot.git

RUN apt-get install build-essential -y
RUN bash -c "source /opt/ros/jade/setup.sh; catkin_make && catkin_make -DCMAKE_INSTALL_PREFIX=/opt/ros/jade/ install"
