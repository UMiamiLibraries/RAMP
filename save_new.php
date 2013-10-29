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
stripslashes_array($_POST);
$cleanedArray = array();

foreach ($_POST as $post_name => $post_val) {
    if ($post_name == "type") {
        checkCharacters($post_val);
    }                   
    if ($post_name == "entity") {
        checkCharacters($post_val);
    }    
    if ($post_name == "name") {
        checkCharacters($post_val);
    }
    if ($post_name == "from") {
        checkCharacters($post_val);
    }    
    if ($post_name == "to") {
        checkCharacters($post_val);
    }        
    if ($post_name == "genders") {
        checkCharacters($post_val);
    }
    if ($post_name == "genderDatesFrom") {
        checkCharacters($post_val);
    }    
    if ($post_name == "genderDatesTo") {
        checkCharacters($post_val);
    }        
    if ($post_name == "langNames") {
        checkCharacters($post_val);
    }    
    if ($post_name == "langCodes") {
        checkCharacters($post_val);
    }    
    if ($post_name == "subjects") {
        checkCharacters($post_val);
    }    
    if ($post_name == "genre") {
        checkCharacters($post_val);
    }    
    if ($post_name == "occupations") {
        checkCharacters($post_val);
    }    
    if ($post_name == "occuDatesFrom") {
        checkCharacters($post_val);
    }    
    if ($post_name == "occuDatesTo") {
        checkCharacters($post_val);
    }    
    if ($post_name == "placeEntries") {
        checkCharacters($post_val);
    }    
    if ($post_name == "placeRoles") {
        checkCharacters($post_val);
    }    
    if ($post_name == "placeDatesFrom") {
        checkCharacters($post_val);
    }    
    if ($post_name == "placeDatesTo") {
        checkCharacters($post_val);
    }    
    if ($post_name == "abstract") {
        
        // Remove newline characters.                
        $post_val = trim(preg_replace('/\n+/', '&#10;', $post_val));
        
        checkCharacters($post_val);                               
    }                  
    if ($post_name == "bioghist") {
        
        // Remove newline characters.                
        $post_val = trim(preg_replace('/\n+/', '&#10;', $post_val));                        
        
        // Decode special chars to get <p> tags.
        $post_val = htmlspecialchars_decode($post_val);
        
        // Re-encode for &amp;                     
        $post_val = preg_replace('/&/', '&amp;', $post_val);
                        
        checkCharacters($post_val);                                                             
    }    
    if ($post_name == "citations") {
        checkCharacters($post_val);
    }
    if ($post_name == "cpfs") {
        checkCharacters($post_val);
    }
    if ($post_name == "cpfIDs") {
        checkCharacters($post_val);
    }
    if ($post_name == "cpfNotes") {
        checkCharacters($post_val);
    }
    if ($post_name == "resources") {
        checkCharacters($post_val);
    }
    if ($post_name == "resourceIDs") {
        checkCharacters($post_val);
    }
    if ($post_name == "resourceNotes") {
        checkCharacters($post_val);
    }
    if ($post_name == "sources") {
        checkCharacters($post_val);
    }
           
    $cleanedArray[$post_name] = $post_val;
    
} 

// Set array counters.
$countGenders = sizeof($cleanedArray['genders']);
$countGenderDatesFrom = sizeof($cleanedArray['genderDatesFrom']);
$countGenderDatesTo = sizeof($cleanedArray['genderDatesTo']);
$countLangNames = sizeof($cleanedArray['langNames']);
$countLangNames = sizeof($cleanedArray['langNames']);
$countLangCodes = sizeof($cleanedArray['langCodes']);
$countSubjects = sizeof($cleanedArray['subjects']);
$countGenres = sizeof($cleanedArray['genres']);
$countOccupations = sizeof($cleanedArray['occupations']);
$countOccuDatesFrom = sizeof($cleanedArray['occuDatesFrom']);
$countOccuDatesTo = sizeof($cleanedArray['occuDatesTo']);
$countPlaceEntries = sizeof($cleanedArray['placeEntries']);
$countPlaceRoles = sizeof($cleanedArray['placeRoles']);
$countPlaceDatesFrom = sizeof($cleanedArray['placeDatesFrom']);
$countPlaceDatesTo = sizeof($cleanedArray['placeDatesTo']);
$countCitations = sizeof($cleanedArray['citations']);
$countCpfs = sizeof($cleanedArray['cpfs']);
$countCpfIDs = sizeof($cleanedArray['cpfIDs']);
$countCpfNotes = sizeof($cleanedArray['cpfNotes']);
$countResources = sizeof($cleanedArray['resources']);
$countResourceIDs = sizeof($cleanedArray['resourceIDs']);
$countResourceNotes = sizeof($cleanedArray['resourceNotes']);
$countSources = sizeof($cleanedArray['sources']);

