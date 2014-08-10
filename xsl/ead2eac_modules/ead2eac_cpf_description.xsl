<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eac="urn:isbn:1-931666-33-4"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings" xmlns:xlink="http://www.w3.org/1999/xlink"
    extension-element-prefixes="exsl str" exclude-result-prefixes="eac ead" version="1.0"> 

    <xsl:include href="ead2eac_identity.xsl"/>
    <xsl:include href="ead2eac_description.xsl"/>
    <xsl:include href="ead2eac_relations.xsl"/>

    <!-- Process top-level cpfDescription element. -->
    <xsl:template name="tCpfDescription">
        <cpfDescription xmlns="urn:isbn:1-931666-33-4">
            <xsl:call-template name="tIdentity" />
            <xsl:call-template name="tDescription" />
            <xsl:call-template name="tRelations" />
        </cpfDescription>
    </xsl:template>

</xsl:stylesheet>
