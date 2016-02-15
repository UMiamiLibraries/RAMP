<?php
/**
 * Update EAC XML
 * 
 *
 *  Script that accepets a POST request for updating an EAC XML record in a database.
 *  Wiki markup in the database. 
 *
 * @author little9 (Jamie Little)
 * @copyright Copyright (c) 2013
 *
 */

include('../autoloader.php');

use RAMP\Util\Database;

$db = Database::getInstance();
$mysqli = $db->getConnection();

$eac = $_POST["xml"];
$ead = $_POST["ead_file"];

$sql = 'UPDATE eac SET eac_xml = ' . '"' . mysqli_real_escape_string($mysqli, $_POST["xml"]) . '"' . 'WHERE ead_file LIKE "%' . $_POST["ead_file"] . '%"';

$result = $mysqli->query($sql);

if (!$result) {
  printf("%s\n", $mysqli->error);


} 