//make file name valid utf8
$file_name = $cleanedArray["name"];
$file_name_lower = strtolower(str_replace(' ', '_', $file_name));
$file_name_lower = preg_replace('/[^a-zA-Z0-9-_]/', '', $file_name_lower);
$file_name_lower = iconv('utf-8', "us-ascii//TRANSLIT", $file_name_lower);
$file_name_lower = preg_replace('/[^a-zA-Z0-9-_\.]/', '', $file_name_lower);

//exit and return message if file name is empty
if( $file_name_lower == "" )
	die( "Record not saved. File name is empty." );

$gender = array();
$genderDateFrom = array();
$genderDateTo = array();
$langName = array();
$langCode = array();
$subject = array();
$genre = array();
$occupation = array();
$occuDateFrom = array();
$occuDateTo = array();
$placeEntry = array();
$placeRole = array();
$placeDateTo = array();
$placeDateFrom = array();
$citation = array();
$cpf = array();
$cpfID = array();
$cpfNote = array();
$resource = array();
$resourceID = array();
$resourceNote = array();
$source = array();

// Assign variables to cleaned array.
$type = $cleanedArray["type"];
$entity = $cleanedArray["entity"];
$entname = $cleanedArray["name"];
$from = $cleanedArray["from"];
$to = $cleanedArray["to"];
$gender = $cleanedArray["genders"];
$genderDateFrom = $cleanedArray["genderDatesFrom"];
$genderDateTo = $cleanedArray["genderDatesTo"];
$langName = $cleanedArray["langNames"];
$langCode = $cleanedArray["langCodes"];
$subject = $cleanedArray["subjects"];
$genre = $cleanedArray["genres"];
$occupation = $cleanedArray["occupations"];
$occuDateFrom = $cleanedArray["occuDatesFrom"];
$occuDateTo = $cleanedArray["occuDatesTo"];
$placeEntry = $cleanedArray["placeEntries"];
$placeRole = $cleanedArray["placeRoles"];
$placeDateFrom = $cleanedArray["placeDatesFrom"];
$placeDateTo = $cleanedArray["placeDatesTo"];
$abstract = $cleanedArray["abstract"];

if ($cleanedArray["bioghist"] == '') {   
    $bioghist = "<p></p>";
}
else
{
    $bioghist = $cleanedArray["bioghist"];    
}

$citation = $cleanedArray["citations"];
$cpf = $cleanedArray["cpfs"];
$cpfID = $cleanedArray["cpfIDs"];
$cpfNote = $cleanedArray["cpfNotes"];
$resource = $cleanedArray["resources"];
$resourceID = $cleanedArray["resourceIDs"];
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

$occuDateToVal = '';

