<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eac="urn:isbn:1-931666-33-4"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings" xmlns:xlink="http://www.w3.org/1999/xlink"
    extension-element-prefixes="exsl str" exclude-result-prefixes="eac ead" version="1.0">

    <!-- Variables for new record form data. -->
    <xsl:variable name="vFrom" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='from']/ead:p"/>
    <xsl:variable name="vTo" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='to']/ead:p"/>
    <xsl:variable name="vGender"
        select="ead:ead/ead:archdesc/ead:did/ead:note[@type='gender']/ead:p"/>
    <xsl:variable name="vGenderDateFrom"
        select="ead:ead/ead:archdesc/ead:did/ead:note[@type='genderDateFrom']/ead:p"/>
    <xsl:variable name="vGenderDateTo"
        select="ead:ead/ead:archdesc/ead:did/ead:note[@type='genderDateTo']/ead:p"/>
    <xsl:variable name="vLangName"
        select="ead:ead/ead:archdesc/ead:did/ead:note[@type='langName']/ead:p"/>
    <xsl:variable name="vLangCode"
        select="ead:ead/ead:archdesc/ead:did/ead:note[@type='langCode']/ead:p"/>
    <xsl:variable name="vScriptName"
        select="ead:ead/ead:archdesc/ead:did/ead:note[@type='scriptName']/ead:p"/>
    <xsl:variable name="vScriptCode"
        select="ead:ead/ead:archdesc/ead:did/ead:note[@type='scriptCode']/ead:p"/>
    <xsl:variable name="vSubject"
        select="ead:ead/ead:archdesc/ead:did/ead:note[@type='subject']/ead:p"/>
    <xsl:variable name="vGenre" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='genre']/ead:p"/>
    <xsl:variable name="vOccupationNew"
        select="ead:ead/ead:archdesc/ead:did/ead:note[@type='occupation']/ead:p"/>
    <xsl:variable name="vOccuDateFrom"
        select="ead:ead/ead:archdesc/ead:did/ead:note[@type='occuDateFrom']/ead:p"/>
    <xsl:variable name="vOccuDateTo"
        select="ead:ead/ead:archdesc/ead:did/ead:note[@type='occuDateTo']/ead:p"/>
    <xsl:variable name="vPlaceEntry"
        select="ead:ead/ead:archdesc/ead:did/ead:note[@type='placeEntry']/ead:p"/>
    <xsl:variable name="vPlaceRole"
        select="ead:ead/ead:archdesc/ead:did/ead:note[@type='placeRole']/ead:p"/>
    <xsl:variable name="vPlaceDateFrom"
        select="ead:ead/ead:archdesc/ead:did/ead:note[@type='placeDateFrom']/ead:p"/>
    <xsl:variable name="vPlaceDateTo"
        select="ead:ead/ead:archdesc/ead:did/ead:note[@type='placeDateTo']/ead:p"/>
    <xsl:variable name="vCitation"
        select="ead:ead/ead:archdesc/ead:did/ead:note[@type='citation']/ead:p"/>
    <xsl:variable name="vCpf" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='cpf']/ead:p"/>
    <xsl:variable name="vResource"
        select="ead:ead/ead:archdesc/ead:did/ead:note[@type='resource']/ead:p"/>
    <xsl:variable name="vResourceID"
        select="ead:ead/ead:archdesc/ead:did/ead:note[@type='resourceID']/ead:p"/>
    <xsl:variable name="vSource"
        select="ead:ead/ead:archdesc/ead:did/ead:note[@type='source']/ead:p"/>

</xsl:stylesheet>
