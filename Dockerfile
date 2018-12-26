FROM  hbrobotics/ros-base:rpi3

RUN git clone git://git.qemu.org/qemu.git && \
cd qemu && \
./configure --target-list=arm-linux-user --static && \
make && \
make install

COPY ./qemu-arm-static /usr/bin/qemu-arm-static

# --- general --- #
ARG work_dir=/tmp/setup
RUN mkdir ${work_dir} && \
chmod 777 ${work_dir}

# --- Roswell --- #
RUN apk add --no-cache git automake autoconf make gcc build-base curl-dev curl glib-dev libressl-dev ncurses-dev sqlite libev-dev && \
cd ${work_dir} && \
git clone --depth=1 -b release https://github.com/roswell/roswell.git && \
cd roswell && \
sh bootstrap && \
./configure --disable-manual-install && \
make && \
make install && \
cd .. && \
rm -rf roswell && \
ros install ccl-bin/1.11.5 && \
ros run -q

# --- Add PATH to roswell/bin --- #
ENV PATH /root/.roswell/bin:${PATH}
