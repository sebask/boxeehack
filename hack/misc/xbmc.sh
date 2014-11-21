#!/bin/sh
if [ `ps -A | grep -c xbmc.bin` -eq 1 ]; then
	exit
fi
if [ `ps -A | grep -c kodi.bin` -eq 1 ]; then
	exit
fi
while true
do
	for m in /tmp/mnt/*; do
        if [ -f ${m}/xbmc.bin ] || [ -f ${m}/xbmc/xbmc.bin ] || [ -f ${m}/kodi.bin ] || [ -f ${m}/xbmc/kodi.bin ]; then
			# If XBMC is in a folder called xbmc instead of the root
			p=${m}
			if [ -f ${m}/xbmc/xbmc.bin ] || [ -f ${m}/xbmc/kodi.bin ]; then
				p=${m}/xbmc
			fi
			cd ${p}
			if [ -f ${p}/kodi.bin ]; then
				b=kodi.bin
			else
				b=xbmc.bin
			fi
			chmod +x ${p}/${b}
			HOME=${p} GCONV_PATH=${p}/gconv AE_ENGINE=active PYTHONPATH=${p}/python2.7:${p}/python2.7/lib-dynload PYTHONHOME=${p}/python2.7:${p}/python2.7/lib-dynload XBMC_HOME=${p} ${p}/${b} --standalone -p -l /var/run/lirc/lircd 2>>/tmp/xbmc.log
			ret=$?
			break
		fi
	done
	case "${ret}" in
		0 ) # Quit
			 ;;
		64 ) # Shutdown System
			poweroff
			break 2 
			;;
		65 ) # Warm Reboot
			;;
		66 ) # Reboot System
			reboot
			break 2 
			;;
		139 ) # Crashed so reboot
			reboot
			break 2
			;;
		* ) ;;
	esac
done
