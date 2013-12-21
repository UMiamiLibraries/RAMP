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

$ramp_id = 'RAMP-' . rand(0,10090294092942);

$mysqli = new mysqli($db_host, $db_user, $db_pass, $db_default, $db_port);
if ($mysqli->connect_errno) {
  echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}

// Basic input validation
$cleanedArray = array();
$cleanedArray = $_POST;

stripslashes_array($cleanedArray, $mysqli);

// Set array counters.
$countGenders = sizeof($cleanedArray['genders']);
$countGenderDatesFrom = sizeof($cleanedArray['genderDatesFrom']);
$countGenderDatesTo = sizeof($cleanedArray['genderDatesTo']);
$countLangNames = sizeof($cleanedArray['langNames']);
$countLangCodes = sizeof($cleanedArray['langCodes']);
$countScriptNames = sizeof($cleanedArray['scriptNames']);
$countScriptCodes = sizeof($cleanedArray['scriptCodes']);
$countSubjects = sizeof($cleanedArray['subjects']);
$countGenres = sizeof($cleanedArray['genres']);
$countOccupations = sizeof($cleanedArray['occupations']);
$countOccuDatesFrom = sizeof($cleanedArray['occuDatesFrom']);
$countOccuStandardFrom = sizeof($cleanedArray['occuStandardFrom']);
$countOccuDatesTo = sizeof($cleanedArray['occuDatesTo']);
$countOccuStandardTo = sizeof($cleanedArray['occuStandardTo']);
$countPlaceEntries = sizeof($cleanedArray['placeEntries']);
$countPlaceRoles = sizeof($cleanedArray['placeRoles']);
$countPlaceDatesFrom = sizeof($cleanedArray['placeDatesFrom']);
$countPlaceStandardFrom = sizeof($cleanedArray['placeStandardFrom']);
$countPlaceDatesTo = sizeof($cleanedArray['placeDatesTo']);
$countPlaceStandardTo = sizeof($cleanedArray['placeStandardTo']);
$countCitations = sizeof($cleanedArray['citations']);
$countCpfTypes = sizeof($cleanedArray['cpfTypes']);
$countCpfRoles = sizeof($cleanedArray['cpfRoles']);
$countCpfs = sizeof($cleanedArray['cpfs']);
$countCpfIDs = sizeof($cleanedArray['cpfIDs']);
$countCpfURIs = sizeof($cleanedArray['cpfURIs']);
$countCpfNotes = sizeof($cleanedArray['cpfNotes']);
$countResourceTypes = sizeof($cleanedArray['resourceTypes']);
$countResourceRoles = sizeof($cleanedArray['resourceRoles']);
$countResources = sizeof($cleanedArray['resources']);
$countResourceCreators = sizeof($cleanedArray['resourceCreators']);
$countResourceIDs = sizeof($cleanedArray['resourceIDs']);
$countResourceURIs = sizeof($cleanedArray['resourceURIs']);
$countResourceNotes = sizeof($cleanedArray['resourceNotes']);
$countSources = sizeof($cleanedArray['sources']);

// Create name variables;
$surname = $cleanedArray["surname"];
$forename =  $cleanedArray["forename"];
$noPartName = $cleanedArray["noPartsName"];
$corpName = $cleanedArray["corpName"];
$famName = $cleanedArray["famName"];

//make file name valid utf8
if ($surname != '') {    
               
    $file_name = $surname;
    
    if ($forename != '') {                
     
        $file_name .= ' ';
        $file_name .= $cleanedArray["forename"];
          
    }
           
}
elseif ($forename != '') {    
               
    $file_name = $forename;        
           
}  

elseif ($noPartName != '') {
    
    $file_name = $cleanedArray["noPartsName"];

}

elseif ($corpName != '') {
    
    $file_name = $cleanedArray["corpName"];

}

elseif ($famName != '') {
    
    $file_name = $cleanedArray["famName"];

}

