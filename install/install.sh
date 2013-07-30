#!/bin/sh

BASEDIR=`dirname $0`

# turn the logo red to indicate we're installing
echo "Changing Logo: Red"
dtool 6 1 0 100
dtool 6 2 0 0

# cleanup some old stuff first
echo "Cleaning up old Mounts (ignore failures)"
umount -f /opt/boxee/skin
umount -f /opt/boxee/media/boxee_screen_saver
umount -f /opt/boxee/skin/boxee/720p
umount -f /opt/boxee/visualisations/projectM

echo $BASEDIR/hack

if [ -d "$BASEDIR/hack" ];
then
	echo "Hack Directory found on USB drive"
    # install the version from the USB drive
	rm -Rf /data/hack
    cp -R "$BASEDIR/hack" /data/
	ver_2=$(awk '{print $1}' "$BASEDIR/hack/version")
	echo "Version: $ver_2"
else
	echo "Hack folder not found, proceeding to download"
    # download the latest version
    rm -Rf /download/boxeehack-master
    rm /download/boxeehack.zip
    cd /download
	echo "Downloading boxeehack.zip"
    /opt/local/bin/curl -L http://boxeed.in/boxeeplus/boxeehack.zip -o boxeehack.zip
	echo "Downloading boxeehack.md5"
    /opt/local/bin/curl -L http://boxeed.in/boxeeplus/boxeehack.md5 -o boxeehack.md5
    md5_1=$(md5sum boxeehack.zip | awk '{print $1}')
    md5_2=$(awk '{print $1}' "boxeehack.md5")
	echo "MD5 of zip: $md5_1"
	echo "MD5 needed: $md5_2"
    if [ "$md5_1" != "$md5_2" ] ; then
        echo "MD5s do not match, aborting"
		dtool 6 1 0 0
		dtool 6 2 0 50
        exit
    fi

	# Extract the archive
	echo "Unzipping boxeehack.zip"
    /bin/busybox unzip boxeehack.zip

	ver_2=$(awk '{print $1}' "/download/boxeehack-master/hack/version")
	echo "Version of unzipped: $ver_2"
	
    # copy the hack folder, and clean up
	echo "Copying the hack folder"
    rm -Rf /data/hack
    cp -R /download/boxeehack-master/hack /data/

	echo "Cleaning Up"
    rm -Rf /download/boxeehack-master
    rm /download/boxeehack.zip
	rm /download/boxeehack.md5
fi

# Verify that we did extract correctly
echo "Verifying the extraction"
ver_1=$(awk '{print $1}' "/data/hack/version")
echo "Extracted Version: $ver_1"
if [ "$ver_1" != "$ver_2" ] ; then
    echo "Extracted versions do not match"
	dtool 6 1 0 0
	dtool 6 2 0 50
    exit
fi

# make everything runnable
chmod -R +x /data/hack/*.sh
chmod -R +x /data/hack/bin/*

# stop Boxee from running and screwing things up
echo "Killing Boxee processes"
killall U99boxee; killall BoxeeLauncher; killall run_boxee.sh; killall Boxee; killall BoxeeHal

# run the hack at next boot
echo "Making changes to XML files"
mv /data/hack/advancedsettings.xml /data/.boxee/UserData/advancedsettings.xml
/bin/busybox sed -i 's/"hostname":"\([^;]*\);.*","p/"hostname":"\1","p/g' /data/etc/boxeehal.conf
/bin/busybox sed -i 's/<hostname>\([^;]*\);.*<\/hostname>/<hostname>\1<\/hostname>/g' /data/.boxee/UserData/guisettings.xml
/bin/busybox sed -i 's/","password/;sh \/data\/hack\/boot.sh","password/g' /data/etc/boxeehal.conf
/bin/busybox sed -i "s/<\/hostname>/;sh \/data\/hack\/boot.sh\<\/hostname>/g" /data/.boxee/UserData/guisettings.xml
/bin/busybox sed -i "s/<enabled>false/<enabled>true/g" /data/.boxee/UserData/guisettings.xml
		
touch /data/etc/boxeehal.conf
touch /data/.boxee/UserData/guisettings.xml

# set a password if one does not yet exist
if ! [ -f /data/etc/passwd ]; then
	echo "secret" > /data/etc/passwd
fi

# turn the logo back to green
echo "Changing Logo: Green"
sleep 5
dtool 6 1 0 0
dtool 6 2 0 50

echo "Rebooting"
# reboot the box to activate the hack
rm /download/install.sh; reboot
