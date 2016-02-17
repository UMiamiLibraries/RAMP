<?php
/**
 * User: little9
 * Date: 2/16/16
 * Time: 7:02 PM
 *
 * Returns everything about a record stored in the database
 *
 */

namespace RAMP\Record;

use RAMP\Util\Database;
use RAMP\Interfaces\OutputInterface;


class Record implements OutputInterface
{

    private $eac_id;
    private $eac_xml;
    private $published;
    private $ead_file;
    private $updated;
    private $created;
    private $results;
    public function __construct($eac_id, Database $db)
    {

        $mysqli = $db->getConnection();

        $results = $mysqli->query("SELECT * FROM ead_eac.eac INNNER JOIN ead on ead_id WHERE eac_id = ead_id AND eac_id = " . (int) $eac_id);
        $this->results = $results->fetch_assoc();

    }

    public function toArray()
    {
        return $this->results;
    }

    public function toJSON()
    {
        return json_encode($this->results);
    }

}