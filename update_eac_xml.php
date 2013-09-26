<?php
/* 

This is a script that accepets a POST request for updating an EAC XML record in a database.

   -- Jamie
*/

include('conf/db.php');

$eac = $_POST["xml"];
$ead = $_POST["ead_file"];


$mysqli = new mysqli($db_host, $db_user, $db_pass, $db_default, $db_port);
if ($mysqli->connect_errno) {
  echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}

$sql = 'UPDATE eac SET eac_xml = ' . '"' . mysqli_real_escape_string($mysqli, $_POST["xml"]) . '"' . 'WHERE ead_file LIKE "%' . $_POST["ead_file"] . '%"';



$result = $mysqli->query($sql);

if (!$result) {
  printf("%s\n", $mysqli->error);


} 


?>