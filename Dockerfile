FROM telegraf:latest

RUN apt-get update \
  && apt-get install -y ruby \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
ADD netatmo /usr/local/bin/netatmo
