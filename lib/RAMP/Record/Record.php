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

        $results = $mysqli->query("SELECT eac.eac_id, eac.eac_xml, eac.published, eac.ead_file, eac.updated
AS 'eac_updated', eac.created AS 'eac_created', mediawiki.id as 'mediawiki_id',
mediawiki.wiki_text, mediawiki.created as 'mediawiki_created',
mediawiki.updated as 'mediawiki_updated', ead.ead_xml, ead.ead_id
FROM eac
LEFT JOIN mediawiki
ON eac.eac_id = mediawiki.eac_id
INNER JOIN ead
ON eac.ead_file = ead.ead_file
AND eac.eac_id =" . (int) $eac_id);
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