#!/bin/bash
cp ./nextionbrightness.ini /etc/nextionbrightness
if [ ! -d /home/pi-star/sunwait ]; then
	cd /home/pi-star/
	sudo mount -o remount,rw /

#   	sudo apt-get install sunwait
	
        sudo git clone https://github.com/risacher/sunwait.git
	cd sunwait
	make clean
	make
	echo "Ignore the warnings"
	sudo cp sunwait /usr/local/bin/
else
	echo "sunwait previously installed"
	echo "if you have a problem with sunwait, delete /home/pi-star/sunwait"
	echo " and re-run this install script"
fi
sleep 3
cd /home/pi-star/SetNextionBrightness
nano /etc/nextionbrightness
echo "run  ./setsrss.sh"
sudo ./setsrss.sh
