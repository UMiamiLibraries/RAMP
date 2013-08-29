<?php
/* 

   This script returns an EAC-CPF XML record from the database. It finds the 
   record in the database by searching for the EAD file path. The file path 
   is used a foreign key that relates the EAC and EAC records.

   -- Jamie

*/
include('conf/db.php');

$eac = $_GET["eac"];

$mysqli = new mysqli($db_host, $db_user, $db_pass, $db_default, $db_port);
if ($mysqli->connect_errno) {
  echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}


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


?>