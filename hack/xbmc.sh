#!/bin/sh
while true
do
	for m in /tmp/mnt/*; do
        if [ -f ${m}/xbmc.bin ] || [ -f ${m}/xbmc/xbmc.bin ]; then
			# If XBMC is in a folder called xbmc instead of the root
			p=${m}
			if [ -f ${m}/xbmc/xbmc.bin ]; then
				p=${m}/xbmc
			fi
			cd ${p}
			chmod +x ${p}/xbmc.bin
			HOME=${p} GCONV_PATH=${p}/gconv AE_ENGINE=active PYTHONPATH=${p}/python2.7:${p}/python2.7/lib-dynload PYTHONHOME=${p}/python2.7:${p}/python2.7/lib-dynload XBMC_HOME=${p} ${p}/xbmc.bin --standalone -p -l /var/run/lirc/lircd 2>>/tmp/xbmc.log
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

