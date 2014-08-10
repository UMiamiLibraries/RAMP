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
    
    <!-- Output PersonData template. -->
    <xsl:template name="tPersonData">
        <xsl:param name="pPersName" select="$pPersName" />
        <xsl:param name="pPersNameSur" select="$pPersNameSur" />
        <xsl:param name="pPersNameFore" select="$pPersNameFore" />
        <xsl:text>&#10;</xsl:text>
        <xsl:text>{{Persondata</xsl:text>
        <xsl:text>     &lt;!-- Metadata: see [[Wikipedia:Persondata]]. --&gt;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| NAME</xsl:text>
        <xsl:text>&#09;&#09;&#09;&#09;= </xsl:text>
        <xsl:choose>
            <xsl:when test="$pPersNameFore or $pPersNameSur">
                <xsl:value-of select="normalize-space($pPersNameSur)" />
                <xsl:text>, </xsl:text>
                <xsl:value-of select="normalize-space($pPersNameFore)" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <!-- If the name contains no dates ... -->
                    <xsl:when test="string-length(translate($pPersName,concat($vAlpha,$vCommaSpace),''))=0">
                        <!-- ... then output as is. -->
                        <xsl:value-of select="$pPersName" />
                    </xsl:when>
                    <!-- If the name does contain dates ... -->
                    <xsl:when test="string-length(translate($pPersName,concat($vAlpha,$vCommaSpace),''))&gt;0">
                        <!-- ... output the part of the name before the dates. -->
                        <xsl:value-of select="substring-before($pPersName,', ')" />
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="substring-before(substring-after($pPersName,', '),', ')" />
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| ALTERNATIVE NAMES</xsl:text>
        <xsl:text>&#09;= </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| SHORT DESCRIPTION</xsl:text>
        <xsl:text>&#09;= </xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| DATE OF BIRTH</xsl:text>
        <xsl:text>&#09;&#09;= </xsl:text>
        <!-- Call template to attempt to prepopulate birth date info. -->
        <xsl:call-template name="tNameDateParser">
            <xsl:with-param name="pBirthYr" select="'true'" />
            <xsl:with-param name="pCheckInfo" select="'true'" />
        </xsl:call-template>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| PLACE OF BIRTH</xsl:text>
        <xsl:text>&#09;&#09;= </xsl:text>
        <!-- Call template to attempt to prepopulate birth place info. -->
        <!-- Under revision ...
        <xsl:call-template name="tBirthPlaceFinder">
            <xsl:with-param name="pBiogHist" select="$pBiogHist"/>
        </xsl:call-template>
        -->
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| DATE OF DEATH</xsl:text>
        <xsl:text>&#09;&#09;= </xsl:text>
        <!-- Call template to attempt to prepopulate death date info. -->
        <xsl:call-template name="tNameDateParser">
            <xsl:with-param name="pDeathYr" select="'true'" />
            <xsl:with-param name="pCheckInfo" select="'true'" />
        </xsl:call-template>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>| PLACE OF DEATH</xsl:text>
        <xsl:text>&#09;&#09;= </xsl:text>
        <!-- Call template to attempt to prepopulate death place info. -->
        <!-- Under revision ...
        <xsl:call-template name="tDeathPlaceFinder">
            <xsl:with-param name="pBiogHist" select="$pBiogHist"/>
        </xsl:call-template>
        -->
        <xsl:text>&#10;</xsl:text>
        <xsl:text>}}</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>     
        <xsl:call-template name="tDefaultSort">
            <xsl:with-param name="pPersName" select="$pPersName" />
            <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
            <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />            
        </xsl:call-template>
    </xsl:template>
    
</xsl:stylesheet>