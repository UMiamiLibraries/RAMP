<?php
/**
 * Created by PhpStorm.
 * User: jlittle
 * Date: 2/18/16
 * Time: 12:18 PM
 */

namespace RAMP\Xml;


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

}