<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eac="urn:isbn:1-931666-33-4"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings" xmlns:xlink="http://www.w3.org/1999/xlink"
    extension-element-prefixes="exsl str" exclude-result-prefixes="eac ead" version="1.0"> 

    <!-- Define a key for Muenchian grouping of persname elements. -->
    <xsl:key name="kNameCheck" match="//ead:scopecontent//ead:persname|//ead:bioghist//ead:persname|//ead:scopecontent//ead:corpname|//ead:scopecontent//ead:corpname" use="." />
    
    <!-- Define a key for Muenchian grouping of geogname elements. -->
    <xsl:key name="kGeogCheck" match="//ead:geogname" use="." />
    
    <!-- Variable for grouping geogname elements. -->
    <xsl:variable name="vGeog">   
        <xsl:for-each select="//ead:geogname">       
            <xsl:sort select="translate(.,'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
            <ead:name>
                <xsl:choose>
                    <xsl:when test="substring(.,string-length(.))=',' or substring(.,string-length(.))='.' or substring(.,string-length(.))=';' or substring(.,string-length(.))=':'">
                        <xsl:value-of select="normalize-space(substring(.,1,string-length(.) -1))" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(.)" />
                    </xsl:otherwise>
                </xsl:choose>
            </ead:name>
        </xsl:for-each>
    </xsl:variable>
    <!-- Variable for grouping persname elements. -->
    <xsl:variable name="vCpfName">
        <xsl:for-each select="//ead:persname[not(contains(parent::ead:origination/@id,'RAMP'))]">   
            <xsl:sort select="translate(.,'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
            <persName>
                <xsl:choose>
                    <xsl:when test="substring(normalize-space(.),string-length(.))=','">
                        <xsl:value-of select="normalize-space(substring(.,1,string-length(.)-1))" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(.)" />
                    </xsl:otherwise>
                </xsl:choose>
            </persName>
        </xsl:for-each>
        <xsl:for-each select="//ead:corpname[not(contains(parent::ead:origination/@id,'RAMP'))]">
            <xsl:sort select="translate(.,'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
            <corpName>
                <xsl:choose>
                    <xsl:when test="substring(.,string-length(.))=',' or substring(.,string-length(.))='.' or substring(.,string-length(.))=';' or substring(.,string-length(.))=':'">
                        <xsl:value-of select="normalize-space(substring(.,1,string-length(.) -1))" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(.)" />
                    </xsl:otherwise>
                </xsl:choose>
            </corpName>
        </xsl:for-each>                
    </xsl:variable>    

</xsl:stylesheet>
