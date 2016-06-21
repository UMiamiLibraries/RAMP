<?php
/**
 * Created by PhpStorm.
 * User: jlittle
 * Date: 6/6/16
 * Time: 12:10 PM
 */


ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
include('../autoloader.php');
use RAMP\Util\Database;

$db = Database::getInstance();
$connection = $db->getConnection();

if (isset($_GET['eac_id'])) {
    $eac_id = (int) $_GET['eac_id'];
    $ead_file_query = $connection->query("SELECT eac_xml FROM eac WHERE eac_id = $eac_id");


    header("Content-disposition: attachment; filename=ramp-eac-{$eac_id}.xml");
    header ("Content-Type:text/xml");

    echo $ead_file_query->fetch_row()[0];
}
