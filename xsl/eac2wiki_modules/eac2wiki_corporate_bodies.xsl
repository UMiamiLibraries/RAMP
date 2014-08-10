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
    
    <!-- Call templates for corporate bodies. -->
    <xsl:template name="tCorporateBody">
        <!-- Infobox -->
        <xsl:call-template name="tCBodyInfobox" />
        <!-- Lede -->
        <xsl:text>&#10;</xsl:text>
        <xsl:text>'''</xsl:text>
        <xsl:call-template name="tParseName2">
            <xsl:with-param name="pNameType">corporate</xsl:with-param>
            <xsl:with-param name="pCorpName" select="$pCorpName" />
        </xsl:call-template>
        <xsl:text>''' ...</xsl:text>
    	<xsl:text>&#10;</xsl:text>
        <!-- History -->
    	<xsl:text>&#10;</xsl:text>
        <xsl:text>==History==</xsl:text>
    	<xsl:text>&#10;</xsl:text>        
        <xsl:if test="$pBiogHist/eac:abstract">
            <xsl:text>&lt;!-- The following abstract (commented out) may include additional content to incorporate into the article history section. Otherwise, it may be deleted. --&gt;</xsl:text>
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
        <xsl:if test="$pBiogHist/eac:chronList/eac:chronItem">
            <xsl:call-template name="tTimeline" />
        </xsl:if>
        <!-- Corporate Structure -->
        <xsl:if test="eac:eac-cpf/eac:cpfDescription/eac:description/eac:structureOrGenealogy">
            <xsl:for-each select="eac:eac-cpf/eac:cpfDescription/eac:description/eac:structureOrGenealogy/eac:p">
                <p>
                    <xsl:value-of select="." />
                </p>
            </xsl:for-each>
        </xsl:if>
        <!-- Publications -->
        <xsl:call-template name="tPub" />
        <!-- Relations -->
        <xsl:if test="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:cpfRelation | eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType='subject'] | eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType[contains(.,'7')]] | eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType[contains(.,'610')]]">
            <xsl:call-template name="tRelations">
                <xsl:with-param name="pNameType">corporate</xsl:with-param>
                <xsl:with-param name="pCorpName" select="$pCorpName" />
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
        <!-- Default sort -->
        <xsl:call-template name="tDefaultSort">
            <xsl:with-param name="pCorpName" select="$pCorpName" />                       
        </xsl:call-template>
        <!-- Categories -->
        <xsl:call-template name="tCategories">
            <xsl:with-param name="pNameType">corporate</xsl:with-param>
            <xsl:with-param name="pCorpName" select="$pCorpName" />
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
    
    <!-- Output Infobox for corporate bodies. -->
    <xsl:template name="tCBodyInfobox">
        <xsl:text>&lt;!-- </xsl:text>        
        <xsl:text>This article contains metadata extracted by the [[Wikipedia:Tools/RAMP_editor|RAMP editor]]. Text extracted by the RAMP editor is released under a [[Template:Cc-by-sa-3.0|Creative Commons Attribution-ShareAlike 3.0]] and [[Template:GFDL|GNU Free Documentation]] license. Bibliographic data from [http://www.worldcat.org/ OCLC WorldCat], made available under the [http://opendatacommons.org/licenses/by/1.0/ Open Data Commons Attribution License] (ODC-By), is also utilized. Please improve this article in any way you see fit.</xsl:text>        
        <xsl:text> --&gt;</xsl:text>
        <xsl:text>&#10;</xsl:text>  
        <xsl:text>{{Infobox organization</xsl:text>
        <xsl:text>&#09;</xsl:text>
        <xsl:text>&lt;!-- See https://en.wikipedia.org/wiki/Template:Infobox_organization for complete template. Note: Wikipedia supports a variety of different Infobox templates, and a more specific may be appropriate for this organization (for example, {{Infobox university}}). --&gt;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| name</xsl:text>
        <xsl:text>&#09;&#09;&#09;&#09;= </xsl:text>
        <xsl:call-template name="tParseName">
            <xsl:with-param name="pNameType">corporate</xsl:with-param>
            <xsl:with-param name="pCorpName" select="$pCorpName" />
        </xsl:call-template>
        <xsl:text>| extinction</xsl:text>
        <xsl:text>&#09;&#09;&#09;= </xsl:text>
        <xsl:text> &lt;!-- Date of extinction, optional --&gt; </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| merger</xsl:text>
        <xsl:text>&#09;&#09;&#09;&#09;= </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| merged</xsl:text>
        <xsl:text>&#09;&#09;&#09;&#09;= </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| type</xsl:text>
        <xsl:text>&#09;&#09;&#09;&#09;= </xsl:text>
        <xsl:text> &lt;!-- [[Governmental organization|GO]], [[Non-governmental organization|NGO]], etc. --&gt; </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| status</xsl:text>
        <xsl:text>&#09;&#09;&#09;&#09;= </xsl:text>
        <xsl:text> &lt;!-- Ad hoc, treaty, foundation, etc. --&gt; </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| purpose</xsl:text>
        <xsl:text>&#09;&#09;&#09;= </xsl:text>
        <xsl:text> &lt;!-- focus as e.g. humanitarian, peacekeeping, etc. --&gt; </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| headquarters</xsl:text>
        <xsl:text>&#09;&#09;= </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| location</xsl:text>
        <xsl:text>&#09;&#09;&#09;= </xsl:text>
        <xsl:choose>
            <xsl:when test="/eac:eac-cpf/eac:cpfDescription/eac:description/eac:place/eac:placeEntry  !=  ''">
                <xsl:value-of select="normalize-space(/eac:eac-cpf/eac:cpfDescription/eac:description/eac:place/eac:placeEntry)" />
                <xsl:text>&#10;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>&#10;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>| coords</xsl:text>
        <xsl:text>&#09;&#09;&#09;&#09;= </xsl:text>
        <xsl:text> &lt;!-- Coordinates of location using a coordinates template --&gt; </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| region_served</xsl:text>
        <xsl:text>&#09;&#09;= </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| membership</xsl:text>
        <xsl:text>&#09;&#09;&#09;= </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| language</xsl:text>
        <xsl:text>&#09;&#09;&#09;= </xsl:text>
        <xsl:text> &lt;!-- Official languages --&gt; </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| leader_title</xsl:text>
        <xsl:text>&#09;&#09;&#09;= </xsl:text>
        <xsl:text> &lt;!-- Position title for the leader of the org. --&gt; </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| leader_name</xsl:text>
        <xsl:text>&#09;&#09;= </xsl:text>
        <xsl:text> &lt;!-- Name of leader --&gt; </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| key_people</xsl:text>
        <xsl:text>&#09;&#09;&#09;= </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| main_organ</xsl:text>
        <xsl:text>&#09;&#09;&#09;= </xsl:text>
        <xsl:text> &lt;!-- General assembly, board of directors, etc. --&gt; </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| parent_organization</xsl:text>
        <xsl:text>&#09;= </xsl:text>
        <xsl:text> &lt;!-- If exists --&gt; </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| affiliations</xsl:text>
        <xsl:text>&#09;&#09;&#09;= </xsl:text>
        <xsl:text> &lt;!-- If any --&gt; </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| budget</xsl:text>
        <xsl:text>&#09;&#09;&#09;&#09;= </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| num_staff</xsl:text>
        <xsl:text>&#09;&#09;&#09;= </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| num_volunteers</xsl:text>
        <xsl:text>&#09;&#09;= </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| website</xsl:text>
        <xsl:text>&#09;&#09;&#09;&#09;= </xsl:text>
        <xsl:text> &lt;!-- {{URL|}} --&gt; </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>}}</xsl:text>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>
</xsl:stylesheet>