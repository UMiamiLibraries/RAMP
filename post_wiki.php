<?php
/*

This script accepts a POST request that contains Wikimarkup and saves it to the database.
The wikimarkup is inserted with the EAD file path, which is used as foreign key to relate the markup with EAC and EAD records. 

-- Jamie

 */
include('conf/db.php');

$mysqli = new mysqli($db_host, $db_user, $db_pass, $db_default, $db_port);
if ($mysqli->connect_errno) {
  echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}

$media_wiki = mysqli_real_escape_string($mysqli,$_POST["media_wiki"]);
$ead_path = mysqli_real_escape_string($mysqli,$_POST["ead_path"]);

$sql = "CALL insert_wiki(\"$media_wiki\", \"$ead_path\")";

$result = $mysqli->query($sql);
if (!$result) {
  printf("%s\n", $mysqli->error);
  echo $sql;

} else {

	echo "Done";
}

$mysqli->close();

?>