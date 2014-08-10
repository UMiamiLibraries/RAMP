<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eac="urn:isbn:1-931666-33-4"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings" xmlns:xlink="http://www.w3.org/1999/xlink"
    extension-element-prefixes="exsl str" exclude-result-prefixes="eac ead" version="1.0"> 

    <xsl:import href="../common_modules/common_utils.xsl"/>
    <xsl:include href="ead2eac_dates.xsl"/>

    <xsl:template name="tCreatorSplitter">
        <xsl:param name="pCreators" />		
        <xsl:choose>
            <xsl:when test="contains($pCreators,';')">
                <relationEntry localType="creator" xmlns="urn:isbn:1-931666-33-4">
                    <xsl:value-of select="normalize-space(substring-before($pCreators,';'))" />
                </relationEntry>
                <xsl:call-template name="tCreatorSplitter">
                    <xsl:with-param name="pCreators" select="normalize-space(substring-after($pCreators,';'))"/>
                </xsl:call-template>			
            </xsl:when>			
            <xsl:otherwise>
                <relationEntry localType="creator" xmlns="urn:isbn:1-931666-33-4">
                    <xsl:value-of select="normalize-space($pCreators)" />
                </relationEntry>						
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
