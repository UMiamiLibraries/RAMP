<?php
/**
 * Eac edit
 * 
 *
 * This script creates the select box listing of files that are used in the editing interface and outputs all the markup required for running the Ace editor on the page.
 *
 *
 * @author little9 (Jamie Little)
 * @copyright Copyright (c) 2013
 *
 **/ 
include('header.php');
?>


  <script src="script/editor.js"></script>
  <script src="script/eac_editor.js"></script>
  <script src="script/vkbeautify.js"></script>
  <script src="script/ingest.js"></script>
  <script src="script/wikiator.js"></script>
 

  <div id="edit_controls">
  <h1 id="entity_name"></h1>
  
    
  <span id="ingest_buttons" class="main_edit">
  <p id="start_here" class="main_edit"> Start here: </p>
  <button id="ingest_worldcat" class="ingest_button pure-button pure-button-primary main_edit">Ingest WorldCat Identities</button>
  <div class="worldcat_arrow arrows main_edit">&rarr;</div>

  <button id="ingest_viaf" class="ingest_button pure-button pure-button-primary main_edit">Ingest VIAF</button>
  <div class="viaf_arrow arrows main_edit">&rarr;</div>
  </span>

  <button id="save_eac" class="pure-button pure-button-primary main_edit">Save XML</button>
  <div class="arrows save_arrow main_edit">&rarr;</div>
  <button id="convert_to_wiki" class="pure-button pure-button-primary main_edit">Convert to Wiki Markup </button>

  
  <form id="download_form" method="post" target="_blank" action="download.php">
  <input id="download_xml" type="hidden" name="xml" value=""/>
  <input id="file_name" type="hidden" name="path" value="">  
  <button id="download_submit" class="pure-button pure-button-primary main_edit" type="submit">Export Current EAC-CPF</button>
  </form>
  
  <!-- <button id="download_submit" class="pure-button pure-button-primary main_edit"><a id="download_link" href="">Export Current EAC-CPF</a></button> -->
  

  <?php
  
  $mysqli = new mysqli($db_host, $db_user, $db_pass, $db_default, $db_port);
if ($mysqli->connect_errno) {
  echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}



$results = $mysqli->query ("SELECT ead_file, CONCAT(ExtractValue(eac_xml, '//nameEntry[1]/part[1]'),', ',ExtractValue(eac_xml, '//nameEntry[1]/part[2]')) AS 'Name', substring_index(ead_file, '/', -1) AS 'SortHelp'
							FROM s52298__ead_eac.eac
							ORDER BY CASE WHEN Name = '' THEN SortHelp ELSE Name END ASC");



echo  "<select id='ead_files' class='ead_files'>";

echo "<option>Please Select a Record</option>";

echo "<option value=''></option>";

while ($row = $results->fetch_assoc()) {
  $name = $row["Name"];
  $file_name = $row["ead_file"];
  $file_name_display = htmlentities(basename($file_name));
  if($row["Name"]) {

    print "<option value='$file_name'>" . rtrim($name,', ') ."</option>";

  } else {

    print "<option value='$file_name'>$file_name_display</option>";

  }

}



//	foreach ($files as $file) {

print ("<option>");

//		print ("</option>");


print ("</select>");

  
?>

</div>


<div id="wiki_switch"> 
  <button id="xml_switch_button" class="pure-button pure-button-primary">XML</button>
  <button id="wiki_switch_button" class="pure-button pure-button-primary">Wiki</button>   
</div>


  <div id="validation" class="main_edit">
  </div>
  <div id="validation_text" class="main_edit">Valid XML</div>
  
  
  <div id="editor_mask" class="main_edit">
  <div id="editor_container" class="main_edit">


  <div id="editor" class="main_edit"></div>
  </div>
  </div>

  <script src="script/ace/ace.js" type="text/javascript" charset="utf-8"></script>

  <script>
  var editor = ace.edit("editor");
editor.getSession().setMode("ace/mode/xml");
</script>

<link rel="stylesheet" type="text/css" href="script/select2/select2.css"/>
  <script src="script/select2/select2.min.js"></script>

  <script>
  //   $(document).ready(function() { $("#ead_files").select2(); });
  </script>
  <?php


  include('footer.php');

?>
