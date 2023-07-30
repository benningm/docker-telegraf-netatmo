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
{
  "station": {
    "Innenraum": {
      "wifi_status": 65,
      "Temperature": 21.9,
      "CO2": 1246,
      "Humidity": 62,
      "Noise": 37,
      "Pressure": 1010.2,
      "AbsolutePressure": 975.4,
      "AbsoluteHumidity": 11.96
    },
    "Aussenraum": {
      "battery_percent": 45,
      "rf_status": 74,
      "Temperature": 15.8,
      "Humidity": 100,
      "AbsoluteHumidity": 13.45
    }
  }
}
```

Or with `include_station_name: false`:

```
{
  "Innenraum": {
    "wifi_status": 66,
    "Temperature": 21.8,
    "CO2": 1242,
    "Humidity": 62,
    "Noise": 47,
    "Pressure": 1010,
    "AbsolutePressure": 975.2,
    "AbsoluteHumidity": 11.89
  },
  "Aussenraum": {
    "battery_percent": 45,
    "rf_status": 74,
    "Temperature": 15.6,
    "Humidity": 100,
    "AbsoluteHumidity": 13.29
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
refresh_token: <token generated on website>
device_id: <station MAC>
# include_station_name: false # returns stations data on root level
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
