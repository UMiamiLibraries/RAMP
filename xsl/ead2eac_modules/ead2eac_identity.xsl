<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eac="urn:isbn:1-931666-33-4"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings" xmlns:xlink="http://www.w3.org/1999/xlink"
    extension-element-prefixes="exsl str" exclude-result-prefixes="eac ead" version="1.0"> 

    <!-- Process identity element. -->
    <xsl:template name="tIdentity">
        <!-- Check for entity type. -->
        <identity xmlns="urn:isbn:1-931666-33-4">
            <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:origination[1]/child::node()[1][local-name()='persname']
                | ead:ead/ead:archdesc/ead:controlaccess/ead:persname[1][contains(@role,'Collector')]">
                <entityType>person</entityType>
            </xsl:if>
            <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:origination[1]/child::node()[1][local-name()='corpname']
                | ead:ead/ead:archdesc/ead:controlaccess/ead:corpname[1][contains(@role,'Collector')]">
                <entityType>corporateBody</entityType>
            </xsl:if>
            <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:origination[1]/child::node()[1][local-name()='famname']
                | ead:ead/ead:archdesc/ead:controlaccess/ead:famname[1][contains(@role,'Collector')]">
                <entityType>family</entityType>
            </xsl:if>
            <nameEntry scriptCode="Latn" xml:lang="en">                
                <!-- For Archon-exported EADs, use the value of the @normal attribute. -->
                <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1]/@normal">
                    <part>
                        <xsl:value-of select="ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1]/@normal" />
                    </part>
                </xsl:if>                
                <!-- Otherwise, output the string as is. -->
                <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1][not(@normal)][.  !=  '']">
                    <part>
                        <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1])" />
                    </part>    
                </xsl:if>                                
                <!-- For AT-exported EADs, use the name element for @role = 'Collector'... -->
                <xsl:if test="ead:ead/ead:archdesc/ead:controlaccess/child::node()[1][contains(@role,'Collector')]">
                    <part>
                        <xsl:value-of select="ead:ead/ead:archdesc/ead:controlaccess/child::node()[1][contains(@role,'Collector')]" />
                    </part>
                </xsl:if>                    
                <!-- Otherwise, try to do some pattern matching and string manipulation to parse names and dates. -->                        
                <!-- If there are more than 4 digits in the string, presume a date... -->
                <xsl:if 
                    test="string-length(translate(normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1]),
                    concat($vAlpha,$vCommaSpace),'')) &gt;= 4
                    or string-length(translate(normalize-space(ead:ead/ead:archdesc/ead:controlaccess/child::node()[1][contains(@role,'Collector')]),
                    concat($vAlpha,$vCommaSpace),'')) &gt;= 4 ">
                    <part>
                        <xsl:choose>
                            <!-- If 8 digits, presume birth and death dates... -->
                            <xsl:when test="$vDatesLen = 8">
                                <xsl:choose>
                                    <xsl:when test="$vNameString-1 = ')'">
                                        <xsl:value-of select="substring-before($vNameString-10,',')" />
                                        <xsl:text>, </xsl:text>
                                        <xsl:choose>
                                            <xsl:when test="contains(substring-after($vNameString-12,', '),',')">
                                                <xsl:value-of select="substring-before(substring-after($vNameString-12,', '),',')" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="substring-after($vNameString-12,', ')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="substring-before($vNameString-10,',')" />
                                        <xsl:text>, </xsl:text>
                                        <xsl:choose>
                                            <xsl:when test="contains(substring-after($vNameString-10,', '),',')">
                                                <xsl:value-of select="substring-before(substring-after($vNameString-10,', '),',')" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="substring-after($vNameString-10,', ')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="$vDatesLen = 4 or $vDatesLen = 5">
                                <xsl:choose>
                                    <xsl:when test="$vNameString-1=')'">
                                        <xsl:value-of select="substring-before($vNameString-6,',')" />
                                        <xsl:text>, </xsl:text>
                                        <xsl:choose>
                                            <xsl:when test="contains(substring-after($vNameString-8,', '),',')">
                                                <xsl:choose>
                                                    <xsl:when test="contains($vNameString,' b. ')">
                                                        <xsl:value-of select="substring-after(substring-before($vNameString,', b. '),', ')" />
                                                    </xsl:when>
                                                    <xsl:when test="contains($vNameString,' b ')">
                                                        <xsl:value-of select="substring-after(substring-before($vNameString,', b '),', ')" />
                                                    </xsl:when>
                                                    <xsl:when test="contains($vNameString,' d. ')">
                                                        <xsl:value-of select="substring-after(substring-before($vNameString,', d. '),', ')" />
                                                    </xsl:when>
                                                    <xsl:when test="contains($vNameString,' d ')">
                                                        <xsl:value-of select="substring-after(substring-before($vNameString,', d '),', ')" />
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="substring-before(substring-after($vNameString-8,', '),',')" />
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="substring-after($vNameString-8,', ')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="substring-before($vNameString-6,',')" />
                                        <xsl:text>, </xsl:text>
                                        <xsl:choose>
                                            <xsl:when test="contains(substring-after($vNameString-6,', '),',')">
                                                <xsl:choose>
                                                    <xsl:when test="contains($vNameString-6,' b. ')">
                                                        <xsl:value-of select="substring-after(substring-before($vNameString,', b. '),', ')" />
                                                    </xsl:when>
                                                    <xsl:when test="contains($vNameString-6,' b ')">
                                                        <xsl:value-of select="substring-after(substring-before($vNameString,', b '),', ')" />
                                                    </xsl:when>
                                                    <xsl:when test="contains($vNameString-6,' d. ')">
                                                        <xsl:value-of select="substring-after(substring-before($vNameString,', d. '),', ')" />
                                                    </xsl:when>
                                                    <xsl:when test="contains($vNameString-6,' d ')">
                                                        <xsl:value-of select="substring-after(substring-before($vNameString,', d '),', ')" />
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="substring-before(substring-after($vNameString-6,', '),',')" />
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="substring-after($vNameString-6,', ')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                        </xsl:choose>
                    </part>
                </xsl:if>
                <!-- Accommodate RAMP-created records... -->    
                <xsl:choose>
                    <xsl:when test="ead:ead/ead:archdesc/ead:did/ead:origination/ead:persname[@encodinganalog='100_1'] != ''">
                        <part localType="surname">
                            <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/ead:persname[@encodinganalog='100_1'])" />
                        </part>
                        <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:origination/ead:persname[@encodinganalog='100_0'] != ''">
                            <part localType="forename">
                                <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/ead:persname[@encodinganalog='100_0'])" />
                            </part>
                        </xsl:if>
                        <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:note[@type='nameAuth']/ead:p != ''">
                            <authorizedForm>
                                <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:note[@type='nameAuth']/ead:p)" />
                            </authorizedForm>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="ead:ead/ead:archdesc/ead:did/ead:origination/ead:persname[@encodinganalog='100_0'] != ''">
                        <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:origination/ead:persname[@encodinganalog='100_1'] != ''">
                            <part localType="surname">
                                <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/ead:persname[@encodinganalog='100_1'])" />
                            </part>
                        </xsl:if>
                        <part localType="forename">
                            <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/ead:persname[@encodinganalog='100_0'])" />
                        </part>
                        <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:note[@type='nameAuth']/ead:p != ''">
                            <authorizedForm>
                                <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:note[@type='nameAuth']/ead:p)" />
                            </authorizedForm>
                        </xsl:if>
                    </xsl:when>  
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="ead:ead/ead:archdesc/ead:did/ead:note[@type='nameAuth']/ead:p != ''">
                                <authorizedForm>
                                    <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:note[@type='nameAuth']/ead:p)" />
                                </authorizedForm>
                            </xsl:when>
                            <xsl:when test="ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1]/@source">
                                <authorizedForm>
                                    <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1]/@source)" />
                                </authorizedForm>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:otherwise>                    
                </xsl:choose>                                                                                                                                        
            </nameEntry>
        </identity>
    </xsl:template>

</xsl:stylesheet>
