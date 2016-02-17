<?php
/**
 * Created by PhpStorm.
 * User: jamie
 * Date: 2/16/16
 * Time: 7:12 PM
 */

header('Content-Type: application/json');

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include('../autoloader.php');

use RAMP\Util\Database;
use RAMP\Record\Record;
use RAMP\Ingest\IngestStatus;


$db = Database::getInstance();


$ingest_status = new IngestStatus((int) $_GET['eac_id'],$db);

$r = new Record($_GET['eac_id'], $db);
echo json_encode(array_merge($ingest_status->allStatus(), $r->toArray()));