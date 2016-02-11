<?php
/**
 * Get wiki
 * 
 *
 *  This script returns an EAC-CPF XML record from the database. It finds the 
 *  record in the database by searching for the EAD file path. The file path 
 *  is used a foreign key that relates the EAC and EAC records.
 *
 * @author little9 (Jamie Little)
 * @copyright Copyright (c) 2013
 *
 **/


include('autoloader.php');

use RAMP\Util\Database;

$db = Database::getInstance();
$mysqli = $db->getConnection();

$eac = $_GET["eac"];

$sql = 'SELECT eac_xml,eac_id FROM eac WHERE ead_file LIKE "%' . $eac . '%"';


$result = $mysqli->query($sql);
if (!$result) {
  printf("%s\n", $mysqli->error);

} 

$row = $result->fetch_row();

$eac_dom = new DomDocument();
$eac_dom->loadXML($row[0]);
$xml_string = $row[0];

echo ($xml_string);

$mysqli->close();
