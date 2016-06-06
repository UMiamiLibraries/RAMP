<?php
namespace RAMP\Util;

/**
 * Created by PhpStorm.
 * User: jlittle
 * Date: 2/10/16
 * Time: 1:03 PM
 */

use RAMP\Interfaces\OutputInterface;
use RAMP\Xml\EadConvert;

class Uploader {

    private $xml;
    private $success = array("status" => "success");
    private $fail = array("status" => "fail");
    private $response;

 function __construct($files, EadConvert $ead_convert)
 {
    $this->xml = simplexml_load_file($files['ead']['tmp_name']);

     $response= $ead_convert->insert_into_db($files['ead']['tmp_name'],$files['ead']['tmp_name']);

    $this->last_insert_id = $ead_convert->last_id;

     if ($response == "Upload Successful") {
        $this->response = json_encode($this->success);
     } else {
         $this->response = json_encode($this->fail);
     }


 }
  public function getResponse() {
      return json_encode($this->response);
  }

  public function getLastInsertId() {
      return $this->last_insert_id;
  }

}