@echo off
echo:
echo [33mStarting upload of scripts and built files to the RUT955[0m
echo:

set ip=192.168.1.1

(ping /w 100 /n 1 %ip% | find "TTL" > NUL) || (echo "Unable to find RUT955 on (%ip%)" && exit 1)

echo [33mPlease log in to the RUT955 root user when prompted.[0m
echo [33mThe default password should be set to 'Autobike1'.[0m
echo [33mPress CTRL+C to cancel[0m
echo:

scp scripts/99-tiny-ntrip root@%ip%:/etc/hotplug.d/usb
scp scripts/rc.local root@%ip%:/etc
scp scripts/tiny-ntrip-service.sh root@%ip%:/root
scp bin/tiny-ntrip root@%ip%:/root
