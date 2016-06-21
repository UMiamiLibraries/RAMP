<?php
/**
 * Created by PhpStorm.
 * User: cbrownroberts
 * Date: 2/24/16
 * Time: 1:05 PM
 */
include('../autoloader.php');

use RAMP\Util\Database;


if ($_POST['editor_xml']) {
    libxml_use_internal_errors(true);

    //set xml
    $xml = $_POST['editor_xml'];

    //transform xml to wiki markup
    $dom = new DOMDocument;
    $dom->loadXML($xml);

    //Start the XSLT transfrom
    $xslt = new XSLTProcessor;
    $xsl = new DOMDocument;

    // Load the stylesheet
    $xsl->load('../xsl/eac2wiki.xsl');
    $xslt->importStylesheet($xsl);

    // Get the result
    $xslt_result = $xslt->transformToXml($dom);
    $xslt_result = str_replace("        ", "", $xslt_result);


    //save to db
    $db = Database::getInstance();
    $mysqli = $db->getConnection();


    $media_wiki = mysqli_real_escape_string($mysqli,$xslt_result);
    $ead_path = mysqli_real_escape_string($mysqli,$_POST["ead_path"]);


    $eac_id_sql = "SELECT eac_id from eac WHERE ead_file LIKE  CONCAT(\"%\",'$ead_path',\"%\")";

    $eac_id_result = $mysqli->query($eac_id_sql);
    if (!$eac_id_result) {
        printf("%s\n", $mysqli->error);

    }

    $eac_id_row = $eac_id_result->fetch_row();

    $eac_id = $eac_id_row['0'];


    $sql = "INSERT INTO mediawiki (wiki_text, eac_id) VALUES ('$media_wiki', '$eac_id') ON DUPLICATE KEY UPDATE wiki_text = '$media_wiki'";


    $result = $mysqli->query($sql);
    if (!$result) {
        printf("%s\n", $mysqli->error);
        echo $sql;

    } else {

        echo "Done";
    }

    $mysqli->close();

}