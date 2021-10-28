#!/usr/bin/php
<?php

$lat = 0;
$lng = 0;
$mode = "Aprs";
// $err = false;
global $err;

$config2 = parse_ini_file('/etc/mmdvmhost', true);
$lat = $config2['Info']['Latitude']; 
$lng = $config2['Info']['Longitude']; 

$config = parse_ini_file('/etc/nextionbrightness', true); 
$apik = $config['General']['ApiKey']; 
$call = $config['General']['Call'];
$mode = $config['General']['Mode'];


function customError($errno, $errstr) {
  	global $lat, $lng;
  	echo "".$lat." ".$lng."", " MMDVM\n";
	die();
}

set_error_handler("customError");

function display_APRS() { 
  global $lat, $lng ;
	$config = parse_ini_file('/etc/nextionbrightness', true); 
	$apik = $config['General']['ApiKey']; 
	$call = $config['General']['Call'];
	$mode = $config['General']['Mode'];

	$json_url = "http://api.aprs.fi/api/get?apikey=${apik}&name=${call}&what=loc&format=json";
	$json = file_get_contents( $json_url, 0, null, null );
	
	$json_output = json_decode( $json, true);
	$station_array = $json_output[ 'entries' ];
	$station = $station_array[0];
	$lat = $station[ 'lat' ];
	$lng = $station[ 'lng' ];
  	echo "".$lat." ".$lng."", " Aprs\n";
}

function getlatlonfrommmdvm(){
  global $lat, $lng;
	$config2 = parse_ini_file('/etc/mmdvmhost', true);
	$lat = $config2['Info']['Latitude']; 
	$lng = $config2['Info']['Longitude']; 
	//	echo "".$lat." ".$lng."\n";
  	echo "".$lat." ".$lng."", " MMDVM\n";
}

if ($mode == "Aprs") {
	display_APRS();
}else {
 	getlatlonfrommmdvm();
}
?>
