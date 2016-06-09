<?php
/**
 * Created by PhpStorm.
 * User: jlittle
 * Date: 2/18/16
 * Time: 12:18 PM
 */

namespace RAMP\XML;


class Validator
{
   public function validate_eac_xml($xml) {
   // This function validates an EAC XML file and returns either a notification that the file is valid or a JSON repsonse that has the errors
        $dom = new \DOMDocument;
        $dom->loadXML($xml);

        libxml_use_internal_errors(true);

        if ($dom->schemaValidate('../schema/cpf.xsd')) {

            // JavaScript is expecting JSON as a callback so return a JSON encoded array here
            $success = array (

                "status" => "valid"
            );

            echo json_encode($success);

        } else
        {

            // libxml_get_errors returns an array of the arrays
            $errors = json_encode(libxml_get_errors());
            echo $errors;

        }

    }
    

    /**
     * @param string $xmlFilename Path to the XML file
     * @param string $version 1.0
     * @param string $encoding utf-8
     * @return bool
     */
    public function isXMLFileValid($xmlFilename, $version = '1.0', $encoding = 'utf-8')
    {
        $xmlContent = file_get_contents($xmlFilename);
        return $this->isXMLContentValid($xmlContent, $version, $encoding);
    }

    /**
     * @param string $xmlContent A well-formed XML string
     * @param string $version 1.0
     * @param string $encoding utf-8
     * @return bool
     */
    public function isXMLContentValid($xmlContent, $version = '1.0', $encoding = 'utf-8')
    {
        if (trim($xmlContent) == '') {
            return false;
        }

        libxml_use_internal_errors(true);

        $doc = new \DOMDocument($version, $encoding);
        $doc->loadXML($xmlContent);

        $errors = libxml_get_errors();
        libxml_clear_errors();

        return empty($errors);
    }



    public function hasNameAttribute($xmlFilename) {

        $xmlContent = file_get_contents($xmlFilename);

        $doc = new \DOMDocument();
        $doc->loadXML($xmlContent);

        $persname = $doc->getElementsByTagName('persname')->length;
        $corpname = $doc->getElementsByTagName('corpname')->length;
        $famname  = $doc->getElementsByTagName('famname')->length;


        if($persname > 0) {
            $hasNameAttribute = true;
        } elseif($corpname > 0) {
            $hasNameAttribute = true;
        } elseif($famname > 0) {
            $hasNameAttribute = true;
        } else {
            $hasNameAttribute = false;
        }

        return $hasNameAttribute;
    }
}
