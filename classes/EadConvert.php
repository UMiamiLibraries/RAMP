<?php

class EadConvert {
  private $agency_code;
  private $other_agency_code;
  private $agency_name;
  private $serverName;
  private $localURL;
  private $repositoryOne;
  private $repositoryTwo;
  private $eventDescDerive;
  private $eventDescCreate;
  private $eventDescRevise;
  private $eventDescExport;
  private $eventDescRAMP;

  





  private $allfiles;
  // The array of EAD files
  private $ead_path;
  // The path to an individual EAD file
  private $XMLDOM;
  //The Dom Document for XML
  private $cycleCount = 20;

  public function __construct( $ead_path )
  {
  	$this->XMLDOM = new DOMDocument();
  	$this->XMLDOM->formatOutput = true;
  	$this->ead_path = $ead_path;
  	$this->allfiles = array_diff( scandir( $this->ead_path ), array('.svn','.', '..') );
  }

  /* Getters */
  public function getAllFiles() {
    // This function filters out some of the Unixy stuff that comes from running scandir
    $this->allfiles;

  }

  public function getEadPath() {
    return $this->ead_path;
  }

  public function setAllFiles($allfiles)
  {
  	$this->allfiles = $allfiles;
  }


  public function getAgency_code() {
    return $this->agency_code;
  }

  public function setAgency_code($agency_code)
  {
  	$this->agency_code = $agency_code;
  }

 public function getOther_agency_code() {
    return $this->other_agency_code;
  }

  public function setOther_agency_code($other_agency_code)
  {
  	$this->other_agency_code = $other_agency_code;
  }

 public function getAgency_name() {
    return $this->agency_name;
  }

  public function setAgency_name($agency_name)
  {
  	$this->agency_name = $agency_name;
  }

  public function setServer_name($serverName) {
    $this->serverName = $serverName;
  }

  public function getServer_name() {
    return $this->serverName;
  }

  public function setLocal_url($localURL) {
    $this->localURL = $localURL;
  }
  public function getLocal_url() {
    return $this->localURL;

  }

  public function setRepository_one($repositoryOne) {
    $this->repositoryOne = $repositoryOne;
  }
  public function getRepository_one() {
    return $this->repositoryOne;

  }

  public function setRepository_two($repositoryTwo) {
    $this->repositoryTwo = $repositoryTwo;
  }
  public function getRepository_two() {
    return $this->repositoryTwo;

  }

  public function setEventDescCreate($eventDescCreate) {
    $this->eventDescCreate = $eventDescCreate;
  }
  public function getEventDescCreate() {
    return $this->eventDescCreate;

  }

  public function setEventDescRevise($eventDescRevise) {
    $this->eventDescRevise = $eventDescRevise;
  }
  public function getEventDescRevise() {
    return $this->eventDescRevise;

  }

    public function setEventDescDerive($eventDescDerive) {
    $this->eventDescDerive = $eventDescDerive;
  }
  public function getEventDescDerive() {
    return $this->eventDescDerive;

  }

  public function setEventDescExport($eventDescExport) {
    $this->eventDescExport = $eventDescExport;
  }
  public function getEventDescExport() {
    return $this->eventDescExport;

  }
  
  public function setEventDescRAMP($eventDescRAMP) {
    $this->eventDescRAMP = $eventDescRAMP;
  }
  public function getEventDescRAMP() {
    return $this->eventDescRAMP;

  }

  public function process_files() {
    /*
       This function takes an array of paths to EAD files and processes them.

       Firstly, the function checks to see if the file already exists in the database.

       If the file doesn't already exist in the database it is inserted into the database and an XSLT
       transformation is performed that returns EAC-CPF XML. The EAC-CPF is also inserted into the database.

       The original EAD file is deleted so that consecutive imports don't have to process all the files. They
       are no longer needed because they are in the database.

       If the file already exists in the database, a string comparison is done to see if the XML has changed.
       If the XML has changed then the phpDiff library in envoked and the user is presented with a graphical
       interface for the Diff.

       -- Jamie
    */
	$counter = 0;
  	$HTMLdiffs = '';

    foreach ($this->allfiles as $key => $file) {
      // Iterate over the files

      if( pathinfo($file, PATHINFO_EXTENSION) != "xml")
      	continue;

      $file_path = $this->ead_path .  '/' . $file;
      //Reconstruct the full path to the file

      $xml_string = get_include_contents($file_path);
      // Get the XML content from the file as a string.

      try {
		$this->XMLDOM->load($file_path);
        // Try to load the ead file

      } catch(Exception $e) {
		die ('Caught exception: ' .  $e->getMessage() . "\n");
      }

      $name_check_results = $this->name_check();

      if ($name_check_results == TRUE) {
		// Make sure that the EAD file has a name
		$HTMLdiffs .= $this->insert_into_db($file_path, $file);
      }

      unset( $this->allfiles[$key] );

	  $counter++;

	  if( $counter >= $this->cycleCount )
	  {
	  	$jsonOutput = array( "diffs" => $HTMLdiffs, "unprocessed" => array_values($this->allfiles), "status" => "unfinished" );
	  	return json_encode($jsonOutput);
	  }
    }

  	$jsonOutput = array( "diffs" => $HTMLdiffs, "status" => "done" );
  	return json_encode($jsonOutput);
  }

