<?php
$agency_code = "ABC-D"; // "The code that represents the institution or service responsible for the creation, maintenance and/or dissemination of the EAC-CPF instance."
$other_agency_code = "XYZ"; // "Alternate code representing the instituion or service responsible for the creation, maintenance, and/or dissemination of the EAC-CPF instance."
$agency_name = "University of ABC"; // Name display in the RAMP footer
$short_agency_name = "ABC"; // Abbreviation of institution's name; for example, used in "otherRecordId" @localType for merged records.
$serverName = "abc_server"; // Name of server where EAD finding aids are hosted (e.g., "proust" or "gryphon"). Helps filter out "ead:extref" data in ead2eac.xsl.
$localURL = "http://abcuniversity.edu/?id="; // Base URL for local finding aids: i.e., whatever precedes the finding aid's unique ID in the URL string.
$repositoryOne = "REPO1"; // Abbreviation for local archival repository. Can be used to help filter out "ead:relatedmaterials" data in ead2eac.xsl.
$repositoryTwo = "REPO2"; // Abbreviation for local archival repository. Can be used to help filter out "ead:relatedmaterials" data in ead2eac.xsl.

// Different possible "eventDescription" values that can be set in ead2eac.xsl
$eventDescDerive = "New EAC-CPF record derived from EAD instance and existing EAC-CPF record."; 
$eventDescCreate = "Record created.";
$eventDescRevise = "Record revised.";
$eventDescExport = "Record exported as EAC-CPF/XML.";
//$eventDescRAMP = "Record created in RAMP."; // Removed because created Diff conflict. --timathom
?>