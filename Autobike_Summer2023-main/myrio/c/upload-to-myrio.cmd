@echo off
echo:
echo [33mStarting upload of built files to the myRIO[0m
echo:

set  usb_ip=172.22.11.2
set wifi_ip=192.168.1.147

(ping /w 100 /n 1 %wifi_ip% | find "TTL" > NUL && set ip=%wifi_ip%) || (echo "Unable to find myRIO on wifi (%wifi_ip%) falling back to usb (%usb_ip%)" && set ip=%usb_ip%)

echo [33mPlease log in to the myRIO admin user.[0m
echo [33mThe default password is blank, or it might have been set to 'admin'.[0m
echo [33mPress CTRL+C to cancel[0m
echo:
scp bin/*.so admin@%ip%:/usr/local/lib || echo [33mSkipping upload of files to the myRIO[0m
