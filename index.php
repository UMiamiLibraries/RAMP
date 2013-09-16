<?php 
include('header.php');
?>

<div class="pure-g-r">
  <div class="pure-u-1">
    <div class="content_box">
    <h1>Welcome to RAMP</h1>
    <br/>
    <br/>
    <p>The Remixing Archival Metadata Project (RAMP) is a lightweight web-based editing tool that is intended to let users do two things: (1) generate enhanced authority records for creators of archival collections and (2) publish the content of those records as Wikipedia pages.</p>
    <br/>
    <br/>
    <p>The RAMP editor can extract biographical and historical data from <a href="http://www.loc.gov/ead/" title="Link to Library of Congress EAD page" target="_blank">EAD finding aids</a> to create new authority records for persons, corporate bodies, and families associated with archival and special collections (using the <a href="http://www3.iath.virginia.edu/eac/cpf/tagLibrary/cpfTagLibrary.html" title="Link to EAC-CPF tag library" target="_blank">EAC-CPF format</a>). It can then let users enhance those records with additional data from sources like <a href="http://viaf.org" title="Link to the Virtual International Authority File" target="_blank">VIAF</a> and <a href="http://worldcat.org/identities/" title="Link to WorldCat Identities" target="_blank">WorldCat Identities</a>. Finally, it can transform those records into wiki markup so that users can edit them directly, merge them with any existing Wikipedia pages, and publish them to <a href="http://en.wikipedia.org" title="Link to English Wikipedia" target="_blank">Wikipedia</a> through its API.</p>    
    </div>   
  </div>
  <div class="pure-u-1">
  <div class="content_box">
  <img src="style/images/convert.png" alt="Convert" width="24px" height="24px"/>

  <h1>Convert EAD Records Into EAC-CPF Records</h1>
 <ol><li><em>1.</em> Upload your EAD files into the correct folder on the RAMP server</li>
  <li><em>2.</em> Check the path is correct and then click 'Convert.'  This will transform the EAD files
into EAC-CPF records, and store both original and newly created files in the RAMP database.</li>
<li><em>3.</em> You may now use the RAMP editor (below) to enhance and publish your records. </li>
<li>Note:  If you run this on a folder that already has files, it will look for new and changed EAC files.  If files
are changed, you will be presented with a 'diff' screen to merge changes. </li></ol>
  <a href="ead_convert.php" id="convert_ead">Convert EAD Files</a>

  <p>
  </p>

  </div>
  </div>

  <div class="pure-u-1">
  <div class="content_box">
  <img src="style/images/edit.png" alt="Edit" width="24px" height="24px"/>
  <h1>Edit EAC, Enhance with Linked Data, Publish on Wikipedia</h1>
  
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

<div class="pure-u-1">
  <div class="content_box">
  <img src="style/images/new.png" alt="Convert" width="24px" height="24px"/>
  <h1>Create a New Skeleton EAC-CPF Record</h1>

  <p>
  </p>
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

  </div>
  </div>

 

  </div>



  <div class="pure-u-1">
  <div class="content_box">
<img src="style/images/export.png" height="24px" width="24px" alt="Export"/>
  <h1>Batch Export EAC-CPF Records</h1>
  <p style="margin:1%;">After your first conversion you can batch export the result EAC-CPF records</p>
  <p><a href="export.php" style="margin:1%;">Export EAC-CPF Records</a></p>
  

  </div>
  </div>

  <?php
  include('footer.php');
?>