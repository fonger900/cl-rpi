FROM pipill/armhf-alpine-glibc

# --- Roswell --- #
RUN apk add --no-cache git automake autoconf make gcc build-base curl-dev curl glib-dev libressl-dev ncurses-dev sqlite libev-dev && \
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

# --- Lem --- #
RUN ln -s ${HOME}/.roswell/local-projects work && \
ros install cxxxr/lem && \
mv ${HOME}/.roswell/bin/lem ${HOME}/.roswell/bin/lem2 && \
mv ${HOME}/.roswell/bin/lem-ncurses ${HOME}/.roswell/bin/lem