$file_name_lower = strtolower(str_replace(' ', '_', $file_name));
$file_name_lower = preg_replace('/[^a-zA-Z0-9-_]/', '', $file_name_lower);
$file_name_lower = iconv('utf-8', "us-ascii//TRANSLIT", $file_name_lower);
$file_name_lower = preg_replace('/[^a-zA-Z0-9-_\.]/', '', $file_name_lower);

// New arrays for multivalue form elements.
$gender = array();
$genderDateFrom = array();
$genderDateTo = array();
$langName = array();
$langCode = array();
$scriptName = array();
$scriptCode = array();
$subject = array();
$genre = array();
$occupation = array();
$occuDateFrom = array();
$occuStandardFrom = array();
$occuDateTo = array();
$occuStandardTo = array();
$placeEntry = array();
$placeRole = array();
$placeDateFrom = array();
$placeStandardFrom = array();
$placeDateTo = array();
$placeStandardTo = array();
$citation = array();
$cpfType = array();
$cpfRole = array();
$cpf = array();
$cpfID = array();
$cpfURI = array();
$cpfNote = array();
$resourceType = array();
$resourceRole = array();
$resource = array();
$resourceCreator = array();
$resourceID = array();
$resourceURI = array();
$resourceNote = array();
$source = array();

// Assign variables to cleaned array.
$type = $cleanedArray["type"];
$entity = $cleanedArray["entity"];
$nameAuth = $cleanedArray["nameAuth"];
$from = $cleanedArray["from"];
$standardFrom = $cleanedArray["standardFrom"];
$to = $cleanedArray["to"];
$standardTo = $cleanedArray["standardTo"];
$gender = $cleanedArray["genders"];
$genderDateFrom = $cleanedArray["genderDatesFrom"];
$genderDateTo = $cleanedArray["genderDatesTo"];
$langName = $cleanedArray["langNames"];
$langCode = $cleanedArray["langCodes"];
$scriptName = $cleanedArray["scriptNames"];
$scriptCode = $cleanedArray["scriptCodes"];
$subject = $cleanedArray["subjects"];
$genre = $cleanedArray["genres"];
$occupation = $cleanedArray["occupations"];
$occuDateFrom = $cleanedArray["occuDatesFrom"];
$occuStandardFrom = $cleanedArray["occuStandardFrom"];
$occuDateTo = $cleanedArray["occuDatesTo"];
$occuStandardTo = $cleanedArray["occuStandardTo"];
$placeEntry = $cleanedArray["placeEntries"];
$placeRole = $cleanedArray["placeRoles"];
$placeDateFrom = $cleanedArray["placeDatesFrom"];
$placeStandardFrom = $cleanedArray["placeStandardFrom"];
$placeDateTo = $cleanedArray["placeDatesTo"];
$placeStandardTo = $cleanedArray["placeStandardTo"];
$abstract = $cleanedArray["abstract"];

if ($cleanedArray["bioghist"] == '') {
    $bioghist = "<p></p>";
}
else
{
    $bioghist = $cleanedArray["bioghist"];
}

$citation = $cleanedArray["citations"];
$cpfType = $cleanedArray["cpfTypes"];
$cpfRole = $cleanedArray["cpfRoles"];
$cpf = $cleanedArray["cpfs"];
$cpfID = $cleanedArray["cpfIDs"];
$cpfURI = $cleanedArray["cpfURIs"];
$cpfNote = $cleanedArray["cpfNotes"];
$resourceType = $cleanedArray["resourceTypes"];
$resourceRole = $cleanedArray["resourceRoles"];
$resource = $cleanedArray["resources"];
$resourceCreator = $cleanedArray["resourceCreators"];
$resourceID = $cleanedArray["resourceIDs"];
$resourceURI = $cleanedArray["resourceURIs"];
$resourceNote = $cleanedArray["resourceNotes"];
$source = $cleanedArray["sources"];

// Create XML elements to insert into faux EAD.

$genderVal = '';

