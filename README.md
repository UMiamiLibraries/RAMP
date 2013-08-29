RAMP 
===================

## 1) Installation

### 1.1) Requirements

  * MySQL 5.1.5+ 
  * PHP 5+ 
  * php_xsl extension enabled 
  * php_curl extension enabled 
  * Apache (other web servers like nginx+php-fpm may work) 


### 1.2) Create the RAMP Database
     The 'ramp/sql' folder contains a .sql file that can be used to create
   the database that RAMP requires. 
    mysql -u username -ppassword --host=hostname ramp < ramp.sql

### 1.3) Update db.php and Configuration Files
     Before using RAMP, change the 'ramp/conf/db.php' to reflect your current
   database connection information. 

#### 1.3.1) Other Configuration Files

  * inst_info.php

    This file includes institutional information that appears in the EAC
  files.

  * xsl.php, paths.php

    These files include the paths to XSL stylesheets.

### 1.4) Add EAD Records
     Before using the RAMP, the 'ead' folder should have correct read/write
   permissions set.
    chown -R www-data ramp/ead
    chmod 2755 ramp/ead
     This folder should contain all the EAD files that you want to work with.

## 2) Usage

### 2.1) EAD to EAC Conversion
     The 'Convert' link leads to a form that allows you to specify the path
   to EAD files. This path should have appropriate permissions so that the
   script can read and write files.
     After submitting the form, the script performs an XSLT transformation on
   all the files in the folder. After a successful transformation, the
   original EAD record is imported into the 
     database, along with the newly created EAC-CPF record. When the
   conversion process is completed the original EAD files are removed. 
     If a duplicate EAD files is converted, the user is presented with an
   interface that displays a graphical diff. The user can choose which
   elements are merged into the new record.

### 2.2) Creating a New EAC Records
     If you encounter a situation where there are no EAD files to import,
   RAMP can be used to create new records. The 'New' link leads to a form that
   allows you to chose what type of entity 
     is being created and an input for a biography. 
     If permissions for 'ramp/ead' are not correctly set, the script will not
   be able to write a stub EAD file necessary to create a 
     new EAC record. 

### 2.3) Editing EAC Files
     The 'Edit' link displays a select box that includes a list of names.
   Selecting a name loads their EAC record into the editor. A user can
   manually edit the EAC XML in the editor. 
     During the editing process, the files is monitored and sent to a
   validation service. If the XML is valid, a green icon is displayed. If the
   XML is invalid or not well-formed, a red icon 
     and error information is displayed. 
     After editing the file, the user can save the XML to the database.

### 2.4) Ingesting Data from Third-Party Sources
     One of the major features of RAMP is the ability to ingest data from
   third-party sources. Currently a user can ingest data from OCLC Identities
   and VIAF. During the ingest, 
     the user is presented with a list of possible matches. After selecting
   appropriate matches, data from the services is inserted into the EAC XML.
   At this point, the user could
     edit the ingested data, but this is not required. 

### 2.5) Working with Mediawiki Markup
     After ingestion, the user can convert the EAC record to Mediawiki
   Markup. They are presented with a different editor for working with the
   Mediawiki markup. 

### 2.6) Submitting Wiki Article to Wikipedia
     Before submitting the generated Wiki article to Wikipedia, the user must
   use the 'Get Existing Wiki' button to check if Wikipedia has an existing
   article for the entity. If there 
     is an existing article they are presented with the generated and
   existing articles side by side. They can highlight a section of either
   article and transfer if to the other side
     by using arrow buttons. 
     Finally, the user can submit the generated article to Wikipedia. 
