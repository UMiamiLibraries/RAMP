<?php
include('header.php');
use RAMP\Util\Uploader;
use RAMP\Xml\EadConvert;
use RAMP\Util\Database;

require_once('autoloader.php');
require_once('conf/includes.php');

?>

<?php
if(isset($_FILES['ead'])){

    $ead_convert = new EadConvert('none');
    $ead_convert->setAgency_code($agency_code);
    $ead_convert->setOther_agency_code($other_agency_code);
    $ead_convert->setAgency_name($agency_name);
    $ead_convert->setShortAgency_name($short_agency_name);
    $ead_convert->setServer_name($serverName);
    $ead_convert->setLocal_url($localURL);
    $ead_convert->setRepository_one($repositoryOne);
    $ead_convert->setRepository_two($repositoryTwo);
    $ead_convert->setEventDescDerive($eventDescDerive);
    $ead_convert->setEventDescRevise($eventDescRevise);
    $ead_convert->setEventDescCreate($eventDescCreate);
    $ead_convert->setEventDescExport($eventDescExport);


    $u = new Uploader($_FILES, $ead_convert);


//now convert eac xml to wiki markup and then insert it into db
    $db = Database::getInstance();
    $mysqli = $db->getConnection();

    $last_id = $u->getLastInsertId();

    $eac_xml_query = $mysqli->query("SELECT eac_xml FROM eac WHERE eac_id = '$last_id'");

    $eac_xml_result = $eac_xml_query->fetch_row();

    $eac_xml = $eac_xml_result['0'];

//transform xml to wiki markup
    $dom = new \DOMDocument();
    $dom->loadXML($eac_xml);

//Start the XSLT transfrom
    $xsltProcessor = new \XSLTProcessor();
    $xsl = new \DOMDocument();

// Load the stylesheet

    $xsl->load('../xsl/eac2wiki.xsl');
    $xsltProcessor->importStylesheet($xsl);


// Get the result
    $xslt_result = $xsltProcessor->transformToXml($dom);
    $xslt_result = str_replace("        ", "", $xslt_result);


    $media_wiki = mysqli_real_escape_string($mysqli,$xslt_result);


    $sql = "INSERT INTO mediawiki (wiki_text, eac_id) VALUES ('$media_wiki', '$last_id') ON DUPLICATE KEY UPDATE wiki_text = '$media_wiki'";

    $result = $mysqli->query($sql);
    if (!$result) {
        printf("%s\n", $mysqli->error);
        echo $sql;

    } else {
        echo "<div id=\"flash_message\"><div class=\"success-message\"><p>Success! You EAD file has been uploaded and converted into an EAC file.</p></div></div>";

    }

}
?>

    <div class="inner-area">

        <div class="pure-g">
            <div class="pure-u-1-1">
                <h1>Import or Upload EAD Files</h1>
                <p id="convert_message">On this page you can convert EAD files or import EAC-CPF files that you have
                    placed in the 'ead' folder during the install process.</p>
                <p> After importing you can export and download the records.</p>
            </div>
            <div class="pure-u-1-2">
                <strong>Upload an EAD</strong>
                <form enctype="multipart/form-data" method="POST">
                    <input type="hidden" name="MAX_FILE_SIZE" value="30000000"/>
                    <input name="ead" type="file"/><br>
                    <input type="submit" class="pure-button ramp-button" value="Upload EAD"/>
                </form>
            </div>


        </div> <!-- end pure-g -->

    </div>

<?php include('footer.php'); ?>