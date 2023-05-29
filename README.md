# My OpenWRT Config
[![Validate OpenWRT Config](https://github.com/Sitebase/openwrt-config/actions/workflows/validate.yml/badge.svg)](https://github.com/Sitebase/openwrt-config/actions/workflows/validate.yml)

In this repository you'll find my OpenWRT configuration. I've forked the config from https://github.com/Sitebase/openwrt-config and adapted it for my needs. 


## Flake

This repo is a flake which defines the requirements needed for deploying. You'll also need to have loaded your GPG private key and to be on the authorized user list.

## Secrets

Secrets are stored as environmental variables and saved in .secrets. This file is encrypted with git-crypt - run `git-crypt init && git-crypt unlock` on first clone.

## MQTT Publish on OpenWRT
If you have a home automation system on your network it could be useful to send events to a MQTT broker based on events happening on your router.

```
mosquitto_pub -h $MQTT_HOST -u $MQTT_USER -P $MQTT_PASSWORD -t "homeassistant/openwrt/started" -m "${HOSTNAME}" -p 1883
```

### Example for pushing events to MQTT
Create a script in `/etc/hotplug.d/button/99-buttons` with following content:
```
source /root/.secrets
logger -t gpio "${BUTTON} state changed to ${ACTION}"
mosquitto_pub -h $MQTT_HOST -u $MQTT_USER -P $MQTT_PASSWORD -t "openwrt/gpio/${BUTTON}" -m "${ACTION}" -p 1883
```
This script will automatically trigger MQTT events based on buttons pressed on the router.

## Packages
List of the packages I'm using and the reason why:
* luci-app-simple-adblock: Block ads and trackers

## To Do
* Write to dos

## Notes
* ED25519 ssh keys are not supported out of the box so don't try to use them. [More info](https://openwrt.org/docs/guide-user/security/dropbear.public-key.auth#providing_ed25519_support)

