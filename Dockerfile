FROM ubuntu@sha256:b4f9e18267eb98998f6130342baacaeb9553f136142d40959a1b46d6401f0f2b
# Based on https://github.com/mikedickey/RoonServer

# For GitHub container registry
LABEL org.opencontainers.image.source https://github.com/jmmaloney4/roon-docker-image

RUN apt-get update \
	&& apt-get install -y ffmpeg curl bzip2 cifs-utils libasound2 \
	&& apt-get -y clean && apt-get -y autoclean

ENV ROON_DATAROOT=/var/roon/
ENV ROON_ID_DIR /var/roon/

# Location of Roon's latest Linux installer
ENV ROON_INSTALLER roonserver-installer-linuxx64.sh
ENV ROON_INSTALLER_URL http://download.roonlabs.com/builds/${ROON_INSTALLER}
ENV MONO_LOG_LEVEL=info

# Grab installer and script to run it
ADD ${ROON_INSTALLER_URL} /tmp
COPY run_installer.sh /tmp
RUN chmod 700 /tmp/${ROON_INSTALLER} /tmp/run_installer.sh
RUN mkdir -p ${ROON_DATAROOT}

# Run the installer, answer "yes" and ignore errors
RUN /tmp/run_installer.sh

# Your Roon data will be stored in /var/roon; /music is for your music
VOLUME [ "/var/roon", "/music" ]

# This starts Roon when the container runs
ENTRYPOINT /opt/RoonServer/start.sh
