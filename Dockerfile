FROM debian:jessie

MAINTAINER François LASSERRE <choiz@me.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
&& apt-get install -y python-pip python-dev python-liblo python-mutagen python-pycurl python-yaml libshout3-dev librtmp-dev liblo-dev libcurl4-openssl-dev \
&& pip install -U distribute setuptools \
&& pip install deefuzzer

RUN apt-get install -y wget

# supervisor installation && 
# create directory for child images to store configuration in
RUN apt-get -y install supervisor \
&& mkdir -p /var/log/supervisor \
&& mkdir -p /etc/supervisor/conf.d

# supervisor configuration
COPY config/supervisor.conf /etc/supervisor.conf

# deefuzzer folder
RUN mkdir -p /home/deefuzzer/mystation \
&& wget https://raw.githubusercontent.com/ChoiZ/mediaelement-files/master/AirReview-Landmarks-02-ChasingCorporate.mp3 -O /home/deefuzzer/mystation/AirReview-Landmarks-02-ChasingCorporate.mp3

# deefuzzer configuration
COPY config/station/deefuzzer.xml /home/deefuzzer/mystation/
COPY config/station/playlist.m3u /home/deefuzzer/mystation/

CMD supervisord -n -c /etc/supervisor.conf
