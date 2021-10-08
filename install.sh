#!/bin/bash
cp ./nextionbrightness.ini /etc/nextionbrightness
if [ ! -d /home/pi-star/sunwait ]; then
	cd /home/pi-star/
	sudo mount -o remount,rw /

   	sudo apt-get install sunwait
	cd sunwait
	make
	sudo cp sunwait /usr/local/bin/
else
	echo "sunwait previously installed"
fi
sleep 3
nano /etc/nextionbrightness
echo "run  ./setsrss.sh"
