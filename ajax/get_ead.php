<?php
/**
 *   @file get_ead.php
 *   @brief echos xml for desired ead file
 *
 *   @author dgonzalez
 */

require_once('../autoloader.php');

use RAMP\Util\Database;

$db = Database::getInstance();
$mysqli = $db->getConnection();

	$lstrEADFile = $_POST["ead"];

	$lstrQuery = 'SELECT ead_xml FROM ead WHERE ead_file LIKE "%' . $lstrEADFile . '%"';

	$lobjResult = $mysqli->query($lstrQuery);
	if (!$lobjResult) {
		printf("%s\n", $mysqli->error);

	}

	$lobjRow = $lobjResult->fetch_row();

	echo ($lobjRow[0]);

	$mysqli->close();
?>