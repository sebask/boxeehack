#!/bin/sh
dos2unix /data/hack/*.sh
sh /data/hack/mount.sh &
sh /data/hack/cleanup.sh &
sh /data/hack/skin.sh &
sh /data/hack/cache.sh &
sh /data/hack/visualiser.sh &
sh /data/hack/subtitles.sh &
sh /data/hack/logo.sh &
sh /data/hack/apps.sh &
sh /data/hack/network.sh &
sh /data/hack/telnet.sh &
sh /data/hack/ftp.sh &
sh /data/hack/plugins.sh &
sh /data/hack/checkxbmc.sh &
