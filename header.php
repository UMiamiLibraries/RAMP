<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
require_once('autoloader.php');
include('conf/includes.php');
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="author" content="University of Miami Libraries">
    <!-- jQuery & jQuery UI -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/themes/smoothness/jquery-ui.css">

    <!-- Select 2 
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.2-rc.1/css/select2.min.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.2-rc.1/js/select2.min.js"></script>-->
    <script src="script/external/select2/select2.min.js"></script>
    <link rel="stylesheet" type="text/css" href="script/external/select2/select2.css">
    <link rel="stylesheet" type="text/css" href="style/select2-skins.css">

    <!-- Pure, Font Awesome, Lato Font -->
    <link rel="stylesheet" href="http://yui.yahooapis.com/pure/0.6.0/pure-min.css">
    <link rel="stylesheet" href="http://yui.yahooapis.com/pure/0.6.0/grids-responsive-min.css">
    <link rel="stylesheet" href="style/font-awesome.min.css">
    <link href='https://fonts.googleapis.com/css?family=Lato:400,900italic,900,700italic,700,400italic,300italic,300' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" type="text/css" href="style/main.css"/>

    <!-- Ace Editor CSS -->
    <link rel="stylesheet" type="text/css" href="style/ace-editor.css"/>

    <!-- Underscore & Backbone -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.5.0/lodash.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/backbone.js/1.2.3/backbone-min.js"></script>

    <title>RAMP Editor</title>
    <link rel="shortcut icon" href="style/images/favicon.ico"/>
</head>

<body>
<header>
    <div class="inner-area">
        <?php include('includes/menu.php') ?>
    </div>
</header>
<div id="wrap">
    <div id="main_content">


