FROM debian:11.1-slim

# No interactive frontend during docker build
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    xvfb xauth dbus-x11 xfce4 xfce4-terminal \
    wget sudo curl gpg git bzip2 vim procps python x11-xserver-utils \
    libnss3 libnspr4 libasound2 libgbm1 ca-certificates fonts-liberation xdg-utils \
    firefox-esr x11vnc fluxbox; \
    curl http://ftp.us.debian.org/debian/pool/main/liba/libappindicator/libappindicator3-1_0.4.92-7_amd64.deb --output /opt/libappindicator3-1_0.4.92-7_amd64.deb && \
    curl http://ftp.us.debian.org/debian/pool/main/libi/libindicator/libindicator3-7_0.5.0-4_amd64.deb --output /opt/libindicator3-7_0.5.0-4_amd64.deb && \
    apt-get install -y /opt/libappindicator3-1_0.4.92-7_amd64.deb /opt/libindicator3-7_0.5.0-4_amd64.deb

RUN apt-get install -y xterm xdotool chromium qutebrowser
ENV TERM xterm
# Install NOVNC.
RUN     git clone --branch master --single-branch https://github.com/novnc/noVNC.git /opt/noVNC; \
        git clone --branch v0.11.0 --single-branch https://github.com/novnc/websockify.git /opt/noVNC/utils/websockify; \
        ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

# disable shared memory X11 affecting Chromium
ENV QT_X11_NO_MITSHM=1 \
    _X11_NO_MITSHM=1 \
    _MITSHM=0


# give every user read write access to the "/root" folder where the binary is cached
RUN chmod 777 /root && mkdir /src

RUN groupadd -g 61000 dockeruser; \
    useradd -g 61000 -l -m -s /bin/bash -u 61000 dockeruser


RUN chown -R dockeruser:dockeruser /home/dockeruser;\
    chmod -R 777 /home/dockeruser ;\
    adduser dockeruser sudo;\
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER dockeruser
# versions of local tools
RUN echo  "debian version:  $(cat /etc/debian_version) \n" \
          "user:            $(whoami) \n"

COPY scripts/entrypoint.sh /src

EXPOSE 6000 6001
ENTRYPOINT ["/src/entrypoint.sh"]