<?php
use RAMP\Util\Database;
function exportZip() {

    $db = Database::getInstance();
    $mysqli = $db->getConnection();
    
    
    try {
        unlink('export/ramp-export.zip');
    } catch (Exception $e) {

    }
    
    $zip = new ZipArchive;
    $zip->open('export/ramp-export.zip', ZipArchive::CREATE);

    $results = $mysqli->query ("SELECT eac_xml FROM eac");
    $names = $mysqli->query ("SELECT ead_file, ExtractValue(eac_xml, '/descendant-or-self::part[1]') AS 'Name', substring_index(ead_file, '/', -1) FROM eac");

    while ($row = $results->fetch_assoc()) {
        $row2 = $names->fetch_assoc();

        $file_name = mysqli_real_escape_string($mysqli,$row2['Name']);
        $file_name_lower = strtolower(str_replace(' ', '_', $file_name));
        $file_name_lower = preg_replace('/[^a-zA-Z0-9-_]/', '', $file_name_lower);
        $file_name_lower = iconv('utf-8', "us-ascii//TRANSLIT", $file_name_lower);
        $file_name_lower = preg_replace('/[^a-zA-Z0-9-_\.]/', '', $file_name_lower);

        $zip->addFromString(strval($file_name_lower . ".xml"), $row['eac_xml']);

    }
    $zip->close();

};


