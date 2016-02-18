<?php
/**
 * validate
 * 
 *
 * This is a script that accepts a POST request containing EAC XML. It validates it 
 * and returns libxml's response as JSON. 
 *
 * @author little9 (Jamie Little)
 * @copyright Copyright (c) 2013
 *
 **/ 

include("../autoloader.php");

use RAMP\XML\Validator;

$eac_xml = $_POST["eac_xml"];

$validator = new Validator;
$validator->validate_eac_xml($eac_xml);
