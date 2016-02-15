<?php
include('conf/includes.php');
//error_reporting(E_ALL);
//ini_set('display_errors', 1);
?>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>RAMP editor</title>
 	<style type="text/css">
    	.hidden {display:none;}
  	</style>
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.1/jquery.min.js"></script>
	<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js"></script>

	<script type="text/javascript">
		$('html').addClass('hidden');
		$(document).ready(function() {
			$('html').show();
			$(".modal").colorbox({iframe:true, innerWidth:850, innerHeight:600, frameborder:0});
		 });
	</script>

	<link rel="shortcut icon" href="style/images/favicon.ico"/>

	<link rel="stylesheet" href="//code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" type="text/css"/>
	<link rel="stylesheet" href="style/colorbox-master/example1/colorbox.css" type="text/css"/>
	<link href='//fonts.googleapis.com/css?family=Open+Sans:400,300,600' rel='stylesheet' type='text/css'>
	<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/pure/0.2.1/pure-min.css">
	<link href="//cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/css/select2.min.css" rel="stylesheet" />
	<link rel="stylesheet" type="text/css" href="style/main.css"/>


</head>
<body>
	<header>
		<span id="title"></span>

		<ul id="menu" class="menu_slice">
			<li><a href="./"><img id="logo" src="style/images/logos-02-01.png" alt="RAMP logo: lowercase sans-serif font with an M that mimics the shape of a skate ramp" title="RAMP homepage"/></a></li>
		</ul>
	</header>

	<div id="wrap">
		<div id="main_content">


