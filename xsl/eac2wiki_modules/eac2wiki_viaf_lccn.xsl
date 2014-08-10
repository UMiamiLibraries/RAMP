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
    
    <!-- Output VIAF ID and/or LCCN, if available. -->
    <xsl:template name="tVIAF">
        <xsl:choose>
            <xsl:when test="eac:eac-cpf/eac:control/eac:sources/eac:source/@xlink:href[contains(.,'viaf')]">
                <xsl:text>&#10;</xsl:text>                
                <xsl:for-each select="eac:eac-cpf/eac:control/eac:sources/eac:source/@xlink:href[contains(.,'viaf')]">
                    <xsl:text>{{Authority control|VIAF=</xsl:text>
                    <xsl:value-of select="substring-after(.,'viaf/')" />
                    <xsl:choose>
                        <xsl:when test="../../../eac:otherRecordId[@localType='WCI:LCCN']">
                            <xsl:text> |LCCN=</xsl:text>
                            <xsl:choose>
                                <xsl:when test="contains(../../../eac:otherRecordId[@localType='WCI:LCCN'],'no')">
                                    <xsl:variable name="lccn" select="substring-after(../../../eac:otherRecordId[@localType='WCI:LCCN'],'lccn-no')" />
                                    <xsl:choose>
                                        <xsl:when test="contains($lccn,'-')">
                                            <xsl:value-of select="concat('no/',translate($lccn,'-','/'))" />        
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="concat('no',$lccn)" />
                                        </xsl:otherwise>
                                    </xsl:choose>                                    
                                </xsl:when>
                                <xsl:when test="contains(../../../eac:otherRecordId[@localType='WCI:LCCN'],'nb')">
                                    <xsl:variable name="lccn" select="substring-after(../../../eac:otherRecordId[@localType='WCI:LCCN'],'lccn-nb')" />
                                    <xsl:choose>
                                        <xsl:when test="contains($lccn,'-')">
                                            <xsl:value-of select="concat('nb/',translate($lccn,'-','/'))" />        
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="concat('nb',$lccn)" />
                                        </xsl:otherwise>
                                    </xsl:choose>                                    
                                </xsl:when>
                                <xsl:when test="contains(../../../eac:otherRecordId[@localType='WCI:LCCN'],'ns')">
                                    <xsl:variable name="lccn" select="substring-after(../../../eac:otherRecordId[@localType='WCI:LCCN'],'lccn-ns')" />
                                    <xsl:choose>
                                        <xsl:when test="contains($lccn,'-')">
                                            <xsl:value-of select="concat('ns/',translate($lccn,'-','/'))" />        
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="concat('ns',$lccn)" />
                                        </xsl:otherwise>
                                    </xsl:choose>                                    
                                </xsl:when>
                                <xsl:when test="contains(../../../eac:otherRecordId[@localType='WCI:LCCN'],'nr')">
                                    <xsl:variable name="lccn" select="substring-after(../../../eac:otherRecordId[@localType='WCI:LCCN'],'lccn-nr')" />
                                    <xsl:choose>
                                        <xsl:when test="contains($lccn,'-')">
                                            <xsl:value-of select="concat('nr/',translate($lccn,'-','/'))" />        
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="concat('nr',$lccn)" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:when test="contains(../../../eac:otherRecordId[@localType='WCI:LCCN'],'sh')">
                                    <xsl:variable name="lccn" select="substring-after(../../../eac:otherRecordId[@localType='WCI:LCCN'],'lccn-sh')" />
                                    <xsl:choose>
                                        <xsl:when test="contains($lccn,'-')">
                                            <xsl:value-of select="concat('sh/',translate($lccn,'-','/'))" />        
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="concat('sh',$lccn)" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:variable name="lccn" select="substring-after(../../../eac:otherRecordId[@localType='WCI:LCCN'],'lccn-n')" />
                                    <xsl:choose>
                                        <xsl:when test="contains($lccn,'-')">
                                            <xsl:value-of select="concat('n/',translate($lccn,'-','/'))" />        
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="concat('n',$lccn)" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:text>}}</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="eac:eac-cpf/eac:control/eac:otherRecordId[@localType='WCI:LCCN']">                        
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>{{Authority control|LCCN=</xsl:text>
                        <xsl:choose>
                            <xsl:when test="contains(eac:eac-cpf/eac:control/eac:otherRecordId[@localType='WCI:LCCN'],'no')">
                                <xsl:variable name="lccn" select="substring-after(eac:eac-cpf/eac:control/eac:otherRecordId[@localType='WCI:LCCN'],'lccn-no')" />
                                <xsl:choose>
                                    <xsl:when test="contains($lccn,'-')">
                                        <xsl:value-of select="concat('no/',translate($lccn,'-','/'))" />        
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat('no',$lccn)" />
                                    </xsl:otherwise>
                                </xsl:choose>                                    
                            </xsl:when>
                            <xsl:when test="contains(../../../eac:otherRecordId[@localType='WCI:LCCN'],'nb')">
                                <xsl:variable name="lccn" select="substring-after(eac:eac-cpf/eac:control/eac:otherRecordId[@localType='WCI:LCCN'],'lccn-nb')" />
                                <xsl:choose>
                                    <xsl:when test="contains($lccn,'-')">
                                        <xsl:value-of select="concat('nb/',translate($lccn,'-','/'))" />        
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat('nb',$lccn)" />
                                    </xsl:otherwise>
                                </xsl:choose>                                    
                            </xsl:when>
                            <xsl:when test="contains(eac:eac-cpf/eac:control/eac:otherRecordId[@localType='WCI:LCCN'],'ns')">
                                <xsl:variable name="lccn" select="substring-after(eac:eac-cpf/eac:control/eac:otherRecordId[@localType='WCI:LCCN'],'lccn-ns')" />
                                <xsl:choose>
                                    <xsl:when test="contains($lccn,'-')">
                                        <xsl:value-of select="concat('ns/',translate($lccn,'-','/'))" />        
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat('ns',$lccn)" />
                                    </xsl:otherwise>
                                </xsl:choose>                                    
                            </xsl:when>
                            <xsl:when test="contains(eac:eac-cpf/eac:control/eac:otherRecordId[@localType='WCI:LCCN'],'nr')">
                                <xsl:variable name="lccn" select="substring-after(eac:eac-cpf/eac:control/eac:otherRecordId[@localType='WCI:LCCN'],'lccn-nr')" />
                                <xsl:choose>
                                    <xsl:when test="contains($lccn,'-')">
                                        <xsl:value-of select="concat('nr/',translate($lccn,'-','/'))" />        
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat('nr',$lccn)" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains(eac:eac-cpf/eac:control/eac:otherRecordId[@localType='WCI:LCCN'],'sh')">
                                <xsl:variable name="lccn" select="substring-after(eac:eac-cpf/eac:control/eac:otherRecordId[@localType='WCI:LCCN'],'lccn-sh')" />
                                <xsl:choose>
                                    <xsl:when test="contains($lccn,'-')">
                                        <xsl:value-of select="concat('sh/',translate($lccn,'-','/'))" />        
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat('sh',$lccn)" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="lccn" select="substring-after(eac:eac-cpf/eac:control/eac:otherRecordId[@localType='WCI:LCCN'],'lccn-n')" />
                                <xsl:choose>
                                    <xsl:when test="contains($lccn,'-')">
                                        <xsl:value-of select="concat('n/',translate($lccn,'-','/'))" />        
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat('n',$lccn)" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>                                                   
                        <xsl:text>}}</xsl:text>
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>&#10;</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>&#10;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>