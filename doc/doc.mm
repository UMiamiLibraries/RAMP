<map version="0.9.0">
<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->
<node text="doc.org" background_color="#00bfff">
<richcontent TYPE="NOTE"><html><head></head><body><p>--org-mode: WHOLE FILE</p></body></html></richcontent>
<node text="Installation" position="left">
<node text="Requirements">
<node style="bubble" background_color="#eeee00">
<richcontent TYPE="NODE"><html>
<head>
<style type="text/css">
<!--
p { margin-top: 3px; margin-bottom: 3px; }-->
</style>
</head>
<body>
<p>- MySQL 5.1.5+ <br />- PHP 5+ <br />- php_xsl extension enabled <br />- Apache (other web servers like nginx+php-fpm may work) <br />&#160;&#160;</p></body>
</html>
</richcontent>
</node>
</node>
<node text="Create Database">
<node style="bubble" background_color="#eeee00">
<richcontent TYPE="NODE"><html>
<head>
<style type="text/css">
<!--
p { margin-top: 3px; margin-bottom: 3px; }-->
</style>
</head>
<body>
<p><br />The 'ramp/sql' folder contains a .sql file that can be used to create the database that RAMP requires. </p><p>#+BEGIN_SRC sh<br />mysqldump -u username -ppassword --host=hostname ramp &lt; ramp.sql<br />#+END_SRC<br /></p></body>
</html>
</richcontent>
</node>
</node>
<node text="Update db.php">
<node style="bubble" background_color="#eeee00">
<richcontent TYPE="NODE"><html>
<head>
<style type="text/css">
<!--
p { margin-top: 3px; margin-bottom: 3px; }-->
</style>
</head>
<body>
<p><br />Before using RAMP, change the 'ramp/conf/db.php' to reflect your current database connection information. <br /></p></body>
</html>
</richcontent>
</node>
</node>
<node text="Add EAD Records">
<node style="bubble" background_color="#eeee00">
<richcontent TYPE="NODE"><html>
<head>
<style type="text/css">
<!--
p { margin-top: 3px; margin-bottom: 3px; }-->
</style>
</head>
<body>
<p><br />Before using the RAMP, the 'ead' folder should have correct read/write permissions set.</p><p>#+BEGIN_SRC sh<br />chown -R www-data ramp/ead<br />chmod 2755 ramp/ead <br />#+END_SRC</p><p>This folder should contain all the EAD files that you want to work with.<br /></p></body>
</html>
</richcontent>
</node>
</node>
<node text="Update configuration files">
<node style="bubble" background_color="#eeee00">
<richcontent TYPE="NODE"><html>
<head>
<style type="text/css">
<!--
p { margin-top: 3px; margin-bottom: 3px; }-->
</style>
</head>
<body>
<p></p><p>&#160;&#160;&#160;</p></body>
</html>
</richcontent>
</node>
</node>
</node>
<node text="Usage">
<node text="EAD to EAC Conversion">
<node style="bubble" background_color="#eeee00">
<richcontent TYPE="NODE"><html>
<head>
<style type="text/css">
<!--
p { margin-top: 3px; margin-bottom: 3px; }-->
</style>
</head>
<body>
<p>The 'Convert' link leads to a form that allows you to specify the path to EAD files. This path should have appropriate permissions so that the script can read and write files.<br />After submitting the form, the script performs an XSLT transformation on all the files in the folder. After a successful transformation, the original EAD record is imported into the <br />database, along with the newly created EAC-CPF record. When the conversion process is completed the original EAD files are removed. </p><p>If a duplicate EAD files is converted, the user is presented with an interface that displays a graphical diff. The user can choose which elements are merged into the new record.<br /></p></body>
</html>
</richcontent>
</node>
</node>
<node text="Creating a New EAC Records">
<node style="bubble" background_color="#eeee00">
<richcontent TYPE="NODE"><html>
<head>
<style type="text/css">
<!--
p { margin-top: 3px; margin-bottom: 3px; }-->
</style>
</head>
<body>
<p>If you encounter a situation where there are no EAD files to import, RAMP can be used to create new records. The 'New' link leads to a form that allows you to chose what type of entity <br />is being created and an input for a biography. </p><p>If permissions for '/ramp/ead/' are not correctly set, the script will not be able to generate a stub EAD file necessary to create a <br />new EAC record. <br /></p></body>
</html>
</richcontent>
</node>
</node>
<node text="Editing EAC files">
<node style="bubble" background_color="#eeee00">
<richcontent TYPE="NODE"><html>
<head>
<style type="text/css">
<!--
p { margin-top: 3px; margin-bottom: 3px; }-->
</style>
</head>
<body>
<p>The 'Edit' link displays a select box that includes a list of names. Selecting a name loads their EAC record into the editor. A user can manually edit the EAC XML in the editor. <br />During the editing process, the files is monitored and sent to a validation service. If the XML is valid, a green icon is displayed. If the XML is invalid or not well-formed, a red icon <br />and error information is displayed. </p><p>After editing the file, the user can save the XML to the database.<br /></p></body>
</html>
</richcontent>
</node>
</node>
<node text="Ingesting Data from Third-Party Sources">
<node style="bubble" background_color="#eeee00">
<richcontent TYPE="NODE"><html>
<head>
<style type="text/css">
<!--
p { margin-top: 3px; margin-bottom: 3px; }-->
</style>
</head>
<body>
<p>One of the major features of RAMP is the ability to ingest data from third-party sources. Currently a user can ingest data from OCLC Identities and VIAF. During the ingest, <br />the user is presented with a list of possible matches. After selecting appropriate matches, data from the services is inserted into the EAC XML. At this point, the user could<br />edit the ingested data, but this is not required. <br /></p></body>
</html>
</richcontent>
</node>
</node>
<node text="Working with Mediawiki Markup">
<node style="bubble" background_color="#eeee00">
<richcontent TYPE="NODE"><html>
<head>
<style type="text/css">
<!--
p { margin-top: 3px; margin-bottom: 3px; }-->
</style>
</head>
<body>
<p>After ingestion, the user can convert the EAC record to Mediawiki Markup. They are presented with a different editor for working with the Mediawiki markup. <br /></p></body>
</html>
</richcontent>
</node>
</node>
<node text="Submitting Wiki article to Wikipedia">
<node style="bubble" background_color="#eeee00">
<richcontent TYPE="NODE"><html>
<head>
<style type="text/css">
<!--
p { margin-top: 3px; margin-bottom: 3px; }-->
</style>
</head>
<body>
<p>Before submitting the generated Wiki article to Wikipedia, the user must use the 'Get Existing Wiki' button to check if Wikipedia has an existing article for the entity. If there <br />is an existing article they are presented with the generated and existing articles side by side. They can highlight a section of either article and transfer if to the other side<br />by using arrow buttons. </p><p>Finally, the user can submit the generated article to Wikipedia.</p></body>
</html>
</richcontent>
</node>
</node>
</node>
</node>
</map>
