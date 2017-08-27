# Netatmo script for telegraf

This image is based on the telegraf image and adds a script for retrieving
data of a netatmo weather station via the netatmo API server.

You need to obtain API keys from the Netatmo developmer website first:

https://dev.netatmo.com/

## Environment variables

The script reads credentials from the environment:

* NETATMO_CLIENT_ID
* NETATMO_CLIENT_SECRET
* NETATMO_USERNAME
* NETATMO_PASSWORD
* NETATMO_DEVICE_ID

Pass them with `docker run` and the `-e` option:

```
docker run \
  -e 'NETATMO_CLIENT_ID=YOUR_CLIENT_ID'
  -e 'NETATMO_CLIENT_SECRET=YOUR_CLIENT_SECRET'
  ...
  benningm/telegraf-netatmo:latest
```

## Configuration

You need to configure a `exec` input in your `telegraf.conf`:

```
[[inputs.exec]]
  commands = ["/usr/local/bin/netatmo"]
  timeout = "15s"
  data_format = "json"
  name_suffix = "_netatmo"
```

