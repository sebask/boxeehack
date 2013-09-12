#!/bin/sh
while true
do
	for m in /tmp/mnt/*; do
        	if [ -f ${m}/xbmc.bin ]; then
			cd ${m}
			HOME=${m} GCONV_PATH=${m}/gconv AE_ENGINE=active PYTHONPATH=${m}/python2.7:${m}/python2.7/lib-dynload PYTHONHOME=${m}/python2.7:${m}/python2.7/lib-dynload XBMC_HOME=${m} ${m}/xbmc.bin --standalone 2>>/tmp/xbmc.log
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
