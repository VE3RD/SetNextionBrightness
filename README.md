# SetNextionBrightness
## Under Construction

  This script requires the installation of sunwait
  
  Installation:    
sudo apt-get install sunwait        
cd sunwait              
rpi-rw           
sudo cp sunwait /usr/local/bin/          


  This script requires a user access token from APRS.FI
        Log in to APRS.fi
        Scroll down to  Preferences - My account

        Click on My account
        Put the API Key onto your cut/paste buffer

        It should look something like this 00000.AAAAAAAAAAAAAA
	Open aprsquery.php
	and paste it at the apik parameter


Modify The 'calls' parameter in aprsquery.php with the aprs station id you want to track

This Script will set the Nextion Screen Brightness high or low (values are set in the script)      
dval=99  ## Daytime Value of [Nextion] Brightness and IdleBrightness     
nval=10  ## Night time Value of [Nextion] Brightness and IdleBrightness     

the aprsquery.php script will query aprs.fi for the current location of a APRS Station
the ./setsrss.sh script will use that location to detect DAY or Night based on Sunrise and Sunset Times
It will thne modify the screen brightness parameterts in the /etc/mmdvmhost config file
then restart MMDVMHost to pickup the changes


Cron Usage

#*/30 * * * *   root /home/pi-star/SetNextionBrightness/setsrss.sh          
#This will run the script every 30 minutes. The script will detect DAY or NIGHT 
#and set the Screen Brightness if it changes from Day to Night or Night to Day


