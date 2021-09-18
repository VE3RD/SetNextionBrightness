# SetNextionBrightness
## Under Construction

  This script requires the installation of sunwait
  
  Installation:    
sudo apt-get install sunwait
cd sunwait
rpi-rw
sudo cp sunwait /usr/local/bin/

This Script will set the Nextion Screen Brightness high or low (values are set in the script)      
dval=99  ## Daytime Value of [Nextion] Brightness and IdleBrightness     
nval=10  ## Night time Value of [Nextion] Brightness and IdleBrightness     

Either the Lat/Long provided as a parameter ot the MMDVMHost location will be used to find the sunrise/sunset times

syntax:   ./setsrss.sh     // will use the location values in /etc/mmdvmhost      
syntax:   ./setsrss.sh  43.000N 79.000W   // will use the provided gps coordinates    

Cron Usage

#* 3 * * *   root /home/pi-star/SetNextionBrightness/setsrss.sh 1          
#This will run the script at 3am. The script will wait until dawn to raise the screen brightness

#* 16 * * * root /home/pi-star/SetNextionBrightness/setsrss.sh 2             
#This will run the script at 4pm. The script will wait until sunset to lower the screen brightness