  public function new_eac( $file_name )
  {
  	$file_path = $this->ead_path .  '/' . $file_name . ".xml";

  	try {
  		$this->XMLDOM->load($file_path);
  		// Try to load the ead file

  	} catch(Exception $e) {
  		die ('Caught exception: ' .  $e->getMessage() . "\n");
  	}

  	$this->insert_into_db( $file_path, $file_name . ".xml" );
  }

  private function insert_into_db($file_path, $file){

	$db = Database::getInstance();
	$mysqli = $db->getConnection();
	// Connect to the database
	$ramp_id = "ramp" . rand(1,193918491834931);
  	$xml_string =  $mysqli->real_escape_string( $this->XMLDOM->saveXML() );

  	$eac_id = $this->create_eac_id();
  	// Create an id for the EAC file
  	$parameters = array(

			    'agencyCode'=>$this->agency_code,
			    'otherAgencyCode' => $this->other_agency_code,
			    'agencyName'=> $this->agency_name,
			    'standardDateTime'=>date('c'),
			    'file' => $file,

			    'serverName' => $this->serverName,
			    'localURL' => $this->localURL,
			    'eventDescCreate' => $this->eventDescCreate,
			    'repositoryOne' => $this->repositoryOne,
			    'repositoryTwo' => $this->repositoryTwo,
			    'eventDescDerive' => $this->eventDescDerive,
			    'eventDescRevise' => $this->eventDescRevise,
			    'eventDescExport' => $this->eventDescExport,
			    'eventDescRAMP' => $this->eventDescRAMP);

  	$xslt = XsltTransform::transform($this->XMLDOM, $file, $parameters); // Changed $ramp_id back to $file. Value of $ramp_id assigned only to newly created records.
  	// Do the XSLT transform. Send the XSLT the id and the EAD XML.

  	if( $mysqli->query("SELECT ead_file FROM ead WHERE ead_file = '$file_path'")->num_rows === 0 ) {
	  // Check if the EAD file has already been inserted.
	  // If it hasn't then insert it and and insert the transformed EAC.

	  $ead_result = $mysqli->query("INSERT into ead_eac.ead (ead_xml, ead_file) VALUES ('$xml_string', '$file_path') ");
	  // Insert the EAD into the database

	  if( !$ead_result )
	  	die ("<p>Error! " . mysqli_error($mysqli) . "</p>");

	  $date = date("Y-m-d H:i:s");
	  // Get the date

		$eac_result = $mysqli->query("INSERT into ead_eac.eac (created, eac_xml, ead_file) VALUES (  '$date', '$xslt','$file_path' ) ");

		if( !$eac_result )
			die ("<p>Error! " . mysqli_error($mysqli) . "</p>");

	  // Insert the EAC into the database

  		return "";
	} else {
		// If you couldn't insert the EAD into the database

		$ead_str_compare = $this->ead_update_check($file_path);

		// Then do a string comparision to see if the EAD file has changed since the last import

		if ($ead_str_compare != 0) {
			// Check to see if the string comparison returned a positive result.
			$mysqli->query("UPDATE ead_eac.ead SET ead_xml='$xml_string' WHERE ead_file='$file_path'");
			// If it has then update the EAD.

			return $this->eac_update_check($file_path,$xslt);
			//Check eac

		}
	}

  }

