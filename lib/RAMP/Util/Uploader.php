<?php
namespace RAMP\Util;

/**
 * Created by PhpStorm.
 * User: jlittle
 * Date: 2/10/16
 * Time: 1:03 PM
 */

use RAMP\Interfaces\OutputInterface;
use RAMP\XML\EadConvert;
use RAMP\XML\Validator;

class Uploader
{

    private $xml;
    private $success = array("status" => "success");
    private $fail = array("status" => "fail");
    private $response;

    function __construct($files, EadConvert $ead_convert)
    {
        //validate xml first
        $xmlFilename = $files['ead']['tmp_name'];
        $isValidXml = $this->validateXmlFile($xmlFilename);

        $hasNameAttribute = $this->getNameAttribute($xmlFilename);
        
        if ($isValidXml && $hasNameAttribute) {

            $this->xml = simplexml_load_file($files['ead']['tmp_name']);

            //insert valid xml into db
            $response = $ead_convert->insert_into_db($files['ead']['tmp_name'], $files['ead']['tmp_name']);

            $this->last_insert_id = $ead_convert->last_id;

            if ($response == "Upload Successful") {
                $this->response = json_encode($this->success);
            } else {
                $this->response = json_encode($this->fail);
            }


        } else {

            $this->response = 'XML is not valid. Please check the xml file for errors.';
        }


    }

    public function validateXmlFile($xmlFilename, $version = '1.0', $encoding = 'utf-8')
    {
        $validator = new Validator();
        $isValid = $validator->isXMLFileValid($xmlFilename, $version, $encoding);

        return $isValid;
    }

    public function getNameAttribute($xmlFilename) {

        $validator = new Validator();
        $nameAttribute = $validator->hasNameAttribute($xmlFilename);

        return $nameAttribute;
    }


    public function getResponse()
    {
        return json_encode($this->response);
    }

    public function getLastInsertId()
    {
        return $this->last_insert_id;
    }

}

