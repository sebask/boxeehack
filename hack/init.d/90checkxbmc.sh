#!/bin/sh
# Check if XBMC is installed internally
if [ -f /data/hack/xbmc/xbmc.sqfs && -f /data/hack/xbmc_launch.sh ]; then
	if [ ! -f /data/hack/init.d/99xbmc_launch.sh ]; then
		sh /data/hack/xbmc_launch.sh &
	fi
	exit
fi

# Check if we have XBMC installed on an external drive
for m in /tmp/mnt/*; do
	if [ -f ${m}/xbmc.bin ] || [ -f ${m}/xbmc/xbmc.bin ] || [ -f ${m}/kodi.bin ] || [ -f ${m}/xbmc/kodi.bin ]; then
		/etc/rc3.d/U94boxeehal stop
		/etc/rc3.d/U99boxee stop
		killall BoxeeHal
		killall BoxeeLauncher
		killall Boxee
		killall run_boxee.sh
		mount -o bind /data/hack/misc/xbmc.sh /opt/boxee/BoxeeLauncher
		/opt/boxee/BoxeeLauncher &
		exit
	fi
done
