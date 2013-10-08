<?php
include('conf/includes.php');
?>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8"> 
 <style type="text/css">
    .hidden {display:none;}
  </style>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.1/jquery.min.js"></script>
<script type="text/javascript">
    $('html').addClass('hidden');
    $(document).ready(function() {
      $('html').show();
      $(".modal").colorbox({iframe:true, innerWidth:850, innerHeight:600, frameborder:0});           
     });  
   </script>    
<script src="script/main.js"></script>
<script src="script/select2/select2.min.js"></script>
<script src="script/colorbox-master/jquery.colorbox-min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js"></script>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" type="text/css"/>
<link rel="stylesheet" href="style/colorbox-master/example1/colorbox.css" type="text/css"/>
<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,300,600' rel='stylesheet' type='text/css'>
<link rel="stylesheet" href="http://yui.yahooapis.com/pure/0.2.1/pure-min.css">
<link rel="stylesheet" href="script/select2/select2.css">

</style>



<link rel="stylesheet" type="text/css" href="style/main.css"/>
<title>RAMP editor</title>
<head>
<body>
<header>

<span id="title"></span>



<ul id="menu" class="menu_slice">
	<li><a href="./"><img id="logo" src="style/images/logos-02-01.png" alt="RAMP logo: lowercase sans-serif font with an M that mimics the shape of a skate ramp" title="RAMP homepage"/></a></li>

<li id="menu_button">Menu &#9776;</li>
</ul>
<ul id="menu_2" class="menu_slice">
        <li><img src="style/images/convert_white.png" width="24px" height="24px"></img></li>
	<li id="ead_convert" class='menu_slice'><a href="ead_convert.php">Convert</a></li>
        <li><img src="style/images/edit_white.png" width="24px" height="24px"></img></li>

	<li id="eac_edit" class="menu_slice"><a href="#">Edit</a></li>
        <li><img src="style/images/new_white.png" width="24px" height="24px"></img></li>

	<li id="new_eac" class="menu_slice"><a href="new_eac.php">New</a></li>
    
</ul>

<ul id="menu_3" class="menu_slice">
      <li>
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
     </li>
</ul>


</header>
<div id="wrap">
<div id="main_content">
