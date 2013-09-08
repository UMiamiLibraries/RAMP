<?php 
include('header.php');
?>

<div class="pure-g-r">

  <div class="pure-u-1">
  <div class="content_box">
  <img src="style/images/convert.png" alt="Convert" width="24px" height="24px"/>

  <h1>Convert EAD Records Into EAC-CPF Records</h1>
 
  <button data-href="ead_convert.php" class="update_button pure-button pure-button-primary" id="convert_ead">Convert EAD Files</button>

  

 
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

  <?php
  include('footer.php');
?>