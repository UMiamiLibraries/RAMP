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
    
    <!-- Call templates for persons. -->
    <xsl:template name="tPerson">
        <!-- Infobox -->
        <xsl:call-template name="tPersonInfobox" />
        <!-- Lede -->
        <xsl:text>&#10;</xsl:text>
        <xsl:text>'''</xsl:text>
        <xsl:call-template name="tParseName2">
            <xsl:with-param name="pNameType">person</xsl:with-param>
            <xsl:with-param name="pPersName" select="$pPersName" />
            <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
            <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
        </xsl:call-template>
        <xsl:text>''' ...</xsl:text>
    	<xsl:text>&#10;</xsl:text>
        <!-- Biography -->
    	<xsl:text>&#10;</xsl:text>
        <xsl:text>==Biography==</xsl:text>
    	<xsl:text>&#10;</xsl:text>        
        <xsl:if test="$pBiogHist/eac:abstract">
            <xsl:text>&lt;!-- The following abstract (commented out) may include additional content to incorporate into the article bio section. Otherwise, it may be deleted. --&gt;</xsl:text>
            <xsl:text>&#10;</xsl:text>
            <xsl:text>&#10;</xsl:text>
            <xsl:text>&lt;!-- </xsl:text>
            <xsl:apply-templates select="$pBiogHist/eac:abstract"/>
            <xsl:text> --&gt;</xsl:text>        	
        	<xsl:text>&#10;</xsl:text>
            <xsl:text>&#10;</xsl:text>
        </xsl:if>
        <xsl:for-each select="$pBiogHist/eac:p[. != '']">
            <xsl:apply-templates select="."/>
            <xsl:text>&lt;ref name=RAMP_1/&gt;</xsl:text>
            <xsl:if test="following-sibling::*[1][self::eac:list]">
                <xsl:text>&#10;</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:for-each select="following-sibling::*[1][self::eac:list]/eac:item">
                    <xsl:value-of select="normalize-space(.)" />
                    <xsl:choose>
                        <xsl:when test="position() != last()">
                            <xsl:text>&#10;</xsl:text>
                            <xsl:text>&#10;</xsl:text>
                        </xsl:when>
                        <xsl:otherwise />
                    </xsl:choose>
                </xsl:for-each>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="position() != last()">
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#10;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <!-- Timeline -->
        <xsl:if test="$pBiogHist/eac:chronList/eac:chronItem">
            <xsl:call-template name="tTimeline" />
        </xsl:if>
        <!-- Publications -->
        <xsl:call-template name="tPub" />
        <!-- Relations -->
        <xsl:if test="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:cpfRelation | eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType='subject'] | eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType[contains(.,'7')]] | eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType[contains(.,'610')]]">
            <xsl:call-template name="tRelations">
                <xsl:with-param name="pNameType">person</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <!-- References -->
        <xsl:call-template name="tReferences" />
        <!-- Further reading -->
        <xsl:call-template name="tFurther" />
        <!-- External links -->
        <xsl:call-template name="tExternalLinks" />
        <!-- VIAF -->
        <xsl:call-template name="tVIAF" />
        <!-- Persondata -->
        <xsl:call-template name="tPersonData" />
        <!-- Categories -->
        <xsl:call-template name="tCategories">
            <xsl:with-param name="pNameType">person</xsl:with-param>
            <xsl:with-param name="pPersName" select="$pPersName" />
            <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
            <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
            <xsl:with-param name="pBiogHist" select="$pBiogHist" />
        </xsl:call-template>        
        <xsl:choose>
            <xsl:when test="contains(eac:eac-cpf/eac:control/eac:sources/eac:source/@xlink:href,'loc.mss')">            				            				        		
                <xsl:text>&#10;</xsl:text>                              
            </xsl:when>      
            <xsl:otherwise>
                <xsl:text>&#10;</xsl:text>                
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <!-- Output Infobox for persons. -->
    <xsl:template name="tPersonInfobox">
        <xsl:param name="pPersName" select="$pPersName" />
        <xsl:param name="pPersNameSur" select="$pPersNameSur" />
        <xsl:param name="pPersNameFore" select="$pPersNameFore" />
        <xsl:text>&lt;!-- </xsl:text>        
        <xsl:text>This article contains metadata extracted by the [[Wikipedia:Tools/RAMP_editor|RAMP editor]]. Text extracted by the RAMP editor is released under a [[Template:Cc-by-sa-3.0|Creative Commons Attribution-ShareAlike 3.0]] and [[Template:GFDL|GNU Free Documentation]] license. Bibliographic data from [http://www.worldcat.org/ OCLC WorldCat], made available under the [http://opendatacommons.org/licenses/by/1.0/ Open Data Commons Attribution License] (ODC-By), is also utilized. Please improve this article in any way you see fit.</xsl:text>        
        <xsl:text> --&gt;</xsl:text>
        <xsl:text>&#10;</xsl:text>        
        <xsl:text>{{Infobox person</xsl:text>
        <xsl:text>&#09;</xsl:text>
        <xsl:text>&lt;!-- See http://en.wikipedia.org/wiki/Template:Infobox_person for complete template. Note: Wikipedia supports a variety of different Infobox templates, and a more specific template may be appropriate for this person (for example, {{Infobox writer}}). --&gt;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| name</xsl:text>
        <xsl:text>&#09;&#09;&#09;= </xsl:text>        
        <xsl:call-template name="tParseName">
            <xsl:with-param name="pNameType">person</xsl:with-param>
            <xsl:with-param name="pPersName" select="$pPersName" />
            <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
            <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
        </xsl:call-template>
        <xsl:text>| nationality</xsl:text>
        <xsl:text>&#09;&#09;= </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| other_names</xsl:text>
        <xsl:text>&#09;= </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| ethnicity</xsl:text>
        <xsl:text>&#09;&#09;= </xsl:text>
        <xsl:text> &lt;!-- Ethnicity should be supported with a citation from a reliable source --&gt; </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| citizenship</xsl:text>
        <xsl:text>&#09;&#09;= </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| education</xsl:text>
        <xsl:text>&#09;&#09;= </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| alma_mater</xsl:text>
        <xsl:text>&#09;&#09;= </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| occupation</xsl:text>
        <xsl:text>&#09;&#09;= </xsl:text>
        <xsl:choose>
            <xsl:when test="/eac:eac-cpf/eac:cpfDescription/eac:description/eac:occupation/eac:term  !=  '' or /eac:eac-cpf/eac:cpfDescription/eac:description/eac:occupations/eac:occupation/eac:term  !=  ''">
                <xsl:for-each select="/eac:eac-cpf/eac:cpfDescription/eac:description/eac:occupation|/eac:eac-cpf/eac:cpfDescription/eac:description/eac:occupations/eac:occupation">
                    <xsl:variable name="vOccupationLen" select="string-length(eac:term)" />
                    <xsl:variable name="vOccupation-1" select="substring(eac:term,$vOccupationLen,$vOccupationLen)" />
                    <xsl:choose>
                        <xsl:when test="position() != last()">
                            <xsl:choose>
                                <xsl:when test="$vOccupation-1 = '.'">
                                    <xsl:value-of select="normalize-space(eac:term)" />
                                    <xsl:text> </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(eac:term)" />
                                    <xsl:text>; </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(eac:term)" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:text>&#10;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>&#10;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>| known_for</xsl:text>
        <xsl:text>&#09;&#09;= </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| notable_works</xsl:text>
        <xsl:text>&#09;= </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| religion</xsl:text>
        <xsl:text>&#09;&#09;&#09;= </xsl:text>
        <xsl:text> &lt;!-- Religion should be supported with a citation from a reliable source --&gt; </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| spouse</xsl:text>
        <xsl:text>&#09;&#09;&#09;= </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| partner</xsl:text>
        <xsl:text>&#09;&#09;&#09;= </xsl:text>
        <xsl:text> &lt;!-- Unmarried life partner; use ''Name (1950–present)'' --&gt; </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| children</xsl:text>
        <xsl:text>&#09;&#09;= </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| parents</xsl:text>
        <xsl:text>&#09;&#09;&#09;= </xsl:text>
        <xsl:text> &lt;!-- Use &lt;br /&gt; to separate names --&gt; </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| relatives</xsl:text>
        <xsl:text>&#09;&#09;= </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>}}</xsl:text>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>
</xsl:stylesheet>