for ($i = 0; $i < $countGenders; $i++) {
  $genderVal .= "<note type='gender' label='_" . $i . "'><p>";
  $genderVal .= $gender[$i];
  $genderVal .= "</p></note>";
}

$genderDateFromVal = '';

for ($i = 0; $i < $countGenderDatesFrom; $i++) {
  $genderDateFromVal .= "<note type='genderDateFrom' label='_" . $i . "'><p>";
  $genderDateFromVal .= $genderDateFrom[$i];
  $genderDateFromVal .= "</p></note>";
}

$genderDateToVal = '';

for ($i = 0; $i < $countGenderDatesTo; $i++) {
  $genderDateToVal .= "<note type='genderDateTo' label='_" . $i . "'><p>";
  $genderDateToVal .= $genderDateTo[$i];
  $genderDateToVal .= "</p></note>";
}

$langNameVal = '';

for ($i = 0; $i < $countLangNames; $i++) {
  $langNameVal .= "<note type='langName' label='_" . $i . "'><p>";
  $langNameVal .= $langName[$i];
  $langNameVal .= "</p></note>";
}

$langCodeVal = '';

for ($i = 0; $i < $countLangCodes; $i++) {
  $langCodeVal .= "<note type='langCode' label='_" . $i . "'><p>";
  $langCodeVal .= $langCode[$i];
  $langCodeVal .= "</p></note>";
}

$scriptNameVal = '';

for ($i = 0; $i < $countScriptNames; $i++) {
  $scriptNameVal .= "<note type='scriptName' label='_" . $i . "'><p>";
  $scriptNameVal .= $scriptName[$i];
  $scriptNameVal .= "</p></note>";
}

$scriptCodeVal = '';

for ($i = 0; $i < $countScriptCodes; $i++) {
  $scriptCodeVal .= "<note type='scriptCode' label='_" . $i . "'><p>";
  $scriptCodeVal .= $scriptCode[$i];
  $scriptCodeVal .= "</p></note>";
}

$subjectVal = '';

for ($i = 0; $i < $countSubjects; $i++) {
  $subjectVal .= "<note type='subject' label='_" . $i . "'><p>";
  $subjectVal .= $subject[$i];
  $subjectVal .= "</p></note>";
}

$genreVal = '';

for ($i = 0; $i < $countGenres; $i++) {
  $genreVal .= "<note type='genre' label='_" . $i . "'><p>";
  $genreVal .= $genre[$i];
  $genreVal .= "</p></note>";
}

$occupationVal = '';

for ($i = 0; $i < $countOccupations; $i++) {
  $occupationVal .= "<note type='occupation' label='_" . $i . "'><p>";
  $occupationVal .= $occupation[$i];
  $occupationVal .= "</p></note>";
}

$occuDateFromVal = '';

for ($i = 0; $i < $countOccuDatesFrom; $i++) {
  $occuDateFromVal .= "<note type='occuDateFrom' label='_" . $i . "'><p>";
  $occuDateFromVal .= $occuDateFrom[$i];
  $occuDateFromVal .= "</p></note>";
}

$occuStandardFromVal = '';

for ($i = 0; $i < $countOccuStandardFrom; $i++) {
  $occuStandardFromVal .= "<note type='occuStandardFrom' label='_" . $i . "'><p>";
  $occuStandardFromVal .= $occuStandardFrom[$i];
  $occuStandardFromVal .= "</p></note>";
}

$occuDateToVal = '';

for ($i = 0; $i < $countOccuDatesTo; $i++) {
  $occuDateToVal .= "<note type='occuDateTo' label='_" . $i . "'><p>";
  $occuDateToVal .= $occuDateTo[$i];
  $occuDateToVal .= "</p></note>";
}

$occuStandardToVal = '';

for ($i = 0; $i < $countOccuStandardTo; $i++) {
  $occuStandardToVal .= "<note type='occuStandardTo' label='_" . $i . "'><p>";
  $occuStandardToVal .= $occuStandardTo[$i];
  $occuStandardToVal .= "</p></note>";
}

