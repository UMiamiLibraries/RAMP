<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eac="urn:isbn:1-931666-33-4"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings" xmlns:xlink="http://www.w3.org/1999/xlink"
    extension-element-prefixes="exsl str" exclude-result-prefixes="eac ead" version="1.0"> 

    <xsl:template name="tCitations">
        <xsl:if test="$vCitation!=''">
            <xsl:for-each select="$vCitation[. != '']">
                <citation xmlns="urn:isbn:1-931666-33-4">
                    <xsl:value-of select="normalize-space(.)" />
                </citation>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
