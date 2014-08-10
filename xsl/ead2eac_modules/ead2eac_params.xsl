<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eac="urn:isbn:1-931666-33-4" xmlns:ead="urn:isbn:1-931666-22-9" xmlns:exsl="http://exslt.org/common" xmlns:str="http://exslt.org/strings" xmlns:xlink="http://www.w3.org/1999/xlink" extension-element-prefixes="exsl str" exclude-result-prefixes="eac ead" version="1.0">
    <!-- Parameters passed from PHP. -->
    <xsl:param name="pRecordId" />
    <xsl:param name="pAgencyCode" />
    <xsl:param name="pOtherAgencyCode" />
    <xsl:param name="pDate" />
    <xsl:param name="pAgencyName" />
    <xsl:param name="pShortAgencyName" />
    <xsl:param name="pArchonEac" />
    <xsl:param name="pServerName" />
    <xsl:param name="pLocalURL" />
    <xsl:param name="pRepositoryOne" />
    <xsl:param name="pRepositoryTwo" />
    <xsl:param name="pEventDescCreate" />
    <xsl:param name="pEventDescRevise" />
    <xsl:param name="pEventDescExport" />
    <xsl:param name="pEventDescDerive" />
    <xsl:param name="pEventDescRAMP" />    
</xsl:stylesheet>