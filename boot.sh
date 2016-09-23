#!/bin/bash
# read 'text' env var and export it as confd expected value
# set it to 'father' if it does not exist
# run confd to render out the config
/root/confd-0.11.0-linux-amd64 -onetime -backend env
# run app
su -m ircd -c "/home/ircd/hybrid/bin/ircd -foreground -configfile /home/ircd/hybrid/etc/ircd.conf"
