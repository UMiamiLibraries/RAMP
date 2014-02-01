RAMP 
===================

#### RAMP demo site: http://demo.rampeditor.info

This site has been preloaded with a set of Library of Congress finding aids for testing, plus some newly created records.

## Introduction

  The Remixing Archival Metadata Project (RAMP) is a lightweight web-based editing tool that is intended to let users do two things: (1) generate enhanced authority records for creators of archival collections and (2) publish the content of those records as Wikipedia pages.

The RAMP editor can extract biographical and historical data from EAD finding aids to create new authority records for persons, corporate bodies, and families associated with archival and special collections (using the EAC-CPF format). It can then let users enhance those records with additional data from sources like VIAF and WorldCat Identities. Finally, it can transform those records into wiki markup so that users can edit them directly, merge them with any existing Wikipedia pages, and publish them to Wikipedia through its API.

Read more about RAMP in _[Code4Lib Journal](http://journal.code4lib.org/articles/8962)_.

## 1 Installation

### 1.1 Requirements

  * MySQL 5.1.5+
  * PHP 5+ 
  * php_xsl extension enabled 
  * php_curl extension enabled 
  * Apache (other web servers like nginx+php-fpm may work) 
  * Mozilla Firefox or Google Chrome web browsers. **RAMP is not currently compatible with Internet Explorer**.


### 1.2 Create the RAMP Database

   The `RAMP/sql` folder contains a .sql file that can be used to create
   the database that RAMP requires. This file can be imported using a database management utility like phpMyAdmin, or from the command line:
   
    mysql --user=username --password --host=hostname < sql/ramp.sql

### 1.3 Update db.php and Configuration Files
   Before using RAMP, change the 'conf/db.php' to reflect your current
   database connection information. 

#### 1.3.1 Other Configuration Files

  * `inst_info.php`

  This file includes institutional information that appears in the EAC
  files.

  * `xsl.php`, `paths.php`

    These files include the paths to XSL stylesheets. Settings in these two files should not need to be changed.

### 1.4 Add EAD Records
   The `ead` folder in the RAMP root directory should have correct read/write permissions set.
   
     chown -R www-data ead
     chmod 2755 ead
     
   This folder should contain all the EAD files that you want to work with. **Utilities in the `utils` directory can be used to merge EAD files before importing them into RAMP (designed to work with files exported from the Archon archival management system).**
   
   **Note that in order to be compatible with RAMP, EAD files should have the EAD namespace declared in an `@xmlns` attribute on the `ead` root element**. For example:
     
     <ead audience="external" xmlns="urn:isbn:1-931666-22-9" xmlns:xlink="http://www.w3.org/1999/xlink"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.loc.gov/ead/ http://www.loc.gov/ead/ead.xsd">
       ...
     </ead>
     

## 2 Usage

### 2.1 EAD to EAC Conversion
   The 'Convert' link leads to a form that allows you to specify the path
   to EAD files. This path should have appropriate permissions so that the
   script can read and write files.
   
   **Note**: 
   
   * If you receive a PHP error when trying to run the conversion routine, you may need to edit your `php.ini` settings to change the value of `short_open_tag` to 'Off.'
   * For large EAD files, you will need to increase the size of the `max_allowed_packet` setting in your `my.ini` or `my.cnf` MySQL settings; for example, from '1M' to '2M.'
   
After submitting the form, the script performs an XSLT transformation on
all the files in the folder. After a successful transformation, the
original EAD record is imported into the 
database, along with the newly created EAC-CPF record. If a duplicate EAD file is converted, the user is presented      with an interface that displays a graphical diff. The user can choose which elements to merge into the new record.

### 2.2 Creating a New EAC Record
   If you encounter a situation where there are no EAD files to import,
   RAMP can be used to create new records. The 'New' link leads to a form that
   allows you to chose what type of entity is being created and an input for a biography. 
   If permissions for `ramp/ead` are not correctly set, the script will not
   be able to write a stub EAD file necessary to create a new EAC record. 

### 2.3 Editing EAC Files
   The 'Edit' link displays a select box taht includes a list of names.
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
   
    **Note**: 
   
   * **In order for the VIAF ingest routine to run successfully with large queries, you will need to increase the `max_execution_time` value in your `php.ini` settings. Suggested value is '600.'**  
    
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
   article and transfer it to the other side
   by using arrow buttons. 
   Finally, the user can submit the generated article to Wikipedia. 

#### 2.6.1 Saving Draft Articles to Wikipedia
   RAMP facilitates the editing process by letting users save Wikipedia-hosted drafts of their articles. For example, rather than editing and posting new content directly to http://en.wikipedia.org/wiki/Lydia_Cabrera, RAMP users can click the 'Submit to Wikipedia as Draft' button to save their work-in-progress to a subpage of their Wikipedia user homepage (like http://en.wikipedia.org/wiki/User:Username/Lydia_Cabrera).
