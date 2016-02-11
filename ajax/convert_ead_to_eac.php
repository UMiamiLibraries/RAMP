<?php
/*error_reporting(E_ALL);
ini_set('display_errors', '1');*/

use RAMP\Xml\EadConvert;
use RAMP\Xml\XsltTransform;
use RAMP\Util\Database;

require_once ('../autoloader.php');
require_once('../php-diff/lib/Diff.php');
require_once('../php-diff/lib/Diff/Renderer/Html/SideBySide.php');

include('../conf/includes.php');


if( isset($_GET['dir']) )
{
	$ead_convert = new EadConvert($_GET["dir"]);
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


	if(isset($_POST['files']))
	{
		if(count($_POST['files']) != 0)
			$ead_convert->setAllFiles($_POST['files']);
	}

	echo $ead_convert->process_files();
	//	$ead_convert->print_param();
}

?>