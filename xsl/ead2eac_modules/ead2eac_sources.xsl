<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eac="urn:isbn:1-931666-33-4"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings" xmlns:xlink="http://www.w3.org/1999/xlink"
    extension-element-prefixes="exsl str" exclude-result-prefixes="eac ead" version="1.0"> 

    <!-- Process source elements. -->    
    <xsl:template name="tSources">     
        <xsl:if test="ead:ead/ead:eadheader/ead:filedesc/descendant::text()">
            <sources xmlns="urn:isbn:1-931666-33-4">
                <!-- Include a reference to the source EAD. -->
                <xsl:for-each select="ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper[not(@type='filing')]">
                    <source>
                        <xsl:attribute name="xlink:href">
                            <xsl:choose>
                                <xsl:when test="contains(../../../ead:eadid/@identifier,'Archon')">
                                    <xsl:value-of select="concat($pLocalURL,substring-after(../../../ead:eadid/@identifier,':'))"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(../../../ead:eadid)"/>
                                </xsl:otherwise>                        	            
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="xlink:type">
                            <xsl:value-of select="'simple'"/>
                        </xsl:attribute>                    
                        <sourceEntry>
                            <xsl:value-of select="normalize-space(.)" />
                        </sourceEntry>                    
                        <!-- Output the source EAD snippet. -->
                        <objectXMLWrap>
                            <ead audience="external" xmlns="urn:isbn:1-931666-22-9" xmlns:xlink="http://www.w3.org/1999/xlink">
                                <eadheader>
                                    <xsl:copy-of select="../../../ead:eadid" />
                                    <filedesc>
                                        <xsl:copy-of select="parent::ead:titlestmt" />                                                
                                        <xsl:copy-of select="parent::ead:titlestmt/following-sibling::ead:publicationstmt"/>                                                                                                
                                    </filedesc>
                                    <xsl:copy-of select="../../../ead:profiledesc" />
                                    <xsl:copy-of select="../../../ead:revisiondesc" />
                                </eadheader>
                                <archdesc>
                                    <xsl:if test="../../../../ead:archdesc/@level">
                                        <xsl:attribute name="level">
                                            <xsl:value-of select="../../../../ead:archdesc/@level"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="../../../../ead:archdesc/@type">
                                        <xsl:attribute name="type">
                                            <xsl:value-of select="../../../../ead:archdesc/@type"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="../../../../ead:archdesc/@audience">
                                        <xsl:attribute name="audience">
                                            <xsl:value-of select="../../../../ead:archdesc/@audience"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="../../../../ead:archdesc/@relatedencoding">                                                
                                        <xsl:attribute name="relatedencoding">
                                            <xsl:value-of select="../../../../ead:archdesc/@relatedencoding"/>
                                        </xsl:attribute>
                                    </xsl:if>                                            
                                    <did>                                    
                                        <xsl:copy-of select="../../../../ead:archdesc/ead:did/ead:note"/>    
                                        <xsl:copy-of select="../../../../ead:archdesc/ead:did/ead:langmaterial"/>                                                                                                                                                                          
                                    </did>
                                    <xsl:copy-of select="../../../../ead:archdesc/ead:descgrp"/>   
                                </archdesc>
                            </ead>                                    
                        </objectXMLWrap>
                    </source>
                </xsl:for-each>            
            </sources>    
        </xsl:if>
        <!-- For RAMP-created records... -->
        <xsl:if test="$vSource != ''">
            <sources xmlns="urn:isbn:1-931666-33-4">                    
                <xsl:for-each select="$vSource[. != '']">
                    <source xmlns="urn:isbn:1-931666-33-4">
                        <sourceEntry>
                            <xsl:value-of select="normalize-space(.)" />
                        </sourceEntry>
                    </source>
                </xsl:for-each>                    
            </sources>
        </xsl:if>                       
    </xsl:template>              

</xsl:stylesheet>