for ($i = 0; $i < $countOccuDatesTo; $i++) {
  $occuDateToVal .= "<note type='occuDateTo' label='_" . $i . "'><p>";
  $occuDateToVal .= $occuDateTo[$i];
  $occuDateToVal .= "</p></note>";
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

$placeDateToVal = '';

for ($i = 0; $i < $countPlaceDatesTo; $i++) {
  $placeDateToVal .= "<note type='placeDateTo' label='_" . $i . "'><p>";
  $placeDateToVal .= $placeDateTo[$i];
  $placeDateToVal .= "</p></note>";
}

$citationVal = '';

for ($i = 0; $i < $countCitations; $i++) {
  $citationVal .= "<note type='citation' label='_" . $i . "'><p>";
  $citationVal .= $citation[$i];
  $citationVal .= "</p></note>";
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

$cpfNoteVal = '';

for ($i = 0; $i < $countCpfNotes; $i++) {
  $cpfNoteVal .= "<note type='cpfNote' label='_" . $i . "'><p>";
  $cpfNoteVal .= $cpfNote[$i];
  $cpfNoteVal .= "</p></note>";
}

$resourceVal = '';

for ($i = 0; $i < $countResources; $i++) {
  $resourceVal .= "<note type='resource' label='_" . $i . "'><p>";
  $resourceVal .= $resource[$i];
  $resourceVal .= "</p></note>";
}

$resourceIDVal = '';

for ($i = 0; $i < $countResourceIDs; $i++) {
  $resourceIDVal .= "<note type='resourceID' label='_" . $i . "'><p>";
  $resourceIDVal .= $resourceID[$i];
  $resourceIDVal .= "</p></note>";
}

$resourceNoteVal = '';

for ($i = 0; $i < $countResourceNotes; $i++) {
  $resourceNoteVal .= "<note type='resourceID' label='_" . $i . "'><p>";
  $resourceNoteVal .= $resourceID[$i];
  $resourceNoteVal .= "</p></note>";
}

$sourceVal = '';

for ($i = 0; $i < $countSources; $i++) {
  $sourceVal .= "<note type='source' label='_" . $i . "'><p>";
  $sourceVal .= $source[$i];
  $sourceVal .= "</p></note>";
}

// Check name.
if (file_exists(  $_POST["dir"] . '/' . $file_name_lower . '.xml')) {

  echo "A record with this name already exists.";

} else {  
  touch(  $_POST["dir"] . '/' . $file_name_lower . '.xml');

  $f = fopen(  $_POST["dir"] . '/' . $file_name_lower . '.xml', "w");

  $ead_doc = new DOMDocument();
  $ead_doc->formatOutput = true; 

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
		                     <persname encodinganalog="100"  source="local">' . $entname .


			'</persname>
		                           </origination>
		                           <note type="creation"><p>Record created in RAMP.</p></note>' . 
		                           		                           
		                           $fromVal . 
		                           $toVal .
		                           $genderVal .
		                           $genderDateFromVal .
		                           $genderDateToVal .
		                           $langNameVal .
		                           $langCodeVal .
		                           $subjectVal .
		                           $genreVal .
		                           $occupationVal .
		                           $occuDateFromVal .
		                           $occuDateToVal .
		                           $placeRoleVal .
		                           $placeEntryVal .		                           
		                           $placeDateFromVal .
		                           $placeDateToVal .
		                           $citationVal .
		                           $cpfVal .
		                           $cpfIDVal .
		                           $cpfNoteVal .
		                           $resourceVal .
		                           $resourceIDVal .
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
		                     <corpname encodinganalog="100"  source="local">' . $entname . '</corpname>
		                           </origination>
		                           <note type="creation"><p>Record created in RAMP.</p></note>' .
		                           		                           
		                           $fromVal . 
		                           $toVal .
		                           $langNameVal .
		                           $langCodeVal .
		                           $subjectVal .
		                           $genreVal .
		                           $occupationVal .
		                           $occuDateFromVal .
		                           $occuDateToVal .
		                           $placeRoleVal .
		                           $placeEntryVal .		                           
		                           $placeDateFromVal .
		                           $placeDateToVal .
		                           $citationVal .
		                           $cpfVal .
		                           $cpfIDVal .
		                           $cpfNoteVal .
		                           $resourceVal .
		                           $resourceIDVal .
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
		                     <famname  source="local">' . $entname . '</famname>
		                           </origination>
		                           <note type="creation"><p>Record created in RAMP.</p></note>' .
 		                           		                           
		                           $fromVal . 
		                           $toVal .
		                           $langNameVal .
		                           $langCodeVal .
		                           $subjectVal .
		                           $genreVal .
		                           $occupationVal .
		                           $occuDateFromVal .
		                           $occuDateToVal .
		                           $placeRoleVal .
		                           $placeEntryVal .		                           
		                           $placeDateFromVal .
		                           $placeDateToVal .
		                           $citationVal .
		                           $cpfVal .
		                           $cpfIDVal .
		                           $cpfNoteVal .
		                           $resourceVal .
		                           $resourceIDVal .
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

// Function for basic validation of character input.
function checkCharacters($input) {   
    $patterns = array();
    $patterns[0] = '/&lt;p&gt;/';
    $patterns[1] = '/&lt;/p&gt;/';
    
    $replacements = array();
    $replacements[0] = '<p>';
    $replacements[1] = '</p>';
    
    $input = preg_replace($patterns, $replacements, $input);
     
    $input = trim($input);    
    $input = strip_tags($input,"<p>");    
    $input = mysqli_real_escape_string($mysqli,$input);    
    //$found = preg_match("/^[a-zA-Z]$/", $input);		
    //return $found;
    return $input;
           
}

// http://php.net/manual/en/function.stripslashes.php by StefanoAI
function stripslashes_array(&$arr) {
    foreach ($arr as $k => &$v) {
        $nk = stripslashes(htmlspecialchars(strip_tags($k,"<p>")));
        if ($nk != $k) {
            $arr[$nk] = &$v;
            unset($arr[$k]);
        }
        if (is_array($v)) {
            stripslashes_array($v);
        } else {
            $arr[$nk] = stripslashes(htmlspecialchars(strip_tags($v,"<p>")));
        }
    }
}

?>