$placeEntryVal = '';

for ($i = 0; $i < $countPlaceEntries; $i++) {
  $placeEntryVal .= "<note type='placeEntry' label='_" . $i . "'><p>";
  $placeEntryVal .= $placeEntry[$i];
  $placeEntryVal .= "</p></note>";
}

$placeRoleVal = '';

for ($i = 0; $i < $countPlaceRoles; $i++) {
  $placeRoleVal .= "<note type='placeRole' label='_" . $i . "'><p>";
  $placeRoleVal .= $placeRole[$i];
  $placeRoleVal .= "</p></note>";
}

$placeDateFromVal = '';

for ($i = 0; $i < $countPlaceDatesFrom; $i++) {
  $placeDateFromVal .= "<note type='placeDateFrom' label='_" . $i . "'><p>";
  $placeDateFromVal .= $placeDateFrom[$i];
  $placeDateFromVal .= "</p></note>";
}

$placeStandardFromVal = '';

for ($i = 0; $i < $countPlaceStandardFrom; $i++) {
  $placeStandardFromVal .= "<note type='placeStandardFrom' label='_" . $i . "'><p>";
  $placeStandardFromVal .= $placeStandardFrom[$i];
  $placeStandardFromVal .= "</p></note>";
}

$placeDateToVal = '';

for ($i = 0; $i < $countPlaceDatesTo; $i++) {
  $placeDateToVal .= "<note type='placeDateTo' label='_" . $i . "'><p>";
  $placeDateToVal .= $placeDateTo[$i];
  $placeDateToVal .= "</p></note>";
}

$placeStandardToVal = '';

for ($i = 0; $i < $countPlaceStandardTo; $i++) {
  $placeStandardToVal .= "<note type='placeStandardTo' label='_" . $i . "'><p>";
  $placeStandardToVal .= $placeStandardTo[$i];
  $placeStandardToVal .= "</p></note>";
}

$citationVal = '';

for ($i = 0; $i < $countCitations; $i++) {
  $citationVal .= "<note type='citation' label='_" . $i . "'><p>";
  $citationVal .= $citation[$i];
  $citationVal .= "</p></note>";
}

$cpfTypeVal = '';

for ($i = 0; $i < $countCpfTypes; $i++) {
  $cpfTypeVal .= "<note type='cpfType' label='_" . $i . "'><p>";
  $cpfTypeVal .= $cpfType[$i];
  $cpfTypeVal .= "</p></note>";
}

$cpfRoleVal = '';

for ($i = 0; $i < $countCpfRoles; $i++) {
  $cpfRoleVal .= "<note type='cpfRole' label='_" . $i . "'><p>";
  $cpfRoleVal .= $cpfRole[$i];
  $cpfRoleVal .= "</p></note>";
}

$cpfVal = '';

for ($i = 0; $i < $countCpfs; $i++) {
  $cpfVal .= "<note type='cpf' label='_" . $i . "'><p>";
  $cpfVal .= $cpf[$i]; 
  $cpfVal .= "</p></note>";
}

$cpfIDVal = '';

for ($i = 0; $i < $countCpfIDs; $i++) {
  $cpfIDVal .= "<note type='cpfID' label='_" . $i . "'><p>";
  $cpfIDVal .= $cpfID[$i];
  $cpfIDVal .= "</p></note>";
}


$cpfURIVal = '';

for ($i = 0; $i < $countCpfURIs; $i++) {
  $cpfURIVal .= "<note type='cpfURI' label='_" . $i . "'><p>";
  $cpfURIVal .= $cpfURI[$i];
  $cpfURIVal .= "</p></note>";
}

$cpfNoteVal = '';

for ($i = 0; $i < $countCpfNotes; $i++) {
  $cpfNoteVal .= "<note type='cpfNote' label='_" . $i . "'><p>";
  $cpfNoteVal .= $cpfNote[$i];
  $cpfNoteVal .= "</p></note>";
}

