<?php
if ($_POST['eac_text']) {
    libxml_use_internal_errors(true);

    $eac = $_POST["eac_text"];

    $dom = new DOMDocument;
    $dom->loadXML($eac);

//Start the XSLT transfrom 
    $xslt = new XSLTProcessor;
    $xsl = new DOMDocument;

// Load the stylesheet 

    $xsl->load('../xsl/eac2wiki.xsl');
    $xslt->importStylesheet($xsl);


// Get the result 
    $xslt_result = $xslt->transformToXml($dom);
    echo $xslt_result = str_replace("        ", "", $xslt_result);
}