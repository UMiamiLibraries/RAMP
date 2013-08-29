<?php
/*

This script accepts a GET request that searches the database
with the EAD path (the foreign key that relates EAD, EAC, and Wiki records in the database) and returns Wiki markup

-- Jamie 

*/
include('conf/db.php');

$ead_path = $_GET["ead_path"];

$mysqli = new mysqli($db_host, $db_user, $db_pass, $db_default, $db_port);
if ($mysqli->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}

$sql = "CALL get_wiki(\"$ead_path\")";


$result = $mysqli->query($sql);
if (!$result) {
  printf("%s\n", $mysqli->error);

} 

$row = $result->fetch_row();   


$wiki_markup =  $row[0];
echo($wiki_markup);

$mysqli->close();


?>