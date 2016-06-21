<?php
/**
 * Post wiki
 * 
 *
 * 
 *This script accepts a POST request that contains Wikimarkup and saves it to the database.
 *The wikimarkup is inserted with the EAD file path, which is used as foreign key to relate * the markup with EAC and EAD records.  
 *
 * @author little9 (Jamie Little)
 * @copyright Copyright (c) 2013
 *
 */


include('../autoloader.php');

use RAMP\Util\Database;

$db = Database::getInstance();
$mysqli = $db->getConnection();

$media_wiki = $mysqli->real_escape_string($_POST["media_wiki"]);
$ead_path = $mysqli->real_escape_string($_POST["ead_path"]);

$eac_id_sql = "SELECT eac_id from eac WHERE ead_file LIKE  CONCAT(\"%\",'$ead_path',\"%\")";

$eac_id_result = $mysqli->query($eac_id_sql);
if (!$eac_id_result) {
  printf("%s\n", $mysqli->error);

} 


$eac_id_row = $eac_id_result->fetch_row();

$eac_id = $eac_id_row['0'];

$insert_sql = "INSERT INTO mediawiki (wiki_text,eac_id) VALUES ('$media_wiki', '$eac_id')
ON DUPLICATE KEY UPDATE mediawiki.wiki_text = '$media_wiki'";


$result = $mysqli->query($insert_sql);
if (!$result) {
  printf("%s\n", $mysqli->error);
  echo $sql;

} else {

	echo "Done";
}

$mysqli->close();
