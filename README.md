# Netatmo script for telegraf

This repository contains a script and a docker image for retrieving
data of a netatmo weather station for use with telegraf.

The image is based on the telegraf image and adds a script for retrieving
data on top. But you may also use the script standalone.

First obtain API keys from the Netatmo developmer website:

https://dev.netatmo.com/

This keys (client_id, client_secret) must be passed together with your
user credentials via environment variables.

## Dependencies

The script requires ruby 2.0 or newer.

## Example Data

Here is an example what data is read from the station (with one outdoor sensor):

```
$ ruby2.0 ./netatmo  | json_pp
{
   "station" : {
      "indoor" : {
         "Noise" : 40,
         "Humidity" : 70,
         "Temperature" : 18.7,
         "CO2" : 615,
         "AbsolutePressure" : 982.3,
         "Pressure" : 1017.6,
         "AbsoluteHumidity" : 11.2
      },
      "outdoor" : {
         "Temperature" : 12.8,
         "Humidity" : 98,
         "AbsoluteHumidity" : 10.97
      }
   }
}
```

The `AbsoluteHumidity` values are calculated by the script.

## Environment variables

The script reads credentials from the environment:

* NETATMO_CLIENT_ID (client_id of your Netatmo App)
* NETATMO_CLIENT_SECRET (client_secret of your Netatmo App)
* NETATMO_USERNAME (Your Netatmo username)
* NETATMO_PASSWORD
* NETATMO_DEVICE_ID (MAC address of your netatmo station)

Set this environment variables before starting the `netatmo` script.

If you're using the Docker image pass them with `docker run` and the `-e` option:

```
docker run \
  -e 'NETATMO_CLIENT_ID=<hex-value>'
  -e 'NETATMO_CLIENT_SECRET=<hex-value>'
  -e 'NETATMO_USERNAME=<email>
  -e 'NETATMO_PASSWORD=<secret>'
  -e 'NETATMO_DEVICE_ID=<station MAC>'
  ...
```

## Configuration

You need to configure a `exec` input in your `telegraf.conf`:

```
[[outputs.influxdb]]
  urls = ["http://influxdb:8086"]
  database = "telegraf"

[[inputs.exec]]
  commands = ["/usr/local/bin/netatmo"]
  interval = "10m"
  timeout = "15s"
  data_format = "json"
  name_suffix = "_netatmo"
```

## Run as docker container

Now run the container with credentials and configuration:

```
docker run
  --name telegraf \
  -e 'NETATMO_CLIENT_ID=<hex-value>'
  -e 'NETATMO_CLIENT_SECRET=<hex-value>'
  -e 'NETATMO_USERNAME=<email>
  -e 'NETATMO_PASSWORD=<secret>'
  -e 'NETATMO_DEVICE_ID=<station MAC>'
  -v /etc/telegraf/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
  --link influxdb \
  benningm/telegraf-netatmo:latest
```

