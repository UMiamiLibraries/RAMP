<?php
/**
 * Created by PhpStorm.
 * User: jlittle
 * Date: 2/12/16
 * Time: 2:18 PM
 */

namespace RAMP\Util;



use RAMP\Ingest\IngestStatus;

class RecordList

{
    private $record_list = array();
    private $db;

    public function __construct(Database $db)

    {
        $this->db = Database::getInstance();
        $mysqli = $this->db->getConnection();

        $this->names = $mysqli->query ("SELECT ead_file, CONCAT(ExtractValue(eac_xml, '//nameEntry[1]/part[1]'),', ',ExtractValue(eac_xml, '//nameEntry[1]/part[2]')) AS 'Name', substring_index(ead_file, '/', -1) AS 'SortHelp',
                            eac_id
							FROM eac
							ORDER BY CASE WHEN Name = '' THEN SortHelp ELSE Name END ASC");


    }

    public function getList() {
        foreach(  $this->names as $name) {
            $ingest_status = new IngestStatus($name['eac_id'], $this->db);
            $name['ingest_status'] = $ingest_status->allStatus();
            array_push($this->record_list, $name);
        }

        return $this->record_list;
    }
}