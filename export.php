<?php 
include('header.php');

include('autoloader.php');

use RAMP\Util\Database;

$db = Database::getInstance();
$mysqli = $db->getConnection();

$zip = new ZipArchive;
$res = $zip->open('export/ramp-export.zip', ZipArchive::CREATE);



$results = $mysqli->query ("SELECT eac_xml FROM eac");
$names = $mysqli->query ("SELECT ead_file, ExtractValue(eac_xml, '/descendant-or-self::part[1]') AS 'Name', substring_index(ead_file, '/', -1) FROM eac");

while ($row = $results->fetch_assoc()) {
  $row2 = $names->fetch_assoc();  
  
  $file_name = mysqli_real_escape_string($mysqli,$row2['Name']);
  $file_name_lower = strtolower(str_replace(' ', '_', $file_name));
  $file_name_lower = preg_replace('/[^a-zA-Z0-9-_]/', '', $file_name_lower);
  $file_name_lower = iconv('utf-8', "us-ascii//TRANSLIT", $file_name_lower);
  $file_name_lower = preg_replace('/[^a-zA-Z0-9-_\.]/', '', $file_name_lower);
  
  
  /*
  $row2 = $paths->fetch_assoc();
  $file_name = $row2['ead_file'];  
  $file_name = preg_replace('/_/','-',$file_name);
  $file_name = pathinfo($file_name);
  */
  //$i++; 
  
  $zip->addFromString(strval($file_name_lower . ".xml"), $row['eac_xml']);
 
}
$zip->close();


?>
<div class="pure-u-1">
  <div class="content_box">
  <img src="style/images/export.png" alt="Convert" width="24px" height="24px"/>
 
 <h1> <a href="export/ramp-export.zip">Download Batch Export of EAC-CPF Files</a></h1>
  <p style="margin-top:.5%">

  </p>

</div>
</div>
<?php
include('footer.php');
?>