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
    private $names;

    public function __construct(Database $db)

    {
        $this->db = Database::getInstance();
        $mysqli = $this->db->getConnection();

        $this->names = $mysqli->query("SELECT ead_file, CONCAT(ExtractValue(eac_xml, '//nameEntry[1]/part[1]'),', ',ExtractValue(eac_xml, '//nameEntry[1]/part[2]')) AS 'Name', substring_index(ead_file, '/', -1) AS 'SortHelp',
                            eac_id
							FROM eac
							ORDER BY CASE WHEN Name = '' THEN SortHelp ELSE Name END ASC");


    }

    public function getDropdown()
    {


        $mysqli = $this->db->getConnection();

        $results = $mysqli->query("SELECT ead_file, CONCAT(ExtractValue(eac_xml, '//nameEntry[1]/part[1]'),', ',ExtractValue(eac_xml, '//nameEntry[1]/part[2]')) AS 'Name', substring_index(ead_file, '/', -1) AS 'SortHelp'
							FROM eac
							ORDER BY CASE WHEN Name = '' THEN SortHelp ELSE Name END ASC");
        echo "<select class='ead_files '>";
        echo "<option>Select a name</option>";
        while ($row = $results->fetch_assoc()) {
            $name = $row["Name"];
            $file_name = $row["ead_file"];
            $file_name_display = htmlentities(basename($file_name));
            if ($row["Name"]) {
                print "<option value='$file_name'>" . rtrim($name, ', ') . "</option>";
            } else {
                print "<option value='$file_name'>$file_name_display</option>";
            }
        }
        print ("</select>");

    }

    public function getList()
    {
        foreach ($this->names as $name) {
            $ingest_status = new IngestStatus($name['eac_id'], $this->db);
            $name['ingest_status'] = $ingest_status->allStatus();
            array_push($this->record_list, $name);
        }

        return $this->record_list;
    }
}