$resourceTypeVal = '';

for ($i = 0; $i < $countResourceTypes; $i++) {
  $resourceTypeVal .= "<note type='resourceType' label='_" . $i . "'><p>";
  $resourceTypeVal .= $resourceType[$i];
  $resourceTypeVal .= "</p></note>";
}

$resourceRoleVal = '';

for ($i = 0; $i < $countResourceRoles; $i++) {
  $resourceRoleVal .= "<note type='resourceRole' label='_" . $i . "'><p>";
  $resourceRoleVal .= $resourceRole[$i];
  $resourceRoleVal .= "</p></note>";
}

$resourceVal = '';

for ($i = 0; $i < $countResources; $i++) {
  $resourceVal .= "<note type='resource' label='_" . $i . "'><p>";
  $resourceVal .= $resource[$i];
  $resourceVal .= "</p></note>";
}

$resourceCreatorVal = '';

for ($i = 0; $i < $countResourceCreators; $i++) {
  $resourceCreatorVal .= "<note type='resourceCreator' label='_" . $i . "'><p>";
  $resourceCreatorVal .= $resourceCreator[$i];
  $resourceCreatorVal .= "</p></note>";
}

$resourceIDVal = '';

for ($i = 0; $i < $countResourceIDs; $i++) {
  $resourceIDVal .= "<note type='resourceID' label='_" . $i . "'><p>";
  $resourceIDVal .= $resourceID[$i];
  $resourceIDVal .= "</p></note>";
}

$resourceURIVal = '';

for ($i = 0; $i < $countResourceURIs; $i++) {
  $resourceURIVal .= "<note type='resourceURI' label='_" . $i . "'><p>";
  $resourceURIVal .= $resourceURI[$i];
  $resourceURIVal .= "</p></note>";
}

$resourceNoteVal = '';

for ($i = 0; $i < $countResourceNotes; $i++) {
  $resourceNoteVal .= "<note type='resourceNote' label='_" . $i . "'><p>";
  $resourceNoteVal .= $resourceNote[$i];
  $resourceNoteVal .= "</p></note>";
}

$sourceVal = '';

for ($i = 0; $i < $countSources; $i++) {
  $sourceVal .= "<note type='source' label='_" . $i . "'><p>";
  $sourceVal .= $source[$i];
  $sourceVal .= "</p></note>";
}

