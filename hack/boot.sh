#!/bin/sh
# Ensure everything can start
dos2unix /data/hack/*.sh
dos2unix /data/hack/init.d/*.sh
dos2unix /data/hack/misc/*.sh
chmod 777 /data/hack/*.sh
chmod 777 /data/hack/bin/*
chmod 777 /data/hack/init.d/*
chmod 777 /data/hack/misc/*.sh

find /data/hack/init.d -type f | sort | while read line
do
        sh $line
done