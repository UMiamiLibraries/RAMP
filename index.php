<?php 
include('header.php');
?>

<div class="pure-g-r">
  <div class="pure-u-1-2">


    <?php

    $mysqli = new mysqli($db_host, $db_user, $db_pass, $db_default, $db_port);
    if ($mysqli->connect_errno) {
      echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
    }



    $results = $mysqli->query ("SELECT ead_file, CONCAT(ExtractValue(eac_xml, '//nameEntry[1]/part[1]'),', ',ExtractValue(eac_xml, '//nameEntry[1]/part[2]')) AS 'Name', substring_index(ead_file, '/', -1) AS 'SortHelp'
							FROM eac
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



  <div class="pure-u-1-2">

  </div>


</div>

  

<?php
 include('footer.php');
?>