// Check name.
// Exit and return message if file name is empty or no entity type selected.
if (file_exists(  $_POST["dir"] . '/' . $file_name_lower . '.xml')) {

  echo "A record with this name already exists.";
  
  $_POST = array();

}
elseif( $file_name_lower == "" ) {    
	
	echo "Record not saved. File name is empty.";	
	
	if( $cleanedArray["entity"] == "" ) {
	   echo " You must also choose an entity type.";	   
    }
    
    $_POST = array();
    
}
elseif( $cleanedArray["entity"] == "" ) {
    
    echo "Record not saved. Must choose an entity type.";	
    
    $_POST = array();
    
} else {
  touch(  $_POST["dir"] . '/' . $file_name_lower . '.xml');

  $f = fopen(  $_POST["dir"] . '/' . $file_name_lower . '.xml', "w");

  $ead_doc = new DOMDocument();
  $ead_doc->formatOutput = true;

  // Create faux EADs.
  switch(strtolower( $type )) {

  case 'person':
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
		            <archdesc audience="external" relatedencoding="MARC21" level="otherlevel">
		               <did>
		                     <origination label="Creator" encodinganalog="245$c">
		                         <persname encodinganalog="100">' . $noPartName . '</persname>
		                         <persname encodinganalog="100_1">' . $surname . '</persname>
		                         <persname encodinganalog="100_0">' . $forename . '</persname>
		                     </origination>
		                           <note type="creation"><p>Record created in RAMP.</p></note>		                           
		                           <note type="nameAuth"><p>' .
		                           $nameAuth .
		                           '</p></note>
                                   <note type="from"><p>' .
		                           $from .
		                           '</p></note>' .
		                           '<note type="to"><p>' .
		                           $to .
		                           '</p></note>
		                           <note type="standardFrom"><p>' .
		                           $standardFrom .
		                           '</p></note>' .
		                           '<note type="standardTo"><p>' .
		                           $standardTo .
		                           '</p></note>' .
		                           $genderVal .
		                           $genderDateFromVal .
		                           $genderDateToVal .
		                           $langNameVal .
		                           $langCodeVal .
		                           $scriptNameVal .
		                           $scriptCodeVal .
		                           $subjectVal .
		                           $genreVal .
		                           $occupationVal .
		                           $occuDateFromVal .
		                           $occuStandardFromVal .
		                           $occuDateToVal .
		                           $occuStandardToVal .
		                           $placeRoleVal .
		                           $placeEntryVal .
		                           $placeDateFromVal .
		                           $placeStandardFromVal .
		                           $placeDateToVal .
		                           $placeStandardToVal .
		                           $citationVal .		                           
		                           $cpfVal .
		                           $cpfTypeVal .
		                           $cpfRoleVal .
		                           $cpfIDVal .
		                           $cpfURIVal .
		                           $cpfNoteVal .		                           
		                           $resourceVal .
		                           $resourceCreatorVal .
		                           $resourceTypeVal .
		                           $resourceRoleVal .
		                           $resourceIDVal .
		                           $resourceURIVal .
		                           $resourceNoteVal .
		                           $sourceVal .

		                           '<abstract>' . $abstract . '</abstract>
		                           </did>
		               <bioghist encodinganalog="545">' . $bioghist . '</bioghist>
		   </archdesc>
		</ead>
		');
      // Try to load the ead file

    } catch(Exception $e) {
      die ('Caught exception: ' .  $e->getMessage() . "\n");
    }

    break;

  case 'corporate body':
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
		            <archdesc audience="external" relatedencoding="MARC21" level="otherlevel">
		               <did>
		                     <origination label="Creator" encodinganalog="245$c">
		                     <corpname encodinganalog="110">' . $corpName . '</corpname>
		                           </origination>
		                           <note type="creation"><p>Record created in RAMP.</p></note>
                                   <note type="nameAuth"><p>' .
		                           $nameAuth .
		                           '</p></note>
                                   <note type="from"><p>' .
		                           $from .
		                           '</p></note>' .
		                           '<note type="to"><p>' .
		                           $to .
		                           '</p></note>
		                           <note type="standardFrom"><p>' .
		                           $standardFrom .
		                           '</p></note>' .
		                           '<note type="standardTo"><p>' .
		                           $standardTo .
		                           '</p></note>' .		                           
		                           $langNameVal .
		                           $langCodeVal .
		                           $scriptNameVal .
		                           $scriptCodeVal .
		                           $subjectVal .
		                           $genreVal .
		                           $occupationVal .
		                           $occuDateFromVal .
		                           $occuStandardFromVal .
		                           $occuDateToVal .
		                           $occuStandardToVal .
		                           $placeRoleVal .
		                           $placeEntryVal .
		                           $placeDateFromVal .
		                           $placeStandardFromVal .
		                           $placeDateToVal .
		                           $placeStandardToVal .
		                           $citationVal .		                           
		                           $cpfVal .
		                           $cpfTypeVal .
		                           $cpfRoleVal .
		                           $cpfIDVal .
		                           $cpfURIVal .
		                           $cpfNoteVal .		                           
		                           $resourceVal .
		                           $resourceCreatorVal .
		                           $resourceTypeVal .
		                           $resourceRoleVal .
		                           $resourceIDVal .
		                           $resourceURIVal .
		                           $resourceNoteVal .
		                           $sourceVal .

		                           '<abstract>' . $abstract . '</abstract>
		                           </did>
		               <bioghist encodinganalog="545">' . $bioghist . '</bioghist>
		   </archdesc>
		</ead>
		');
    } catch(Exception $e) {
      die ('Caught exception: ' .  $e->getMessage() . "\n");
    }

    break;

  case 'family':

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
		            <archdesc audience="external" relatedencoding="MARC21" level="otherlevel">
		               <did>
		                     <origination label="Creator" encodinganalog="245$c">
		                     <famname encodinganalog="100_3">' . $famName . '</famname>
		                           </origination>
		                           <note type="creation"><p>Record created in RAMP.</p></note>		                           
		                           <note type="nameAuth"><p>' .
		                           $nameAuth .
		                           '</p></note>
                                   <note type="from"><p>' .
		                           $from .
		                           '</p></note>' .
		                           '<note type="to"><p>' .
		                           $to .
		                           '</p></note>
		                           <note type="standardFrom"><p>' .
		                           $standardFrom .
		                           '</p></note>' .
		                           '<note type="standardTo"><p>' .
		                           $standardTo .
		                           '</p></note>' .		                           
		                           $langNameVal .
		                           $langCodeVal .
		                           $scriptNameVal .
		                           $scriptCodeVal .
		                           $subjectVal .
		                           $genreVal .
		                           $occupationVal .
		                           $occuDateFromVal .
		                           $occuStandardFromVal .
		                           $occuDateToVal .
		                           $occuStandardToVal .
		                           $placeRoleVal .
		                           $placeEntryVal .
		                           $placeDateFromVal .
		                           $placeStandardFromVal .
		                           $placeDateToVal .
		                           $placeStandardToVal .
		                           $citationVal .		                           
		                           $cpfVal .
		                           $cpfTypeVal .
		                           $cpfRoleVal .
		                           $cpfIDVal .
		                           $cpfURIVal .
		                           $cpfNoteVal .		                           
		                           $resourceVal .
		                           $resourceCreatorVal .
		                           $resourceTypeVal .
		                           $resourceRoleVal .
		                           $resourceIDVal .
		                           $resourceURIVal .
		                           $resourceNoteVal .
		                           $sourceVal .

		                           '<abstract>' . $abstract . '</abstract>
		                           </did>
		               <bioghist encodinganalog="545">' . $bioghist . '</bioghist>
		   </archdesc>
		</ead>
		');
    } catch(Exception $e) {
      die ('Caught exception: ' .  $e->getMessage() . "\n");
    }

    break;
  }

  // Save file.
  fwrite($f, $ead_doc->saveXML());

    $ead_convert = new EadConvert( $_POST["dir"] );
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
	//$ead_convert->setEventDescRAMP($eventDescRAMP); // Removed because created Diff conflict. --timathom
    $ead_convert->new_eac( $file_name_lower );

  echo "Sucessfully created new record.";

}

// Function for basic validation of form input. Adapted from http://php.net/manual/en/function.stripslashes.php by StefanoAI.
function stripslashes_array(&$arr, $mysqli) {
    foreach ($arr as $k => &$v) {
        if( $k == 'dir' ) {
    		continue;
        }
        if (is_array($v)) {
            foreach ($v as $vk => &$vv) {            
                $v[$vk] = trim($vv);
                $v[$vk] = mysqli_real_escape_string($mysqli,$vv);
                $v[$vk] = htmlspecialchars(strip_tags($vv,"<p>"));
                $v[$vk] = preg_replace('#&lt;(/?[pi])&gt;#', '<$1>', $vv);
                $v[$vk] = str_replace('\n', '&#10;', $vv);                
            }
        } else {
            $arr[$k] = trim($v);
            $arr[$k] = mysqli_real_escape_string($mysqli,$v);
            $arr[$k] = htmlspecialchars(strip_tags($v,"<p>"));
            $arr[$k] = preg_replace('#&lt;(/?[pi])&gt;#', '<$1>', $v);
            $arr[$k] = str_replace('\n', '&#10;', $v);                	        
        }
    }    
}
    
?>
