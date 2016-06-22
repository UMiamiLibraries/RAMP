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
    private $wiki_status;

    public function __construct($eac_id, Database $db)
    {
        $db = Database::getInstance();
        $mysqli = $db->getConnection();

        $statement = $mysqli->prepare("SELECT eac_xml FROM eac WHERE eac_id = ?");
        $statement->bind_param("s", $eac_id);
        $statement->execute();
        $statement->bind_result($result);
        $statement->fetch();
        $this->eac_xml_string = $result;
        $this->eac_xml_dom = simplexml_load_string($result);
        $this->eac_xml_dom->registerXPathNamespace('eac', 'urn:isbn:1-931666-33-4');

        $statement->close();

        $wiki_stmt = $mysqli->prepare("SELECT wiki_text FROM mediawiki WHERE eac_id = ?");
        $wiki_stmt->bind_param("s", $eac_id);
        $wiki_stmt->execute();
        $wiki_stmt->bind_result($result);
        $wiki_stmt->fetch();
        $wiki_stmt->close();

        if ($result != null) {
            $this->wiki_status = 'true';
        } else {
            $this->wiki_status = 'false';


        }
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
       $all_status = array("statuses" => array($this->ingestStatus('ramp/viaf'), $this->ingestStatus('ramp/worldcat'),array('type'=>'ramp/wiki', 'status'=>$this->wiki_status)));
        return $all_status;
    }
}
