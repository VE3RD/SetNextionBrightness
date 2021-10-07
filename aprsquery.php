#!/usr/bin/php
<?php

$apik = '91808.CBPlPnzVUvPt3kk&name';
$calls = 'KB5RIR-14';

	$json_url = "http://api.aprs.fi/api/get?apikey=${apik}&name=${calls}&what=loc&format=json";
	$json = file_get_contents( $json_url, 0, null, null );
	$json_output = json_decode( $json, true);

	$station_array = $json_output[ 'entries' ];
	foreach ( $station_array as $station ) {
		$lat = $station[ 'lat' ];
		$lng = $station[ 'lng' ];
		echo "".$lat." ".$lng."\n";
	}

?>
