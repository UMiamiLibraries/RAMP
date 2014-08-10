<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eac="urn:isbn:1-931666-33-4"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:exsl="http://exslt.org/common"
    xmlns:xlink="http://www.w3.org/1999/xlink" extension-element-prefixes="exsl"
    exclude-result-prefixes="eac" version="1.0">
    
    <!--
        Author: Timothy A. Thompson
        University of Miami Libraries
        Copyright 2013 University of Miami. Licensed under the Educational Community License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://opensource.org/licenses/ECL-2.0 http://www.osedu.org/licenses/ECL-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
    -->

    <!--
        eac2wiki_params.xsl stores additional parameters used by eac2wiki.xsl for creating wiki markup from EAC-CPF/XML. 
    -->

    <!-- Store names for persons and corporate bodies. -->        
    <xsl:param name="pPersName"
        select="normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[1][preceding-sibling::eac:entityType='person']/eac:part[not(@localType)])"/>

    <xsl:param name="pPersNameSur"
        select="normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[1][preceding-sibling::eac:entityType='person']/eac:part[@localType='surname'])"/>

    <xsl:param name="pPersNameFore"
        select="normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[1][preceding-sibling::eac:entityType='person']/eac:part[@localType='forename'])"/>

    <xsl:param name="pCorpName"
        select="normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[1][preceding-sibling::eac:entityType='corporateBody']/eac:part)"/>

    <!-- Wiki entries for families are not supported at this time.
    <xsl:param name="famName"
        select="normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[preceding-sibling::eac:entityType='family']/eac:part)"/>
    -->

    <!-- URL for local discovery service query. -->
    <xsl:param name="pDiscServ"
        >http://miami.summon.serialssolutions.com/search?spellcheck=true&amp;s.q=</xsl:param>

    <!-- Parameter for finding aid citation info. -->
    <xsl:param name="pFindingAidInfo">         
        <xsl:text>| repository = </xsl:text>
        <xsl:text>University of Miami Libraries </xsl:text>
        <xsl:value-of
            select="substring-after(eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation/eac:objectXMLWrap/ead:archdesc/ead:repository/ead:corpname,'University of Miami ')"/>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| location = </xsl:text>
        <xsl:text>Coral Gables, FL</xsl:text>
        <xsl:text>&#10;</xsl:text>                
    </xsl:param>
    
    <!-- Store text of biogHist for matching purposes. -->
    <xsl:param name="pBiogHist"
        select="/eac:eac-cpf/eac:cpfDescription/eac:description/eac:biogHist"/>

</xsl:stylesheet>
