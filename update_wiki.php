<?php
/* 

This is a script that accepts a POST request for updating the 
Wiki markup in the database. 

   -- Jamie
*/


include('conf/db.php');

$mysqli = new mysqli($db_host, $db_user, $db_pass, $db_default, $db_port);
if ($mysqli->connect_errno) {
  echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}

$media_wiki = mysqli_real_escape_string($mysqli,$_POST["media_wiki"]);
$ead_path = mysqli_real_escape_string($mysqli,$_POST["ead_path"]);

$sql = "CALL update_wiki(\"$media_wiki\", \"$ead_path\")";

$result = $mysqli->query($sql);
if (!$result) {
  printf("%s\n", $mysqli->error);
  echo $sql;

} else {

  echo "Done";
}

$mysqli->close();

?>