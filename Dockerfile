FROM telegraf:latest
MAINTAINER Markus Benning <ich@markusbenning.de>

RUN apt-get update && apt-get install -y ruby2.0 && apt-get clean
ADD netatmo /usr/local/bin/netatmo

