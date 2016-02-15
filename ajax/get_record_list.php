<?php
/**
 * Created by PhpStorm.
 * User: jlittle
 * Date: 2/12/16
 * Time: 2:20 PM
 */

use RAMP\Util\Database;
use RAMP\Util\RecordList;

require_once ('../autoloader.php');

$db = Database::getInstance();


$record_list = new RecordList($db);

echo json_encode($record_list->getList());