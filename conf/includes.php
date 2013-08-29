<?php

// Include the file that contains the database connection information
include(dirname(__FILE__) . '/db.php');
// This is the paths for the XSLT
include(dirname(__FILE__) . '/xsl.php');
// This is the path for the EAD files
include(dirname(__FILE__) . '/paths.php');
// This sets the institutional info used in the EAC control section
include(dirname(__FILE__) . '/inst_info.php');

error_reporting(E_ERROR | E_PARSE);

function url_get_contents ($Url) {
    if (!function_exists('curl_init')){
        die('CURL is not installed!');
    }
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $Url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $output = curl_exec($ch);
    curl_close($ch);
    return $output;
}


function get_include_contents($filename) {
    if (is_file($filename)) {
        ob_start();
        include $filename;
        $contents = ob_get_contents();
        ob_end_clean();
        return $contents;
    }
    return false;
}


?>