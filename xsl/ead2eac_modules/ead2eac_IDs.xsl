<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eac="urn:isbn:1-931666-33-4"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings" xmlns:xlink="http://www.w3.org/1999/xlink"
    extension-element-prefixes="exsl str" exclude-result-prefixes="eac ead" version="1.0">

    <xsl:import href="ead2eac_control.xsl"/>    

    <!-- Override generic template from control.xsl. -->
    <xsl:template name="tRecId">        
        <recordId xmlns="urn:isbn:1-931666-33-4">    
            <xsl:choose>                
                <!-- If it's an ingested Archon record (not created from within RAMP). -->                
                <xsl:when test="$pRecordId != ''">
                    <xsl:value-of select="concat('RAMP-',substring-before($pRecordId,'.'))" />   
                </xsl:when>                                                                            
                <xsl:otherwise>
                    <xsl:value-of select="ead:ead/ead:eadheader/ead:eadid/@identifier[contains(.,'RAMP')]"/>        
                </xsl:otherwise>                
            </xsl:choose>                                                                                      
        </recordId>        
    </xsl:template>
    
    <xsl:template name="tOtherRecId">                                             
        <xsl:variable name="vEadHeaderCount" select="count(ead:ead/ead:eadheader)" />
        <!-- If it's an ingested Archon record (not created from within RAMP). -->  
        <xsl:for-each select="ead:ead/ead:eadheader[ead:eadid[contains(@identifier,'Archon')]]">
            <otherRecordId xmlns="urn:isbn:1-931666-33-4"> 
                <xsl:if test="$pShortAgencyName != ''">                    
                    <xsl:attribute name="localType">
                        <xsl:choose>
                            <!-- Check for merged records. -->
                            <xsl:when test="$vEadHeaderCount &gt; 1">
                                <xsl:value-of select="concat($pShortAgencyName,'_merged')" />        
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$pShortAgencyName" />
                            </xsl:otherwise>
                        </xsl:choose>                                   
                    </xsl:attribute>     
                </xsl:if>     
                <xsl:value-of select="substring-after(ead:eadid[contains(.,'/')],'/')"/>
                <xsl:value-of select="ead:eadid[not(contains(.,'/'))]"/>
                <xsl:text>.</xsl:text>
                <xsl:value-of select="substring-after(ead:eadid/@identifier,':')" />
                <xsl:text>.</xsl:text>                                                                                                                                               
                <xsl:value-of select="substring-before($pRecordId,'-')" />
            </otherRecordId>
        </xsl:for-each>                 
        <xsl:choose>            
            <!-- If it's an ingested Archon record (not created from within RAMP). -->            
            <xsl:when test="ead:ead/ead:eadheader[ead:eadid[not(contains(@identifier,'Archon'))]]">                
                <!-- maintenanceStatus = "new" -->                
                <maintenanceStatus xmlns="urn:isbn:1-931666-33-4">new</maintenanceStatus>                
            </xsl:when>            
            <xsl:otherwise>                
                <!-- maintenanceStatus = "derived" -->                
                <maintenanceStatus xmlns="urn:isbn:1-931666-33-4">derived</maintenanceStatus>                
            </xsl:otherwise>            
        </xsl:choose>             
    </xsl:template>
   
</xsl:stylesheet>
