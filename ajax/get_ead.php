<?php
/**
 *   @file get_ead.php
 *   @brief echos xml for desired ead file
 *
 *   @author dgonzalez
 */

include('../conf/db.php');

	$lstrEADFile = $_POST["ead"];

	$lobjSQLi = new mysqli($db_host, $db_user, $db_pass, $db_default, $db_port);
	if ($lobjSQLi->connect_errno) {
		echo "Failed to connect to MySQL: (" . $lobjSQLi->connect_errno . ") " . $lobjSQLi->connect_error;
	}


	$lstrQuery = 'SELECT ead_xml FROM ead WHERE ead_file LIKE "%' . $lstrEADFile . '%"';

	$lobjResult = $lobjSQLi->query($lstrQuery);
	if (!$lobjResult) {
		printf("%s\n", $lobjSQLi->error);

	}

	$lobjRow = $lobjResult->fetch_row();

	echo ($lobjRow[0]);

	$lobjSQLi->close();
?>