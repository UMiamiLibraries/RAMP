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
    
    <!-- Default sort template. -->
    <xsl:template name="tDefaultSort">
        <xsl:param name="pPersName" select="$pPersName" />
        <xsl:param name="pPersNameSur" select="$pPersNameSur" />
        <xsl:param name="pPersNameFore" select="$pPersNameFore" />
        <xsl:param name="pCorpName" select="$pCorpName" />
        <xsl:choose>
            <!-- If the name contains no dates ... -->
            <xsl:when test="string-length(translate($pPersName,concat($vAlpha,$vCommaSpace),''))&lt;=2">
                <!-- ... then output as is. -->
                <xsl:text>{{DEFAULTSORT:</xsl:text>
                <xsl:choose>                    
                    <xsl:when test="$pCorpName != ''">
                        <xsl:value-of select="$pCorpName"/>
                    </xsl:when>                    
                    <xsl:when test="$pPersName">
                        <xsl:value-of select="$pPersName" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$pPersNameSur != '' and $pPersNameFore != ''">
                                <xsl:value-of select="normalize-space($pPersNameSur)" />
                                <xsl:text>, </xsl:text>
                                <xsl:value-of select="normalize-space($pPersNameFore)" />        
                            </xsl:when>
                            <xsl:when test="$pPersNameSur='' and $pPersNameFore != ''">                                
                                <xsl:value-of select="normalize-space($pPersNameFore)" />        
                            </xsl:when>
                            <xsl:when test="$pPersNameSur != '' and $pPersNameFore=''">
                                <xsl:value-of select="normalize-space($pPersNameSur)" />                                       
                            </xsl:when>                            
                        </xsl:choose>                        
                    </xsl:otherwise>
                </xsl:choose>                
                <xsl:text>}}</xsl:text>
                <xsl:text>&#10;</xsl:text>
            </xsl:when>
            <!-- If the name does contain dates ... -->
            <xsl:when test="string-length(translate($pPersName,concat($vAlpha,$vCommaSpace),''))&gt;2">
                <!-- ... output the part of the name before the dates. -->
                <xsl:text>{{DEFAULTSORT:</xsl:text>                
                <xsl:choose>                    
                    <xsl:when test="$pCorpName != ''">
                        <xsl:value-of select="$pCorpName"/>
                    </xsl:when>                    
                    <xsl:when test="$pPersName">
                        <xsl:value-of select="substring-before($pPersName,', ')" />
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="substring-before(substring-after($pPersName,', '),', ')" />
                    </xsl:when>                    
                </xsl:choose>                                                  
                <xsl:text>}}</xsl:text>
                <xsl:text>&#10;</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>