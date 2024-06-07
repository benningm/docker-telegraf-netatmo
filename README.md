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
    -i, --initial-token=TOKEN        Refresh token to initialize authentication
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

The script reads credentials from the configuration file:

```
---
client_id: <hex-value>
client_secret: <hex-value>
device_id: <station MAC>
# include_station_name: false # returns stations data on root level
token_path: /var/lib/netatmo/token.yml
```

## Authentication

To access the Netatmo API an authentication token must be setup.
The token will written to the `token_path` configured in the configuration file.
This file must be writable by the script as the token will be renewed every 3h.

In the Netatmo "My Apps" page go to your applications settings and generate
a token in the "Token generator" section.

The `Refresh Token` must be passed to the netatmo script with the `-i` option to
initialize the authentication. The script will immediately refresh the token passed
and write the new token to the token_path.

On all following invocations the script will use this token and refresh it whenever it expires.

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
