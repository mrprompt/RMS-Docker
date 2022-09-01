FROM dorowu/ubuntu-desktop-lxde-vnc:bionic

#REPO python-wxgtk2.8 for CMNbinViewer
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" | sudo tee /etc/apt/sources.list.d/wily-copies.list
RUN rm -rf /etc/apt/sources.list.d/arc-theme*

RUN apt-get update && apt-get install -y cmake git \
    mplayer python3.7 python3.7-dev python3.7-tk python3-pip \
    libblas-dev libatlas-base-dev liblapack-dev \
    at-spi2-core libopencv-dev python-imaging-tk \ 
    libffi-dev libssl-dev socat ntp libxml2-dev \
    libxslt-dev imagemagick ffmpeg qt5-qmake \
    python-wxgtk2.8 build-essential less iputils-ping nano\
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*


RUN mkdir -p /root/source && git clone https://github.com/CroatianMeteorNetwork/RMS.git /root/source/RMS

RUN git clone https://github.com/CroatianMeteorNetwork/cmn_binviewer.git /root/source/cmn_binviewer

RUN mkdir -p /root/Desktop && ln -sf /root/source/RMS/Scripts/CMNbinViewer_env.sh /root/Desktop/CMNbinViewer.sh

COPY .docker/opencv/build.sh /root/source/build/

RUN git clone -b 4.1.0 https://github.com/opencv/opencv.git /root/source/opencv --depth 1 \
    && cd /root/source/opencv \
    && mkdir build \
    && cd build \
    && mv /root/source/build/build.sh . \
    && chmod +x build.sh && ./build.sh \
    && cd /root/source \
    && rm -rf opencv

SHELL ["/bin/bash", "-c"]

RUN python3.7 -m pip install --upgrade pip
RUN python3.7 -m pip install virtualenv && \
    cd /root && \
    virtualenv vRMS && \
    source /root/vRMS/bin/activate \ 
    && python3.7 -m pip install -U pip setuptools \
    && python3.7 -m pip install numpy \
    opencv-python wheel Pillow \
    gitpython scipy cython pyephem astropy paramiko \
    matplotlib imreg_dft configparser imageio \
    pyqtgraph --no-cache-dir

RUN echo '' >> /root/.bashrc \
    && echo 'source /root/vRMS/bin/activate' >> /root/.bashrc \
    && echo 'cd /root/source/RMS' >> /root/.bashrc

RUN mkdir /root/RMS_data
RUN su root -s "bash /root/source/RMS/Scripts/GeneraDesktopLinks.sh"

RUN cd /root/source/RMS && source /root/vRMS/bin/activate && python3.7 setup.py install


