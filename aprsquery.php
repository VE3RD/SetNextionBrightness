#!/usr/bin/php
<?php

function display_APRS() {
	$config = parse_ini_file('/etc/nextionbrightness', true);
	$apik = $config['General']['ApiKey']; 
	$call = $config['General']['Call']; 

	$json_url = "http://api.aprs.fi/api/get?apikey=${apik}&name=${call}&what=loc&format=json";
	$json = file_get_contents( $json_url, 0, null, null );

	$json_output = json_decode( $json, true);

	$station_array = $json_output[ 'entries' ];
	$station = $station_array[0];

//	foreach ( $station_array as $station ) {
		$lat = $station[ 'lat' ];
		$lng = $station[ 'lng' ];
		echo "".$lat." ".$lng."\n";

//	}

}

display_APRS();

?>
