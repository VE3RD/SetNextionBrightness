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
#
#set -o errexit
#set -o pipefail
ver="20211031"

sudo mount -o remount,rw /

lc=$(wc -l < /var/log/pi-star/Nextion-Brightness-Adjusted.log)
if [ "$lc" -gt 10 ]; then
 sed -i '1d' /var/log/pi-star/Nextion-Brightness-Adjusted.log
 fi


latlon=$(/home/pi-star/SetNextionBrightness/aprsquery.php)
lat1=$(echo "$latlon" | cut -d ' ' -f1)
lon1=$(echo "$latlon" | cut -d ' ' -f2)
lat2="${lat1:0:1}" 
lon2="${lon1:0:1}"

if [ "$lat2" == "-" ]; then
	lat=$(echo "$lat1" | tr -d - )S 
 else
	lat=$(echo "$lat1" | tr -d - )N

fi
if [ "$lon2" == "-" ]; then
	lon=$(echo "$lon1" | tr -d - )W 
 else
	lon=$(echo "$lon1" | tr -d - )E

fi

lmode=$(echo "$latlon" | cut -d ' ' -f3)

#echo "Location: $latlon"
echo "Location: $lat $lon  Mode=$lmode"


 daym=$(sed -nr "/^\[General\]/ { :l /^Day[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/nextionbrightness)
 nightm=$(sed -nr "/^\[General\]/ { :l /^Night[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/nextionbrightness)
 call=$(sed -nr "/^\[General\]/ { :l /^Call[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/nextionbrightness)
 apik=$(sed -nr "/^\[General\]/ { :l /^ApiKey[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/nextionbrightness)

echo "Setting Day=$daym or Night=$nightm"

y=$(date '+%Y-%m-%d %H:%M:%S')
 
DN=$(/home/pi-star/sunwait/sunwait -poll "$lat" "$lon")
echo "$y DN: $DN"
if [ -f /home/pi-star/DN.txt ]; then
   line=$(head -n 1 /home/pi-star/DN.txt)
	if [ "$line" == "$DN" ]; then
		echo "No Change"
#echo "$line:$DN"
#		sudo mount -o remount,ro /
		exit
	fi
fi
sudo mount -o remount,rw /
   
echo "$DN" > /home/pi-star/DN.txt
sudo touch /var/log/pi-star/Nextion-Brightness-Adjusted.log


if [ "$DN" == "DAY" ]; then
        sudo sed -i '/^\[/h;G;/Nextion/s/\(Brightness=\).*/\1'"$daym"'/m;P;d'  /etc/mmdvmhost
        sudo sed -i '/^\[/h;G;/Nextion/s/\(IdleBrightness=\).*/\1'"$daym"'/m;P;d'  /etc/mmdvmhost
        echo "$y Setting Brightness=$daym"
        echo "$y Setting Brightness to $daym" >> /var/log/pi-star/Nextion-Brightness-Adjusted.log
else
        sudo sed -i '/^\[/h;G;/Nextion/s/\(Brightness=\).*/\1'"$nightm"'/m;P;d'  /etc/mmdvmhost
        sudo sed -i '/^\[/h;G;/Nextion/s/\(IdleBrightness=\).*/\1'"$nightm"'/m;P;d'  /etc/mmdvmhost
        echo "$y Setting Brightness=$nightm"
        echo "$y Setting Brightness to $nightm" >> /var/log/pi-star/Nextion-Brightness-Adjusted.log
fi
sleep 2
sudo mount -o remount,ro /
sudo mmdvmhost.service restart 
