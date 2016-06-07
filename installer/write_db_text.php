<?php
$writeDbText = function($text) {
    $fp=fopen('conf/db.php','w');
    fwrite($fp, $text);
    fclose($fp);
};
