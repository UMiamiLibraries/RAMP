RAMP
====
<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#sec-1">1 Installation</a>
<ul>
<li><a href="#sec-1-1">1.1 Requirements</a></li>
<li><a href="#sec-1-2">1.2 Create the RAMP Database</a></li>
<li><a href="#sec-1-3">1.3 Update db.php and Configuration Files</a>
<ul>
<li><a href="#sec-1-3-1">1.3.1 Other Configuration Files</a></li>
</ul>
</li>
<li><a href="#sec-1-4">1.4 Add EAD Records</a></li>
</ul>
</li>
<li><a href="#sec-2">2 Usage</a>
<ul>
<li><a href="#sec-2-1">2.1 EAD to EAC Conversion</a></li>
<li><a href="#sec-2-2">2.2 Creating a New EAC Records</a></li>
<li><a href="#sec-2-3">2.3 Editing EAC Files</a></li>
<li><a href="#sec-2-4">2.4 Ingesting Data from Third-Party Sources</a></li>
<li><a href="#sec-2-5">2.5 Working with Mediawiki Markup</a></li>
<li><a href="#sec-2-6">2.6 Submitting Wiki Article to Wikipedia</a></li>
</ul>
</li>
</ul>
</div>
</div>

<div id="outline-container-1" class="outline-2">
<h2 id="sec-1"><span class="section-number-2">1</span> Installation</h2>
<div class="outline-text-2" id="text-1">


</div>

<div id="outline-container-1-1" class="outline-3">
<h3 id="sec-1-1"><span class="section-number-3">1.1</span> Requirements</h3>
<div class="outline-text-3" id="text-1-1">

<ul>
<li>MySQL 5.1.5+ 
</li>
<li>PHP 5+ 
</li>
<li>php_xsl extension enabled 
</li>
<li>php_curl extension enabled 
</li>
<li>Apache (other web servers like nginx+php-fpm may work) 
</li>
</ul>


</div>

</div>

<div id="outline-container-1-2" class="outline-3">
<h3 id="sec-1-2"><span class="section-number-3">1.2</span> Create the RAMP Database</h3>
<div class="outline-text-3" id="text-1-2">


<p>   
   The 'ramp/sql' folder contains a .sql file that can be used to create the database that RAMP requires. 
</p>



<pre class="example">mysql -u username -ppassword --host=hostname ramp &lt; ramp.sql
</pre>


</div>

</div>

<div id="outline-container-1-3" class="outline-3">
<h3 id="sec-1-3"><span class="section-number-3">1.3</span> Update db.php and Configuration Files</h3>
<div class="outline-text-3" id="text-1-3">


<p>   
   Before using RAMP, change the 'ramp/conf/db.php' to reflect your current database connection information. 
</p>

</div>

<div id="outline-container-1-3-1" class="outline-4">
<h4 id="sec-1-3-1"><span class="section-number-4">1.3.1</span> Other Configuration Files</h4>
<div class="outline-text-4" id="text-1-3-1">

<ul>
<li>inst_info.php

<p>
  This file includes institutional information that appears in the EAC files.
</p></li>
<li>xsl.php, paths.php

<p>
  These files include the paths to XSL stylesheets.
</p></li>
</ul>


</div>
</div>

</div>

<div id="outline-container-1-4" class="outline-3">
<h3 id="sec-1-4"><span class="section-number-3">1.4</span> Add EAD Records</h3>
<div class="outline-text-3" id="text-1-4">


<p>   
   Before using the RAMP, the 'ead' folder should have correct read/write permissions set.
</p>



<pre class="example">chown -R www-data ramp/ead
chmod 2755 ramp/ead 
</pre>


<p>   
   This folder should contain all the EAD files that you want to work with.
</p>
</div>
</div>

</div>

<div id="outline-container-2" class="outline-2">
<h2 id="sec-2"><span class="section-number-2">2</span> Usage</h2>
<div class="outline-text-2" id="text-2">


</div>

<div id="outline-container-2-1" class="outline-3">
<h3 id="sec-2-1"><span class="section-number-3">2.1</span> EAD to EAC Conversion</h3>
<div class="outline-text-3" id="text-2-1">

<p>   The 'Convert' link leads to a form that allows you to specify the path to EAD files. This path should have appropriate permissions so that the script can read and write files.
   After submitting the form, the script performs an XSLT transformation on all the files in the folder. After a successful transformation, the original EAD record is imported into the 
   database, along with the newly created EAC-CPF record. When the conversion process is completed the original EAD files are removed. 
</p>
<p>
   If a duplicate EAD files is converted, the user is presented with an interface that displays a graphical diff. The user can choose which elements are merged into the new record.
</p>
</div>

</div>

<div id="outline-container-2-2" class="outline-3">
<h3 id="sec-2-2"><span class="section-number-3">2.2</span> Creating a New EAC Records</h3>
<div class="outline-text-3" id="text-2-2">

<p>   If you encounter a situation where there are no EAD files to import, RAMP can be used to create new records. The 'New' link leads to a form that allows you to chose what type of entity 
   is being created and an input for a biography. 
</p>
<p>
   If permissions for '<i>ramp/ead</i>' are not correctly set, the script will not be able to write a stub EAD file necessary to create a 
   new EAC record. 
</p>
</div>

</div>

<div id="outline-container-2-3" class="outline-3">
<h3 id="sec-2-3"><span class="section-number-3">2.3</span> Editing EAC Files</h3>
<div class="outline-text-3" id="text-2-3">

<p>   The 'Edit' link displays a select box that includes a list of names. Selecting a name loads their EAC record into the editor. A user can manually edit the EAC XML in the editor. 
   During the editing process, the files is monitored and sent to a validation service. If the XML is valid, a green icon is displayed. If the XML is invalid or not well-formed, a red icon 
   and error information is displayed. 
</p>
<p>
   After editing the file, the user can save the XML to the database.
</p>
</div>

</div>

<div id="outline-container-2-4" class="outline-3">
<h3 id="sec-2-4"><span class="section-number-3">2.4</span> Ingesting Data from Third-Party Sources</h3>
<div class="outline-text-3" id="text-2-4">

<p>   One of the major features of RAMP is the ability to ingest data from third-party sources. Currently a user can ingest data from OCLC Identities and VIAF. During the ingest, 
   the user is presented with a list of possible matches. After selecting appropriate matches, data from the services is inserted into the EAC XML. At this point, the user could
   edit the ingested data, but this is not required. 
</p>
</div>

</div>

<div id="outline-container-2-5" class="outline-3">
<h3 id="sec-2-5"><span class="section-number-3">2.5</span> Working with Mediawiki Markup</h3>
<div class="outline-text-3" id="text-2-5">

<p>   After ingestion, the user can convert the EAC record to Mediawiki Markup. They are presented with a different editor for working with the Mediawiki markup. 
</p>
</div>

</div>

<div id="outline-container-2-6" class="outline-3">
<h3 id="sec-2-6"><span class="section-number-3">2.6</span> Submitting Wiki Article to Wikipedia</h3>
<div class="outline-text-3" id="text-2-6">

<p>   Before submitting the generated Wiki article to Wikipedia, the user must use the 'Get Existing Wiki' button to check if Wikipedia has an existing article for the entity. If there 
   is an existing article they are presented with the generated and existing articles side by side. They can highlight a section of either article and transfer if to the other side
   by using arrow buttons. 
</p>
<p>
   Finally, the user can submit the generated article to Wikipedia. 
</p></div>
</div>
</div>
</div>
