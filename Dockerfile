FROM dorowu/ubuntu-desktop-lxde-vnc

RUN apt-get update && apt-get install -y git \
    mplayer python2.7 python2.7-dev libblas-dev \
    liblapack-dev libffi-dev libssl-dev build-essential \
    libopencv-dev python-opencv python-setuptools \
    python-tk python-pip \
    --no-install-recommends

WORKDIR /root/RMS

RUN git clone https://github.com/CroatianMeteorNetwork/RMS.git /root/RMS
RUN mkdir /root/RMS_data

COPY .docker/scripts/* /root/Desktop/
COPY .docker/requirements.txt /root/RMS/

RUN python setup.py install

VOLUME [ "/root/RMS_data" ]