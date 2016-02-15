<?php
/**
 * Created by PhpStorm.
 * User: jlittle
 * Date: 2/10/16
 * Time: 2:04 PM
 */
header('Content-Type: application/json');

use RAMP\Util\Uploader;
use RAMP\Xml\EadConvert;

require_once('../autoloader.php');
require_once('../conf/includes.php');

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

echo $u->getResponse();

