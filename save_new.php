<?php
/*

  This script accepts a POST request containing the data that the user wants to appear in a a new EAC record. It takes that data and creates a stub EAD record. Then it inserts that into the database. On the front-end, an ajax request is made to the EAD to EAC conversion class. Thus, you end up with a new EAD and EAC record in the database.

  -- Jamie

*/

include('conf/db.php');
include('conf/inst_info.php');
include('conf/includes.php');
include('classes/EadConvert.php');
include('classes/Database.php');
include('classes/XsltTransform.php');
include('php-diff/lib/Diff.php');
include('php-diff/lib/Diff/Renderer/Html/SideBySide.php');

$ramp_id = 'ramp-' . rand(0,10090294092942);

$mysqli = new mysqli($db_host, $db_user, $db_pass, $db_default, $db_port);
if ($mysqli->connect_errno) {
  echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}

$file_name = mysqli_real_escape_string($mysqli,$_POST["name"]);
$file_name_lower = strtolower(str_replace(' ', '_', $file_name));
$file_name_lower = preg_replace('/[^a-zA-Z0-9-_]/', '', $file_name_lower);

//make file name valid utf8
$file_name = iconv('utf-8', "us-ascii//TRANSLIT", $file_name);
$file_name = preg_replace('/[^a-zA-Z0-9-_\.]/', '', $file_name);

//personal name
$persname = mysqli_real_escape_string($mysqli,$_POST["name"]);
$entity =  mysqli_real_escape_string($mysqli,$_POST["entity"]);
$bioghist =  mysqli_real_escape_string($mysqli,$_POST["bioghist"]);

// instinfo
if (file_exists(  $_POST["dir"] . '/' . $file_name_lower . '.xml')) {

  echo "This record already exists.";

} else {

  touch(  $_POST["dir"] . '/' . $file_name_lower . '.xml');

  $f = fopen(  $_POST["dir"] . '/' . $file_name_lower . '.xml', "w");

  $ead_doc = new DOMDocument();
  $ead_doc->formatOutput = true;

  $type = $_POST['type'];

  switch($type) {

  case 'Person':
    try {
      $ead_doc->loadXML('<ead audience="external"
		     xmlns="urn:isbn:1-931666-22-9"
		     xmlns:xlink="http://www.w3.org/1999/xlink"
		     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		     xsi:schemaLocation="http://www.loc.gov/ead/ http://www.loc.gov/ead/ead.xsd">
		   <eadheader langencoding="iso639-2b" audience="external" countryencoding="iso3166-1" dateencoding="iso8601" repositoryencoding="iso15511" scriptencoding="iso15924" relatedencoding="MARC21">
		      <eadid encodinganalog="856$u" mainagencycode="' . $agency_code  . '" countrycode="US" identifier="' . $ramp_id . '"></eadid>
		      <filedesc>
		        <titlestmt>
		               <titleproper encodinganalog="245"></titleproper>
		                  </titlestmt>
		      </filedesc>
		</eadheader>
		<frontmatter>
		            </frontmatter>
		            <archdesc audience="external" relatedencoding="MARC21">
		               <did>
		                     <origination label="Creator" encodinganalog="245$c">
		                     <persname encodinganalog="100"  source="local">' . $persname .


			'</persname>
		                           </origination>
		      </did>
		               <bioghist encodinganalog="545">
		<p>' . $bioghist .
			'</p>
		                           </bioghist>


		   </archdesc>
		</ead>
		');
      // Try to load the ead file

    } catch(Exception $e) {
      die ('Caught exception: ' .  $e->getMessage() . "\n");
    }

    break;

  case 'Corporate Body':
    try {
      $ead_doc->loadXML('<ead audience="external"
		     xmlns="urn:isbn:1-931666-22-9"
		     xmlns:xlink="http://www.w3.org/1999/xlink"
		     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		     xsi:schemaLocation="http://www.loc.gov/ead/ http://www.loc.gov/ead/ead.xsd">
		   <eadheader langencoding="iso639-2b" audience="external" countryencoding="iso3166-1" dateencoding="iso8601" repositoryencoding="iso15511" scriptencoding="iso15924" relatedencoding="MARC21">
		      <eadid encodinganalog="856$u" mainagencycode="' . $agency_code  . '" countrycode="US" identifier="' . $ramp_id . '"></eadid>
		      <filedesc>
		        <titlestmt>
		               <titleproper encodinganalog="245"></titleproper>
		                  </titlestmt>
		      </filedesc>
		</eadheader>
		<frontmatter>
		            </frontmatter>
		            <archdesc audience="external" relatedencoding="MARC21">
		               <did>
		                     <origination label="Creator" encodinganalog="245$c">
		                     <corpname encodinganalog="100"  source="local">' . $persname .


			'</corpname>
		                           </origination>
		      </did>
		               <bioghist encodinganalog="545">
		<p>' . $bioghist .
			'</p>
		                           </bioghist>


		   </archdesc>
		</ead>
		');
    } catch(Exception $e) {
      die ('Caught exception: ' .  $e->getMessage() . "\n");
    }

    break;

  case 'Family':

    try{
      $ead_doc->loadXML('<ead audience="external"
		     xmlns="urn:isbn:1-931666-22-9"
		     xmlns:xlink="http://www.w3.org/1999/xlink"
		     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		     xsi:schemaLocation="http://www.loc.gov/ead/ http://www.loc.gov/ead/ead.xsd">
		   <eadheader langencoding="iso639-2b" audience="external" countryencoding="iso3166-1" dateencoding="iso8601" repositoryencoding="iso15511" scriptencoding="iso15924" relatedencoding="MARC21">
		      <eadid encodinganalog="856$u" mainagencycode="' . $agency_code  . '" countrycode="US" identifier="' . $ramp_id . '"></eadid>
		      <filedesc>
		        <titlestmt>
		               <titleproper encodinganalog="245"></titleproper>
		                  </titlestmt>
		      </filedesc>
		</eadheader>
		<frontmatter>
		            </frontmatter>
		            <archdesc audience="external" relatedencoding="MARC21">
		               <did>
		                     <origination label="Creator" encodinganalog="245$c">
		                     <famname  source="local">' . $persname . '</famname>
		                           </origination>
		      </did>
		               <bioghist encodinganalog="545">
		<p>' . $bioghist .
			'</p>
		                           </bioghist>


		   </archdesc>
		</ead>
		');
    } catch(Exception $e) {
      die ('Caught exception: ' .  $e->getMessage() . "\n");
    }

    break;
  }

  fwrite($f, $ead_doc->saveXML());

  $ead_convert = new EadConvert( $_POST["dir"] );
	$ead_convert->setAgency_code($agency_code);
	$ead_convert->setOther_agency_code($other_agency_code);
	$ead_convert->setAgency_name($agency_name);
	$ead_convert->setServer_name($serverName);
	$ead_convert->setLocal_url($localURL);
	$ead_convert->setRepository_one($repositoryOne);
	$ead_convert->setRepository_two($repositoryTwo);
	$ead_convert->setEventDescDerive($eventDescDerive);
    $ead_convert->setEventDescRevise($eventDescRevise);
	$ead_convert->setEventDescCreate($eventDescCreate);
	$ead_convert->setEventDescExport($eventDescExport);
	$ead_convert->setEventDescRAMP($eventDescRAMP);
  $ead_convert->new_eac( $file_name_lower );

  echo "Sucessfully created new record.";

}

?>