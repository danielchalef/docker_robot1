FROM danielchalef/armhf-ros-jade-base-docker
MAINTAINER Daniel Chalef <daniel.chalef@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

#RUN echo "deb http://ppa.launchpad.net/fo0bar/rpi2/ubuntu vivid main" > /etc/apt/sources.list.d/fo0bar-ubuntu-rpi2-vivid.list

RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:fo0bar/rpi2

RUN apt-get update; apt-get upgrade -y

# For debugging and development
RUN apt-get install -y strace picocom

RUN apt-get install -y --no-install-recommends avahi-daemon libraspberrypi-dev libraspberrypi0 python-serial ros-jade-robot ros-jade-perception ros-jade-robot-localization ros-jade-sound-play ros-jade-opencv3 ros-jade-rospy ros-jade-amcl ros-jade-map-server ros-jade-move-base build-essential libjansson4

RUN mkdir -p /var/run/dbus/ && dbus-daemon --system && service avahi-daemon start

WORKDIR /root
RUN git clone https://github.com/raspberrypi/userland.git vc

# Issues with paths in the RPi SDK includes. This is too ugly for words. 
RUN sed -i 's/include "vcos_platform.h"/include "pthreads\/vcos_platform.h"/g' /root/vc/interface/vcos/vcos.h
RUN sed -i 's/include "vcos_platform_types.h"/include "pthreads\/vcos_platform_types.h"/g' /root/vc/interface/vcos/vcos_types.h
RUN sed -i 's/include "vcos_platform.h"/include "pthreads\/vcos_platform.h"/g' /root/vc/interface/vcos/vcos_init.h
RUN sed -i 's/include "vcos_platform.h"/include "pthreads\/vcos_platform.h"/g' /root/vc/interface/vcos/vcos_thread.h
RUN sed -i 's/include "vcos_platform.h"/include "pthreads\/vcos_platform.h"/g' /root/vc/interface/vcos/vcos_mutex.h
RUN sed -i 's/include "vcos_platform.h"/include "pthreads\/vcos_platform.h"/g' /root/vc/interface/vcos/vcos_mem.h
RUN sed -i 's/include "vcos_platform.h"/include "pthreads\/vcos_platform.h"/g' /root/vc/interface/vcos/vcos_logging.h
RUN sed -i 's/include "vcos_platform.h"/include "pthreads\/vcos_platform.h"/g' /root/vc/interface/vcos/vcos_string.h
RUN sed -i 's/include "vcos_platform.h"/include "pthreads\/vcos_platform.h"/g' /root/vc/interface/vcos/vcos_event.h
RUN sed -i 's/include "vcos_platform.h"/include "pthreads\/vcos_platform.h"/g' /root/vc/interface/vcos/vcos_tls.h
RUN sed -i 's/include "vcos_platform.h"/include "pthreads\/vcos_platform.h"/g' /root/vc/interface/vcos/vcos_reentrant_mutex.h
RUN sed -i 's/include "vcos_platform.h"/include "pthreads\/vcos_platform.h"/g' /root/vc/interface/vcos/vcos_named_semaphore.h
RUN sed -i 's/include "vcos_platform.h"/include "pthreads\/vcos_platform.h"/g' /root/vc/interface/vcos/vcos_quickslow_mutex.h
RUN sed -i 's/include "vcos_platform.h"/include "pthreads\/vcos_platform.h"/g' /root/vc/interface/vcos/vcos_event_flags.h
RUN sed -i 's/include "vcos_platform.h"/include "pthreads\/vcos_platform.h"/g' /root/vc/interface/vcos/vcos_atomic_flags.h
RUN sed -i 's/include "vcos_platform.h"/include "pthreads\/vcos_platform.h"/g' /root/vc/interface/vcos/vcos_once.h
RUN sed -i 's/include "vcos_platform.h"/include "pthreads\/vcos_platform.h"/g' /root/vc/interface/vcos/vcos_blockpool.h
RUN sed -i 's/include "vcos_platform.h"/include "pthreads\/vcos_platform.h"/g' /root/vc/interface/vcos/vcos_quickslow_mutex.h

WORKDIR /root/catkin_ws/
# Raspicam
RUN cd src && git clone https://github.com/fpasteau/raspicam_node.git
RUN sed -i 's/\/home\/pi\/userland/\/root\/vc/g' src/raspicam_node/CMakeLists.txt
RUN sed -i 's:/opt/vc/include:/root/vc:g' src/raspicam_node/CMakeLists.txt
RUN sed -i 's:/opt/vc/lib:/usr/lib:g' src/raspicam_node/CMakeLists.txt

# Neato node
RUN cd src && git clone https://github.com/danielchalef/neato_robot.git

# GSpeech
#RUN cd src && git clone https://github.com/achuwilson/gspeech.git

RUN bash -c "source /opt/ros/jade/setup.sh; rosdep install --from-paths src --ignore-src --rosdistro jade -y"
RUN bash -c "source /opt/ros/jade/setup.sh; catkin_make && catkin_make -DCMAKE_INSTALL_PREFIX=/opt/ros/jade/ install && chmod +x /opt/ros/jade/share/neato_node/nodes/neato.py"

RUN echo "export ROS_MASTER_URI=http://daniel-desktop.local:11311/" >> ~/.bashrc
RUN echo "192.168.2.11	daniel-desktop.local" >> /etc/hosts
RUN export ROS_HOSTNAME=rpi01.local
