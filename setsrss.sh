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
ver="20210913"

dval=99
nval=10

sudo mount -o remount,rw /

if [ -z "$2" ]; then
	lat=$(sed -nr "/^\[Info\]/ { :l /^Latitude[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)N
	lon=$(sed -nr "/^\[Info\]/ { :l /^Longitude[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" /etc/mmdvmhost)W
else
	lat="$1"
	lon="$2"
fi

echo "$lat  /  $lon"

dn=$(sudo /home/pi-star/sunwait/sunwait poll "$lat" "$lon")

if [ "$dn" == "DAY" ]; then 
        sudo sed -i '/^\[/h;G;/Nextion/s/\(Brightness=\).*/\1'"$dval"'/m;P;d'  /etc/mmdvmhost
        sudo sed -i '/^\[/h;G;/Nextion/s/\(IdleBrightness=\).*/\1'"$dval"'/m;P;d'  /etc/mmdvmhost
	echo "$dn Set BL=$dval"

else
        sudo sed -i '/^\[/h;G;/Nextion/s/\(Brightness=\).*/\1'"$nval"'/m;P;d'  /etc/mmdvmhost
        sudo sed -i '/^\[/h;G;/Nextion/s/\(IdleBrightness=\).*/\1'"$nval"'/m;P;d'  /etc/mmdvmhost
	echo "$dn Set BL=$nval"
fi
sudo mmdvmhost.service restart &> null
