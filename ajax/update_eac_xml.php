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

if (isset($_POST["xml"]) && $_POST["ead_file"]) {

  $eac = mysqli_real_escape_string($_POST["xml"]);
  $ead = mysqli_real_escape_string($_POST["ead_file"]);

  $sql = "UPDATE eac SET eac_xml = $eac WHERE ead_file LIKE '%$ead%'";

  $result = $mysqli->query($sql);

  if (!$result) {
    printf("%s\n", $mysqli->error);


  }
}