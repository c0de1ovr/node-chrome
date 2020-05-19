FROM debian:buster-slim
LABEL maintainer="info@romischart.de"

ARG NODE_VERSION=12.16.3
ENV NVM_DIR /usr/local/nvm

#============================
# Screen configuration
#============================
ENV SCREEN_WIDTH 1360
ENV SCREEN_HEIGHT 1020
ENV SCREEN_DEPTH 24
ENV SCREEN_DPI 96
ENV DISPLAY :99.0
ENV START_XVFB true

USER root

#==============
# Xvfb
#==============
RUN apt-get update -qqy \
    && apt-get -qqy install \
        xvfb \
        libgtk-3-0 \
        libdbus-glib-1-2 \
        gnupg2 \
        wget \
        bzip2 \
    &&  mkdir -p /usr/local/nvm \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list

#================
# Fonts
#================
RUN apt-get -qqy update \
  && apt-get -qqy --no-install-recommends install \
    libfontconfig \
    libfreetype6 \
    xfonts-cyrillic \
    xfonts-scalable \
    fonts-liberation \
    fonts-ipafont-gothic \
    fonts-wqy-zenhei \
    fonts-tlwg-loma-otf

#============================
# Chrome install & configure
#============================
RUN apt-get update -qqy \
    && apt-get -qqy install \
        google-chrome-stable \
    && rm /etc/apt/sources.list.d/google-chrome.list 

COPY src/chrome-runner.sh /opt/bin/chrome-runner
COPY src/start-xvfb.sh /usr/local/bin/start-xvfb
COPY src/configure-chrome.sh /opt/bin/configure-chrome.sh
RUN chmod +x /opt/bin/configure-chrome.sh \
    && /opt/bin/configure-chrome.sh 

#================
# Cleanup
#================
RUN apt-get -qyy autoremove \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
  && apt-get -qyy clean

#================
# Configure node user
#================
RUN groupadd --gid 1000 node \
    && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

#================
# Install nvm
#================
RUN mkdir -p ${NVM_DIR} \
    && wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash \
    && [ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh" \
    && nvm install ${NODE_VERSION} \
    && nvm alias default ${NODE_VERSION} \
    && nvm use default

#================
# Configure node environment
#================
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN npm install --global yarn

USER node
WORKDIR /home/node
CMD [ "start-xvfb" ]