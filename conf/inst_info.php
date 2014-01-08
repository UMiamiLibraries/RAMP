<?php

/*
   The parameters in this file can be set for use in the ead2eac.xsl stylesheet.
   
   For the eac2wiki.xsl stylesheet, eac2wikiParameters.xsl contains additional parameters. In eac2wikiParameters.xsl, you will want to change the value of the following two parameters:  
   
   (1) "pDiscServ" stores a URL for a local discovery service (e.g., Summon) in order to add a link to the wiki markup in the "External links" section. 
   
   (2) "pFindingAidInfo" stores publication info (like institution name, place, and date) for finding aid citations in the wiki markup "Notes and references" section. 

   --timathom
*/

$agency_code = "ABC-D"; // "The code that represents the institution or service responsible for the creation, maintenance and/or dissemination of the EAC-CPF instance."
$other_agency_code = "XYZ"; // "Alternate code representing the instituion or service responsible for the creation, maintenance, and/or dissemination of the EAC-CPF instance."
$agency_name = "University of ABC"; // Name displayed in the RAMP footer and in "agencyName" element.
$short_agency_name = "ABC"; // Abbreviation of institution's name; for example, used in "otherRecordId" @localType for merged records.
$serverName = "abc_server"; // Name of server where EAD finding aids are hosted (e.g., "proust" or "gryphon"). Helps filter out "ead:extref" data in ead2eac.xsl.
$localURL = "http://"; // Base URL for local finding aids: i.e., whatever precedes the finding aid's unique ID in the URL string.
$repositoryOne = "REPO1"; // Abbreviation for local archival repository. Can be used to help filter out "ead:relatedmaterials" data in ead2eac.xsl.
$repositoryTwo = "REPO2"; // Abbreviation for local archival repository. Can be used to help filter out "ead:relatedmaterials" data in ead2eac.xsl.

// Different possible "eventDescription" values that can be set in ead2eac.xsl.
$eventDescDerive = "New EAC-CPF record derived from EAD instance and existing EAC-CPF record."; 
$eventDescCreate = "Record created.";
$eventDescRevise = "Record revised.";
$eventDescExport = "Record exported as EAC-CPF/XML.";
//$eventDescRAMP = "Record created in RAMP."; // Removed because created Diff conflict. --timathom
?>
