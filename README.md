# Netatmo script for telegraf

This repository contains a script for retrieving data of a netatmo weather
station for use with telegraf.

First obtain API keys from the Netatmo developmer website:

https://dev.netatmo.com/

## Dependencies

The script requires ruby 2.0 or newer.

## Usage

```
Usage: netatmo [options]
    -c, --config=PATH                Path to configuration file
```

## Example

Here is an example what data is read from the station (with one outdoor sensor):

```
$ ruby ./netatmo  | json_pp
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

## Configuration

The script reads credentials from the `/etc/netatmo.yml` configuration file:

```
---
client_id: <hex-value>
client_secret: <hex-value>
username: <email>
password: <secret>
device_id: <station MAC>
```

## Telegraf configuration

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
