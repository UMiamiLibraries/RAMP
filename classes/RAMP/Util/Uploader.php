<?php
namespace RAMP\Util;

/**
 * Created by PhpStorm.
 * User: jlittle
 * Date: 2/10/16
 * Time: 1:03 PM
 */

use RAMP\Interfaces\OutputInterface;
use RAMP\Util\EadConvert;

class Uploader {

    private $xml;
    private $file_name;

 function __construct($files)
 {
    $this->xml = simplexml_load_file($_FILES['file']['tmp_name']);

     $ead_convert = new EadConvert('none');
     $ead_convert->insert_into_db($_FILES['file']['tmp_name'],$_FILES['file']['tmp_name']);



 }




}