#!/usr/bin/php
<?php

function display_APRS() {
	$config = parse_ini_file('/etc/nextionbrightness', true);
	$apik = $config['General']['ApiKey']; 
	$call = $config['General']['Call']; 
//	print($call $apik);
//	print("\n");

	$json_url = "http://api.aprs.fi/api/get?apikey=${apik}&name=${call}&what=loc&format=json";
	$json = file_get_contents( $json_url, 0, null, null );

	$json_output = json_decode( $json, true);

	$station_array = $json_output[ 'entries' ];
	foreach ( $station_array as $station ) {
		$lat = $station[ 'lat' ];
		$lng = $station[ 'lng' ];
		echo "".$lat." ".$lng."\n";
	}

}

display_APRS();

?>
