#!/bin/bash
#################################################################
#  This script will automate the process of                	#
#  Setting the Nextion Screen Brightness                   	#
#  Based on Lat Lon gps coordiates and sunrise/sunset times	#
#								#
#                                                        	#
#  VE3RD                                      2021/09/17   	#
#################################################################
#
#  This script requires the installation of sunwait
#  Installation:    "sudo apt-get install sunwait"
#
#set -o errexit
#set -o pipefail
ver="20211007"

dval=99
nval=10
Mode=0
#Mode=1 //wait for sunrise
#Mode=2 //wait for sunset

sudo mount -o remount,rw /

latlon=$(./aprsquery.php)
lat=$(echo "$latlon" | cut -d ' ' -f1)W
lon=$(echo "$latlon" | cut -d ' ' -f2)N

echo "Location: $latlon"

DN=$(/home/pi-star/sunwait/sunwait -poll "$lat" "$lon")
echo "DN: $DN"
if [ -f /home/pi-star/DN.txt ]; then
   line=$(head -n 1 /home/pi-star/DN.txt)
	if [ "$line" == "$DN" ]; then
		echo "No Change"
		exit
	fi
else
   echo "$DN" >/home/pi-star/DN.txt

fi
if [ "$DN" == "DAY" ]; then 
        sudo sed -i '/^\[/h;G;/Nextion/s/\(Brightness=\).*/\1'"$dval"'/m;P;d'  /etc/mmdvmhost
        sudo sed -i '/^\[/h;G;/Nextion/s/\(IdleBrightness=\).*/\1'"$dval"'/m;P;d'  /etc/mmdvmhost
	echo "Setting Brightness=$dval"

else
        sudo sed -i '/^\[/h;G;/Nextion/s/\(Brightness=\).*/\1'"$nval"'/m;P;d'  /etc/mmdvmhost
        sudo sed -i '/^\[/h;G;/Nextion/s/\(IdleBrightness=\).*/\1'"$nval"'/m;P;d'  /etc/mmdvmhost
	echo "Setting Brightness=$nval"
fi
sudo mmdvmhost.service restart &> null
