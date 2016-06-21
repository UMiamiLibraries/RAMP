<?php
header('Content-Type: application/json');

use RAMP\Ingest\IngestStatus;
use RAMP\Util\Database;

require_once ('../autoloader.php');

$db = Database::getInstance();

$ingest_status = new IngestStatus((int) $_GET['eac_id'],$db);
echo json_encode($ingest_status->allStatus());