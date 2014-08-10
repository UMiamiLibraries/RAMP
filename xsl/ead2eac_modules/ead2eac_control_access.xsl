<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eac="urn:isbn:1-931666-33-4"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings" xmlns:xlink="http://www.w3.org/1999/xlink"
    extension-element-prefixes="exsl str" exclude-result-prefixes="eac ead" version="1.0"> 

    <xsl:include href="ead2eac_attributes.xsl"/>

    <!-- Define a key for Muenchian grouping of subject elements. -->
    <xsl:key name="kSubjCheck" match="//ead:controlaccess" use="child::node()[local-name() != 'head']"/>
    
    <!-- Define variable for occupations. -->
    <xsl:variable name="vOccupation"
        select="//ead:ead/ead:archdesc//ead:controlaccess/ead:occupation"/>
    <xsl:variable name="vOccuCount" select="count(//ead:occupation)"/>
    
    <!-- Template for processing subjects. -->
    <xsl:template match="ead:ead/ead:archdesc//ead:controlaccess" name="tControlAccess">
        <!-- Store the results of Muenchian grouping inside a variable. -->
        <xsl:variable name="vSubjCheck">
            <xsl:for-each select="ead:ead/ead:archdesc//ead:controlaccess[count(. | key('kSubjCheck', child::node()[local-name()  !=  'head'])[1]) = 1]">
                <xsl:for-each select="child::node()[local-name()  !=  'head']">
                    <ead:name encodinganalog="{@encodinganalog}" type="{local-name()}">
                        <xsl:value-of select="." />
                    </ead:name>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <!-- Then do a second pass over the node set using the EXSL node-set function. -->
        <xsl:for-each select="exsl:node-set($vSubjCheck)/ead:name[not(. = preceding-sibling::ead:name)]">
            <xsl:choose>
                <xsl:when test="@encodinganalog='700'">
                    <localDescription xmlns="urn:isbn:1-931666-33-4" localType="700">
                        <term>
                            <xsl:value-of select="." />
                        </term>
                    </localDescription>
                </xsl:when>
                <xsl:when test="contains(@encodinganalog,'600')">
                    <localDescription xmlns="urn:isbn:1-931666-33-4" localType="600">
                        <term>
                            <xsl:value-of select="." />
                        </term>
                    </localDescription>
                </xsl:when>
                <xsl:when test="contains(@encodinganalog,'610')">
                    <localDescription xmlns="urn:isbn:1-931666-33-4" localType="610">
                        <term>
                            <xsl:value-of select="." />
                        </term>
                    </localDescription>
                </xsl:when>
                <xsl:when test="@encodinganalog='650'">
                    <localDescription xmlns="urn:isbn:1-931666-33-4" localType="650">
                        <term>
                            <xsl:value-of select="." />
                        </term>
                    </localDescription>
                </xsl:when>
                <xsl:when test="@encodinganalog='651'">
                    <localDescription xmlns="urn:isbn:1-931666-33-4" localType="651">
                        <term>
                            <xsl:value-of select="." />
                        </term>
                    </localDescription>
                </xsl:when>
                <xsl:when test="@type='subject'">
                    <localDescription xmlns="urn:isbn:1-931666-33-4" localType="subject">
                        <term>
                            <xsl:value-of select="." />
                        </term>
                    </localDescription>
                </xsl:when>
                <xsl:when test="@type='persname' and . != $vNameString">
                    <localDescription xmlns="urn:isbn:1-931666-33-4" localType="subject">
                        <term>
                            <xsl:value-of select="." />
                        </term>
                    </localDescription>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
                
        <xsl:call-template name="tSubjects" />
        <xsl:call-template name="tGenres" />
        <xsl:call-template name="tOccupationsNew" />
        
        <xsl:if test="//ead:occupation">
            <xsl:for-each select="$vOccupation">
                <occupation xmlns="urn:isbn:1-931666-33-4" localType="656">
                    <term>
                        <xsl:value-of select="normalize-space(.)" />
                    </term>
                </occupation>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="$vDates != ''">
            <xsl:call-template name="tOccupations" />
        </xsl:if>
        
        <xsl:call-template name="tPlaces" />
        
        <!-- Group existing geogname elements. -->
        <xsl:for-each select="exsl:node-set($vGeog)/ead:name[not(contains(.,'--'))][count(. | key('kGeogCheck', .)[1]) = 1][not(.=preceding-sibling::ead:name)]">                                   
            <place xmlns="urn:isbn:1-931666-33-4">                          
                <placeEntry>
                    <xsl:value-of select="normalize-space(.)"/>
                </placeEntry>                
            </place>
        </xsl:for-each>
    </xsl:template>
    
    <!-- Template for matching any epithets in name strings and adding to ead:occupation elements. -->
    <xsl:template name="tOccupations">
        <xsl:choose>
            <xsl:when test="substring-after($vNameString,$vDates) != ''">
                <xsl:choose>
                    <xsl:when test="contains(substring-after($vNameString,$vDates),',')">
                        <occupation xmlns="urn:isbn:1-931666-33-4">
                            <term>
                                <xsl:value-of select="normalize-space(translate(substring(substring-before(substring-after(substring-after($vNameString,$vDates),','),','),2,1),$vLower,$vUpper))" />
                                <xsl:value-of select="normalize-space(substring(substring-before(substring-after(substring-after($vNameString,$vDates),','),','),3))" />
                            </term>
                        </occupation>
                        <occupation xmlns="urn:isbn:1-931666-33-4">
                            <term>
                                <xsl:value-of select="normalize-space(translate(substring(substring-after(substring-after(substring-after($vNameString,$vDates),','),','),2,1),$vLower,$vUpper))" />
                                <xsl:value-of select="normalize-space(substring(substring-after(substring-after(substring-after($vNameString,$vDates),','),','),3))" />
                            </term>
                        </occupation>
                    </xsl:when>
                    <xsl:otherwise>
                        <occupation xmlns="urn:isbn:1-931666-33-4">
                            <term>
                                <xsl:value-of select="substring-after(substring-after($vNameString,$vDates),',')" />
                            </term>
                        </occupation>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="tSubjects">
        <xsl:if test="$vSubject != ''">
            <xsl:for-each select="$vSubject[. != '']">
                <localDescription xmlns="urn:isbn:1-931666-33-4" localType="subject">
                    <term>
                        <xsl:value-of select="normalize-space(.)" />
                    </term>
                </localDescription>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="tGenres">
        <xsl:if test="$vGenre != ''">
            <xsl:for-each select="$vGenre[. != '']">
                <localDescription xmlns="urn:isbn:1-931666-33-4" localType="genre">
                    <term>
                        <xsl:value-of select="normalize-space(.)" />
                    </term>
                </localDescription>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="tPlaces">
        <xsl:if test="$vPlaceRole != ''">
            <xsl:for-each select="$vPlaceRole[. != '']">
                <xsl:variable name="vPlaceRoleLabel" select="../@label" />
                <place xmlns="urn:isbn:1-931666-33-4">
                    <placeRole>
                        <xsl:value-of select="normalize-space(.)" />
                    </placeRole>
                    <xsl:if test="../following-sibling::ead:note[@type='placeEntry']/ead:p != ''">
                        <placeEntry>
                            <xsl:if test="../following-sibling::ead:note[@type='placeEntry'][@label=$vPlaceRoleLabel]">
                                <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='placeEntry'][@label=$vPlaceRoleLabel]/ead:p)" />
                            </xsl:if>
                        </placeEntry>
                        <xsl:choose>
                            <xsl:when test="../following-sibling::ead:note[@type='placeDateFrom']/ead:p != ''">
                                <dateRange>
                                    <xsl:if test="../following-sibling::ead:note[@type='placeDateFrom'][@label=$vPlaceRoleLabel]">
                                        <xsl:choose>
                                            <xsl:when test="../following-sibling::ead:note[@type='placeStandardFrom'][@label=$vPlaceRoleLabel]/ead:p != ''">
                                                <fromDate standardDate="{normalize-space(../following-sibling::ead:note[@type='placeStandardFrom'][@label=$vPlaceRoleLabel]/ead:p)}">
                                                    <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='placeDateFrom'][@label=$vPlaceRoleLabel]/ead:p)" />
                                                </fromDate>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <fromDate>
                                                    <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='placeDateFrom'][@label=$vPlaceRoleLabel]/ead:p)" />
                                                </fromDate>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                    <xsl:if test="../following-sibling::ead:note[@type='placeDateTo'][@label=$vPlaceRoleLabel]/ead:p != ''">
                                        <xsl:choose>
                                            <xsl:when test="../following-sibling::ead:note[@type='placeStandardTo'][@label=$vPlaceRoleLabel]/ead:p != ''">
                                                <toDate standardDate="{normalize-space(../following-sibling::ead:note[@type='placeStandardTo'][@label=$vPlaceRoleLabel]/ead:p)}">
                                                    <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='placeDateTo'][@label=$vPlaceRoleLabel]/ead:p)" />
                                                </toDate>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <toDate>
                                                    <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='placeDateTo'][@label=$vPlaceRoleLabel]/ead:p)" />
                                                </toDate>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                </dateRange>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="../following-sibling::ead:note[@type='placeDateTo'][@label=$vPlaceRoleLabel]/ead:p != ''">
                                    <dateRange>
                                        <xsl:choose>
                                            <xsl:when test="../following-sibling::ead:note[@type='placeStandardTo'][@label=$vPlaceRoleLabel]/ead:p != ''">
                                                <toDate standardDate="{normalize-space(../following-sibling::ead:note[@type='placeStandardTo'][@label=$vPlaceRoleLabel]/ead:p)}">
                                                    <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='placeDateTo'][@label=$vPlaceRoleLabel]/ead:p)" />
                                                </toDate>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <toDate>
                                                    <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='placeDateTo'][@label=$vPlaceRoleLabel]/ead:p)" />
                                                </toDate>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </dateRange>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </place>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
