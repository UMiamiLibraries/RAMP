RAMP 
===================

## Introduction

   The Remixing Archival Metadata Project (RAMP) is a lightweight web-based editing tool that lets users do two things: (1) generate enhanced authority records for creators of archival collections and (2) publish the content of those records as Wikipedia pages. The RAMP editor first extracts biographical and historical data from EAD finding aids to create new authority records for persons, corporate bodies, and families associated with archival and special collections. It then lets users enhance those records with additional data from sources like VIAF and WorldCat Identities. Finally, it transforms those records into biographical pages for direct publication to Wikipedia through its API. 

## 1 Installation

### 1.1 Requirements

  * MySQL 5.1.5+ 
  * PHP 5+ 
  * php_xsl extension enabled 
  * php_curl extension enabled 
  * Apache (other web servers like nginx+php-fpm may work) 


### 1.2 Create the RAMP Database

   The 'RAMP/sql' folder contains a .sql file that can be used to create
   the database that RAMP requires. This file can be imported using a database management utility like phpMyAdmin, or from the command line:
   
    mysql --user=username --password --host=hostname < sql/ramp.sql

### 1.3 Update db.php and Configuration Files
   Before using RAMP, change the 'conf/db.php' to reflect your current
   database connection information. 

#### 1.3.1 Other Configuration Files

  * inst_info.php

  This file includes institutional information that appears in the EAC
  files.

  * xsl.php, paths.php

    These files include the paths to XSL stylesheets.

### 1.4 Add EAD Records
   Before using the RAMP, you will need to create a new 'ead' folder in the RAMP root directory. This folder should have correct read/write permissions set.
   
     chown -R www-data ead
     chmod 2755 ead
     
   This folder should contain all the EAD files that you want to work with.

## 2 Usage

### 2.1 EAD to EAC Conversion
   The 'Convert' link leads to a form that allows you to specify the path
   to EAD files. This path should have appropriate permissions so that the
   script can read and write files.
   
   Note: if you receive an error when trying to run the conversion routine, you may need to edit your php.ini settings to change the value of 'short_open_tag' to 'Off.'
   
   After submitting the form, the script performs an XSLT transformation on
   all the files in the folder. After a successful transformation, the
   original EAD record is imported into the 
   database, along with the newly created EAC-CPF record. When the
   conversion process is completed the original EAD files are removed. 
   If a duplicate EAD file is converted, the user is presented with an
   interface that displays a graphical diff. The user can choose which
   elements are merged into the new record.

### 2.2 Creating a New EAC Record
   If you encounter a situation where there are no EAD files to import,
   RAMP can be used to create new records. The 'New' link leads to a form that
   allows you to chose what type of entity is being created and an input for a biography. 
   If permissions for 'ramp/ead' are not correctly set, the script will not
   be able to write a stub EAD file necessary to create a new EAC record. 

### 2.3 Editing EAC Files
   The 'Edit' link displays a select box that includes a list of names.
   Selecting a name loads their EAC record into the editor. A user can
   manually edit the EAC XML in the editor. 
   During the editing process, the files are monitored and sent to a
   validation service. If the XML is valid, a green icon is displayed. If the
   XML is invalid or not well-formed, a red icon and error information is displayed. 
   After editing the file, the user can save the XML to the database.

### 2.4 Ingesting Data from Third-Party Sources
   One of the major features of RAMP is the ability to ingest data from
   third-party sources. Currently a user can ingest data from OCLC Identities
   and VIAF. During the ingest, 
   the user is presented with a list of possible matches. After selecting
   appropriate matches, data from the services is inserted into the EAC XML.
   At this point, the user could
   edit the ingested data, but this is not required. 

### 2.5 Working with Mediawiki Markup
   After ingestion, the user can convert the EAC record to Mediawiki
   Markup. They are presented with a different editor for working with the
   Mediawiki markup. 

### 2.6 Submitting Wiki Article to Wikipedia
   Before submitting the generated Wiki article to Wikipedia, the user must
   use the 'Get Existing Wiki' button to check if Wikipedia has an existing
   article for the entity. If there 
   is an existing article they are presented with the generated and
   existing articles side by side. They can highlight a section of either
   article and transfer if to the other side
   by using arrow buttons. 
   Finally, the user can submit the generated article to Wikipedia. 

#### 2.6.1 Saving Draft Articles to Wikipedia
   RAMP facilitates the editing process by letting users save Wikipedia-hosted drafts of their articles. For example, rather than editing and posting new content directly to http://en.wikipedia.org/wiki/Lydia_Cabrera, RAMP users can check the 'Draft' box to save their work-in-progress to a subpage of their Wikipedia user homepage (like http://en.wikipedia.org/wiki/User:Username/Lydia_Cabrera).