  private function name_check() {
    // This function checks to see if the EAD file has a defined name -- either persname or corpname

    $xpath = new DOMXPath($this->XMLDOM);
    // Create a new xpath

    $xpath->registerNamespace("ead","urn:isbn:1-931666-22-9");
    // Register the EAD namespace

    $xpath_results = $xpath->evaluate('boolean(//ead:ead/ead:archdesc/ead:did/ead:origination[ead:persname|ead:corpname|ead:famname])');

    // Eval the xpath


    return $xpath_results;

  }

  private function ead_update_check($file_path) {
    // This function checks to see if an EAD file needs to be updated.

    $db = Database::getInstance();
    $mysqli = $db->getConnection();
    // Connect to the database

  	$ead_from_db = $mysqli->query("SELECT ead_xml FROM ead_eac.ead WHERE ead_file = '$file_path'");


    $ead_from_db_xml = mysqli_fetch_row($ead_from_db);
    // Get the EAD from the database

  	/*var_dump(mysqli_real_escape_string($mysqli,trim($ead_from_db_xml[0])));
  	var_dump(mysqli_real_escape_string($mysqli, trim($this->XMLDOM->saveXML())));
  	exit;*/

    $ead_str_compare = strcasecmp( preg_replace( '/[\s]+/', '',stripslashes(trim($ead_from_db_xml[0]))), preg_replace( '/[\s]+/', '',trim($this->XMLDOM->saveXML())));
    // Do the string comparison
  	//remove whitespace (added by dgonzalez) should not matter if formatted differently

    return $ead_str_compare;

  }

  private function create_eac_id() {
    $eac_id = rand(1,1013481048194);
    // Remove file extension


    //$eac_id = substr( strrchr( $eac_id, '/' ), 1 );
    // Remove directory stuff, should the id in EAC be different?
    return $eac_id;
  }
  /*
  public function print_param() {
	$parameters = array(

			    'agencyCode'=>$this->agency_code,
			    'otherAgencyCode' => $this->other_agency_code,
			    'agencyName'=> $this->agency_name,
			    'standardDateTime'=>date('c'),
			    'file' => $file,

			    'serverName' => $this->serverName,
			    'localURL' => $this->localURL,
			    'repositoryOne' => $this->repositoryOne,
			    'repositoryTwo' => $this->repositoryTwo,
			    'eventDescDerive' => $this->eventDescDerive,
			    'eventDescRevise' => $this->eventDescRevise,
			    'eventDescExport' => $this->eventDescExport);

	print_r($parameters);
  }
  */

  private function eac_update_check($ead_path, $xslt) {

    $db = Database::getInstance();
    $mysqli = $db->getConnection();

  	$eac_from_db_xml = $mysqli->query("SELECT eac_xml FROM ead_eac.eac WHERE ead_file = '$ead_path'");
    $eac_row = mysqli_fetch_row($eac_from_db_xml);

  	$xslt = stripslashes($xslt);

    $eac_str_compare = strcasecmp( trim($eac_row[0]), trim($xslt));
	$output = "";

    if ($eac_str_compare != 0) {

      // Diff stuff
      $options = array(
		       'ignoreWhitespace' => true,
		       'ignoreCase' => true,
		       );

      $a = explode("\n",$eac_row[0]);
      $b = explode("\n",$xslt);

      $diff = new Diff ($a, $b, $options);

      $renderer = new Diff_Renderer_Html_SideBySide;

      $diff_id = md5( $eac_row[0] . date('c') . $xslt );

      $output .= "<div id=\"$diff_id\">" . $diff->Render($renderer);
      $output .= "<script type=\"text/javascript\">var ead_path_$diff_id=\"" . $ead_path . '"</script>';
      $output .= "<script type=\"text/javascript\">var left_$diff_id=".json_encode($a).", right_$diff_id=".json_encode($b).';</script>';


      $output .= "<script>

$('div#$diff_id .Differences').phpdiffmerge({
    left: left_$diff_id,
    right: right_$diff_id,
    merged: function(merge, left, right) {
        /* Do something with the merge */
        $.post(
            'update_eac_xml.php',
            {
	    ead_file: ead_path_$diff_id,
		xml: merge.join(\"\\n\")
            },
            function() {
                alert('Done');
            }
        );
    }
    /* Use your own \"Merge now\" button */
    // ,button: '#myButtonId'
    /* uncomment to see the complete merge in a pop-up window */
    // ,pupupResult: true
    /* uncomment to pass additional infos to the console. */
    // ,debug: true
});


</script>
</div>
";

    }

  	return $output;
  }




}
?>