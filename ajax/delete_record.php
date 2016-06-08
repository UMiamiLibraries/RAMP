<?php
/**
 * Created by PhpStorm.
 * User: jlittle
 * Date: 6/6/16
 * Time: 11:18 AM
 */

header('Content-Type: application/json');

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
include('../autoloader.php');

use RAMP\Util\Database;

$db = Database::getInstance();

if (isset($_POST['eac_id'])) {
    $eac_id = (int)$_POST['eac_id'];
    $connection = $db->getConnection();
    $ead_file_query = $connection->query("SELECT eac.eac_id, ead.ead_id from eac,ead WHERE eac_id = $eac_id");
    $ead_row = $ead_file_query->fetch_row();
    $del_mediawiki_query = $connection->query("DELETE FROM mediawiki WHERE eac_id = $eac_id");
    $del_ead_query = $connection->query("DELETE FROM ead WHERE ead_id = '$ead_row[1])'");
    $del_eac_query = $connection->query("DELETE FROM eac WHERE eac_id = $eac_id");

    if (!$del_ead_query) {
       echo json_encode(array("status" => "There was an error deleting the record", "success" => false, "query" => "\"DELETE FROM ead WHERE ead_file = $ead_row[0]\""));
    } else {
        echo json_encode(array("status" => "Deleted EAC $eac_id", "success"=>true));
    }
}
