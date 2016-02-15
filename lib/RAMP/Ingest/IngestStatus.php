<?php
/**
 * Created by PhpStorm.
 * User: jlittle
 * Date: 2/12/16
 * Time: 10:46 AM
 *
 *
 * Class to check for what ingests have been done on an EAC record (WorldCat, Viaf, etc)
 * It looks in the EAC's maintenance events to determine what's been done
 *
 *
 */

namespace RAMP\Ingest;


use RAMP\Util\Database;

class IngestStatus
{
    private $eac_xml_string;
    private $eac_xml_dom;

    public function __construct($eac_id, Database $db)
    {
        $db = Database::getInstance();
        $mysqli = $db->getConnection();

        $statement = $mysqli->prepare("SELECT eac_xml FROM ead_eac.eac WHERE eac_id = ?");
        $statement->bind_param("s",$eac_id);
        $statement->execute();
        $statement->bind_result($result);
        $statement->fetch();
        $this->eac_xml_string = $result;
        $this->eac_xml_dom = simplexml_load_string($result);
        $this->eac_xml_dom->registerXPathNamespace('eac','urn:isbn:1-931666-33-4');

        $statement->close();
    }

    public function ingestStatus($type) {
        $ingest_element =$this->eac_xml_dom->xpath("//eac:maintenanceHistory/eac:maintenanceEvent[eac:agent='{$type}']");
        if (empty($ingest_element)) {

            return array('type'=>$type, 'status'=>'false');

        } else {
            return array('type'=>$type, 'status'=>'true');
        }
    }


    public function allStatus() {
       $all_status = array($this->ingestStatus('ramp/viaf'), $this->ingestStatus('ramp/worldcat'), $this->ingestStatus('ramp/wiki'));
        return $all_status;
    }
}