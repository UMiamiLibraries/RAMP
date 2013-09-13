<?php 
include('header.php');
include('conf/db.php');

$zip = new ZipArchive;
$res = $zip->open('export/export.zip', ZipArchive::CREATE);

$mysqli = new mysqli($db_host, $db_user, $db_pass, $db_default, $db_port);
if ($mysqli->connect_errno) {
  echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}


$results = $mysqli->query ("SELECT eac_xml FROM ead_eac.eac");

while ($row = $results->fetch_assoc()) {
  
  $i++; 
  $zip->addFromString(strval($i).".xml", $row['eac_xml']);
 
}


?>
<div class="pure-u-1">
  <div class="content_box">
  <img src="style/images/export.png" alt="Convert" width="24px" height="24px"/>
 
 <h1> <a href="export/export.zip">Download Batch Export of EAC-CPF Files</a></h1>
  <p style="margin-top:.5%">

  </p>

</div>
</div>
<?php
include('footer.php');
?>