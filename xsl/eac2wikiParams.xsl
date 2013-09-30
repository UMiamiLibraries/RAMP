<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eac="urn:isbn:1-931666-33-4"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="exsl" exclude-result-prefixes="eac" version="1.0">
    
    <!--
        Author: Timothy A. Thompson
        University of Miami Libraries
        Copyright 2013 University of Miami. Licensed under the Educational Community License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://opensource.org/licenses/ECL-2.0 http://www.osedu.org/licenses/ECL-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
    -->
    
    <!--
        eac2wikiParams.xsl stores parameters and variables used by eac2wiki.xsl for creating wiki markup from EAC-CPF/XML. 
    -->
    
    
    <!-- Store names for persons and corporate bodies. -->
    <xsl:param name="pPersName"
        select="normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[1][preceding-sibling::eac:entityType='person']/eac:part)"/>
    
    <xsl:param name="pCorpName"
        select="normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[1][preceding-sibling::eac:entityType='corporateBody']/eac:part)"/>
    
    <!-- Wiki entries for families are not supported at this time.
    <xsl:param name="famName"
        select="normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[preceding-sibling::eac:entityType='family']/eac:part)"/>
    -->
    
    <!-- URL for local discovery service query. -->
    <xsl:param name="pDiscServ">http://miami.summon.serialssolutions.com/search?spellcheck=true&amp;s.q=</xsl:param>
    
    <!-- Declare variables for basic pattern matching. -->    
    <xsl:variable name="vUpper" select="'AÁÀBCDEÉÈFGHIÍJKLMNÑOÓPQRŔSTUÚÜVWXYZ'"/>
    
    <xsl:variable name="vLower" select="'aáàbcdeéèfghiíjklmnñoópqrstuúüvwxyz'"/>
    
    <xsl:variable name="vAlpha" select="concat($vUpper,$vLower,$vPunct)"/>
    
    <xsl:variable name="vDigits" select="'0123456789'"/>
    
    <xsl:variable name="vPunct" select="';:.¿?!()[]-“”’'"/>
    
    <xsl:variable name="vPunct2" select="',.'"/>
    
    <xsl:variable name="vCommaSpace" select="', '"/>       
    
    <!-- Names of months for matching birth and death dates (not currently implemented). -->
    <xsl:param name="pMonths">
        <m>January</m>
        <m>February</m>
        <m>March</m>
        <m>April</m>
        <m>May</m>
        <m>June</m>
        <m>July</m>
        <m>August</m>
        <m>September</m>
        <m>October</m>
        <m>November</m>
        <m>December</m>
    </xsl:param>
    
    <!-- Match individual months. -->
    <xsl:variable name="vMonths" select="document('')/*/xsl:param[@name='pMonths']/*"/>
    
    <!-- Store text of biogHist for matching purposes. -->
    <xsl:param name="pBiogHist" select="/eac:eac-cpf/eac:cpfDescription/eac:description/eac:biogHist"/>
    
    <!-- Some common professions and org types for matching. This functionality is still in development and has not yet been included in the eac2wiki.xsl transformation scenario. --> 
    <xsl:param name="pProfessions">
        <pro>academic</pro>
        <pro>activist</pro>
        <pro>anthropologist</pro>
        <pro>artist</pro>
        <pro>dancer</pro>
        <pro>essayist</pro>
        <pro>faculty</pro>
        <pro>journalist</pro>
        <pro>novelist</pro>
        <pro>poet</pro>
        <pro>politician</pro>
        <pro>scholar</pro>
        <pro>soldier</pro>
        <pro>statesman</pro>
        <pro>writer</pro>                
    </xsl:param>
    
    <!-- Match individual professions. -->
    <xsl:variable name="vProfessions" select="document('')/*/xsl:param[@name='pProfessions']/*"/>
    
    <xsl:param name="pOrganizations">
        <org>academic</org>
        <org>civic</org>
        <org>educational</org>
        <org>military</org>
        <org>nonprofit</org>
        <org>paramilitary</org>
        <org>political</org>
        <org>woman's</org>        
    </xsl:param>
    
    <!-- Match individual org types. -->
    <xsl:variable name="vOrganizations" select="document('')/*/xsl:param[@name='pOrganizations']/*"/>
    
</xsl:stylesheet>