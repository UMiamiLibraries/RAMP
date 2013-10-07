<?php 
include('header.php');
?>

<div class="pure-g-r">
  <div class="pure-u-1">
    <div class="content_box" id="intro_box">
    <h1>Welcome to RAMP</h1>
    <br/>
    <br/>
    <p>The Remixing Archival Metadata Project (RAMP) is a lightweight web-based editing tool that is intended to let users do two things: (1) generate enhanced authority records for creators of archival collections and (2) publish the content of those records as Wikipedia pages.</p>
    <br/>
    <br/>
    <p>The RAMP editor can extract biographical and historical data from <a href="http://www.loc.gov/ead/" target="_blank">EAD finding aids</a> to create new authority records for persons, corporate bodies, and families associated with archival and special collections (using the <a href="http://www3.iath.virginia.edu/eac/cpf/tagLibrary/cpfTagLibrary.html" target="_blank">EAC-CPF format</a>). It can then let users enhance those records with additional data from sources like <a href="http://viaf.org" target="_blank">VIAF</a> and <a href="http://worldcat.org/identities/" target="_blank">WorldCat Identities</a>. Finally, it can transform those records into wiki markup so that users can edit them directly, merge them with any existing Wikipedia pages, and publish them to <a href="http://en.wikipedia.org" target="_blank">Wikipedia</a> through its API.</p>
    <br/>
    <br/>
    <div id="demos">
    <p>RAMP demo videos:</p>
    <br/>
    
    <p>
    <a id="demo_1" href="http://www.screencast.com/t/Q2XeS10YT1" class="modal">Overview of the RAMP editor</a> <span> | </span>    
    <a id="demo_3" href="http://www.screencast.com/t/nMw4fi30j" class="modal">Ingesting from WorldCat Identities</a> <span> | </span>        
    <a id="demo_2" href="http://www.screencast.com/t/wYPJDTh8Ccn" class="modal">Ingesting from VIAF</a> <span> | </span>    
    <a id="demo_4" href="http://www.screencast.com/t/O53qYAtSDY" class="modal">Publishing to Wikipedia</a> 
    </p>
    
    </div>
    </div>   
  </div>
</div>

<div class="pure-g-r">
  <div class="pure-u-1-2">
  <div class="content_box" id="convert_box">
  <img src="style/images/convert.png" alt="Convert" width="24px" height="24px"/>

  <h1>Convert EAD Records into EAC-CPF Records</h1>
 <ol><li><em>1.</em> Place your EAD files in the 'ead' folder in the RAMP root directory.</li>
  <li><em>2.</em> Click 'Convert EAD Files.'  This will transform the EAD files
into EAC-CPF records and store both original and newly created files in the RAMP database.</li>
<li><em>3.</em> You may now use the RAMP editor to enhance and publish your records. </li>
<br/>
<li>Note: If you run this on a folder that already has files, it will look for new and changed EAC files. If files
are changed, you will be presented with a 'diff' screen to merge changes. </li></ol>
  <br/>
  <p><a href="ead_convert.php" id="convert_ead">Convert EAD Files</a></p>

  <p>
  </p>

  </div>
  </div>

  <div class="pure-u-1-2">
  <div class="content_box" id="edit_box">
  <img src="style/images/edit.png" alt="Edit" width="24px" height="24px"/>
  <h1>Edit EAC, Enhance with External Data, Publish on Wikipedia</h1>
  
  <?php

  $mysqli = new mysqli($db_host, $db_user, $db_pass, $db_default, $db_port);
if ($mysqli->connect_errno) {
  echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}



$results = $mysqli->query ("SELECT ead_file, ExtractValue(eac_xml, '/descendant-or-self::part[1]') AS 'Name', substring_index(ead_file, '/', -1) AS 'SortHelp'
							FROM ead_eac.eac
							ORDER BY CASE WHEN Name = '' THEN SortHelp ELSE Name END ASC");



echo  "<select class='ead_files'>";

echo "<option>Select a name</option>";

echo "<option value=''></option>";

while ($row = $results->fetch_assoc()) {
  $name = $row["Name"];
  $file_name = $row["ead_file"];
  $file_name_display = htmlentities(basename($file_name));
  if($row["Name"]) {

    print "<option value='$file_name'>$name</option>";

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
</div>

<div class="pure-u-1-2">
  <div class="content_box" id="new_box">
  <img src="style/images/new.png" alt="Convert" width="24px" height="24px"/>
  <h1>Create a New EAC-CPF Record</h1>  
  <!-- Temporarily hiding select box until we can make selection dynamic.
  <select id="new_select">
  <option>
  Create a new ...

  <option>


  </option>
  <option value='person'>
  Person
  </option>
  <option value='xh'>
  Corporate Body
  </option>
  <option value='family'>
  Family
  </option>
  </select> 
  -->
  <p style="font-size:1.2em; margin:0 1% 1% 1%;">No finding aid? No problem! Add a new EAC-CPF record to the RAMP database.</p>
  <br/>
  <p><a href="new_eac.php" id="new_eac_record">New Record</a></p>
  </div>
  </div>

  <div class="pure-u-1-2">
  <div class="content_box" id="export_box">
<img src="style/images/export.png" height="24px" width="24px" alt="Export"/>
  <h1>Batch Export EAC-CPF Records</h1>
  <p style="margin:1%; font-size:1.2em;">After your first conversion you can export the resulting EAC-CPF records.</p>
  <br/>
  <p><a id="export_eac" href="export.php" style="margin:1%;">Export EAC-CPF Records</a></p>
  
  </div>
  </div>
  
 

  </div>
  
  <div id="attribution">
  <img src="http://www.oclc.org/developer/sites/default/files/badges/logo_worldcat_16px.png" width="16" height="16" alt="Some library data on this site is provided by WorldCat, the world's largest library catalog [WorldCat.org]" />
  <p>RAMP contains <a href="http://www.worldcat.org/">OCLC WorldCat</a> information made available under the <a href="http://opendatacommons.org/licenses/by/1.0/">ODC Attribution License</a>. The OCLC Cooperative requests that uses of WorldCat derived data contained in this work conform with the <a href="http://www.oclc.org/worldcat/community/record-use/policy/community-norms.en.html">WorldCat Community Norms</a>.</p>    
  </div>
  
  

  <?php
  include('footer.php');
?>
