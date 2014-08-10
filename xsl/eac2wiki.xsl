<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:eac="urn:isbn:1-931666-33-4" 
    xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns:library="http://purl.org/library/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:schema="http://schema.org/"
    xmlns:exsl="http://exslt.org/common" 
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    extension-element-prefixes="exsl" exclude-result-prefixes="eac" version="1.0">    
    <!--
        Author: Timothy A. Thompson
        University of Miami Libraries
        Copyright 2013 University of Miami. Licensed under the Educational Community License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://opensource.org/licenses/ECL-2.0 http://www.osedu.org/licenses/ECL-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
    -->
    <!--
        eac2wiki.xsl creates wiki markup from EAC-CPF/XML. 
    -->
    
    <!-- Import additional params. -->
    <xsl:import href="eac2wiki_modules/eac2wiki_params.xsl" />
    
    <!-- String parsing templates. -->
    <xsl:include href="eac2wiki_modules/eac2wiki_utils.xsl"/>
        
    <xsl:output method="text" indent="yes" encoding="UTF-8" />
    
    <xsl:template match="/">
        <!-- Check to see whether we are creating a person record. -->
        <xsl:choose>
            <xsl:when test="eac:eac-cpf/eac:cpfDescription/eac:identity/eac:entityType[text()='person']">
                <xsl:call-template name="tPerson" />
            </xsl:when>
            <!-- Records for families are not supported at this time. -->
            <xsl:when test="/eac:eac-cpf/eac:cpfDescription/eac:identity/eac:entityType[text()='family']">
                <xsl:text>Conversion to wiki markup is not currently available for family records. Please choose a person or corporate body record for wiki editing.</xsl:text>
            </xsl:when>
            <!-- Otherwise, it's a corporate body record. -->
            <xsl:otherwise>
                <xsl:call-template name="tCorporateBody" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Infoboxes -->
    <xsl:include href="eac2wiki_modules/eac2wiki_persons.xsl"/>   
    <xsl:include href="eac2wiki_modules/eac2wiki_corporate_bodies.xsl"/>
        
    <!-- Wikipedia article outline. -->
    
    <!-- Timeline (optional) -->
    <xsl:include href="eac2wiki_modules/eac2wiki_timelines.xsl"/>
    
    <!-- Works or publications -->
    <xsl:include href="eac2wiki_modules/eac2wiki_works_or_publications.xsl"/>
    
    <!-- See also -->
    <xsl:include href="eac2wiki_modules/eac2wiki_relations.xsl"/>
    
    <!-- Notes and references -->
    <xsl:include href="eac2wiki_modules/eac2wiki_notes_and_references.xsl"/>
    
    <!-- Further reading -->
    <xsl:include href="eac2wiki_modules/eac2wiki_further_reading.xsl"/>
    
    <!-- External links -->    		
    <xsl:include href="eac2wiki_modules/eac2wiki_external_links.xsl"/>
    
    <!-- VIAF or LCCN (Authority control) -->
    <xsl:include href="eac2wiki_modules/eac2wiki_viaf_lccn.xsl"/>
    
    <!-- Persondata -->
    <xsl:include href="eac2wiki_modules/eac2wiki_persondata.xsl"/>
    
    <!-- DEFAULTSORT -->
    <xsl:include href="eac2wiki_modules/eac2wiki_defaultsort.xsl"/>
    
    <!-- Categories -->    
    <xsl:include href="eac2wiki_modules/eac2wiki_categories.xsl"/>
    
    <!-- Process mixed-content elements. -->    
    <xsl:template match="eac:span">                 
        <xsl:text>''</xsl:text>
        <xsl:value-of select="normalize-space(.)" />
        <xsl:text>''</xsl:text>        
    </xsl:template>
    
    <xsl:template match="eac:p">                         
        <xsl:value-of select="normalize-space(.)" />        
    </xsl:template>
    
    <xsl:template match="ead:p">                         
        <xsl:value-of select="normalize-space(.)" />        
    </xsl:template>
    
    <!-- Fetch OCLC RDF for fuller citation templates. -->
    <xsl:include href="eac2wiki_modules/eac2wiki_oclc_rdf_lookup.xsl"/>
    
</xsl:stylesheet>