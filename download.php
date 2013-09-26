<?php 
header('Content-disposition: attachment; filename="' . $_POST['path'] . '"');
header('Content-type: "text/xml"; charset="utf8"');
header('Content-Type: application/xml');
$xml = $_POST['xml'];
echo $xml;
?>