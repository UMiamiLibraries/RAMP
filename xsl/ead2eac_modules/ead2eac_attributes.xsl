<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eac="urn:isbn:1-931666-33-4"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings" xmlns:xlink="http://www.w3.org/1999/xlink"
    extension-element-prefixes="exsl str" exclude-result-prefixes="eac ead" version="1.0"> 

    <!-- Define a variable to help de-dupe language elements. -->
    <xsl:variable name="vLangCheck"
        select="//ead:ead[1]/ead:archdesc/ead:did/ead:langmaterial/ead:language"/>
    
    <xsl:template name="tGenders">
        <xsl:if test="$vGender != ''">
            <xsl:for-each select="$vGender[. != '']">
                <xsl:variable name="vGenderLabel" select="../@label" />
                <localDescription xmlns="urn:isbn:1-931666-33-4" localType="gender">
                    <term>
                        <xsl:value-of select="normalize-space(.)" />
                    </term>
                    <xsl:if test="../following-sibling::ead:note[@type='genderDateFrom']/ead:p != ''">
                        <dateRange>
                            <xsl:if test="../following-sibling::ead:note[@type='genderDateFrom'][@label=$vGenderLabel]">
                                <fromDate>
                                    <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='genderDateFrom'][@label=$vGenderLabel]/ead:p)" />
                                </fromDate>
                            </xsl:if>
                            <xsl:if test="../following-sibling::ead:note[@type='genderDateTo'][@label=$vGenderLabel]">
                                <toDate>
                                    <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='genderDateTo'][@label=$vGenderLabel]/ead:p)" />
                                </toDate>
                            </xsl:if>
                        </dateRange>
                    </xsl:if>
                </localDescription>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="tLangs">
        <xsl:if test="$vLangName != ''">
            <xsl:for-each select="$vLangName[. != '']">
                <xsl:variable name="vLangNameLabel" select="../@label" />
                <languageUsed xmlns="urn:isbn:1-931666-33-4">
                    <xsl:choose>
                        <xsl:when test="../following-sibling::ead:note[@type='langCode']/ead:p=''">
                            <language>
                                <xsl:value-of select="normalize-space(.)" />
                            </language>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="../following-sibling::ead:note[@type='langCode'][@label=$vLangNameLabel]">
                                <language languageCode="{normalize-space(../following-sibling::ead:note[@type='langCode'][@label=$vLangNameLabel]/ead:p)}">
                                    <xsl:value-of select="normalize-space(.)" />
                                </language>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:call-template name="tScript">
                        <xsl:with-param name="vLangNameLabel" select="$vLangNameLabel" />
                    </xsl:call-template>
                </languageUsed>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="tOccupationsNew">
        <xsl:if test="$vOccupationNew != ''">
            <xsl:for-each select="$vOccupationNew[. != '']">
                <xsl:variable name="vOccuLabel" select="../@label" />
                <occupation xmlns="urn:isbn:1-931666-33-4">
                    <term>
                        <xsl:value-of select="normalize-space(.)" />
                    </term>
                    <xsl:choose>
                        <xsl:when test="../following-sibling::ead:note[@type='occuDateFrom']/ead:p != ''">
                            <dateRange>
                                <xsl:if test="../following-sibling::ead:note[@type='occuDateFrom'][@label=$vOccuLabel]">
                                    <xsl:choose>
                                        <xsl:when test="../following-sibling::ead:note[@type='occuStandardFrom'][@label=$vOccuLabel]/ead:p != ''">
                                            <fromDate standardDate="{normalize-space(../following-sibling::ead:note[@type='occuStandardFrom'][@label=$vOccuLabel]/ead:p)}">
                                                <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='occuDateFrom'][@label=$vOccuLabel]/ead:p)" />
                                            </fromDate>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <fromDate>
                                                <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='occuDateFrom'][@label=$vOccuLabel]/ead:p)" />
                                            </fromDate>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                                <xsl:if test="../following-sibling::ead:note[@type='occuDateTo'][@label=$vOccuLabel] != ''">
                                    <xsl:choose>
                                        <xsl:when test="../following-sibling::ead:note[@type='occuStandardTo'][@label=$vOccuLabel]/ead:p != ''">
                                            <toDate standardDate="{normalize-space(../following-sibling::ead:note[@type='occuStandardTo'][@label=$vOccuLabel]/ead:p)}">
                                                <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='occuDateTo'][@label=$vOccuLabel]/ead:p)" />
                                            </toDate>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <toDate>
                                                <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='occuDateTo'][@label=$vOccuLabel]/ead:p)" />
                                            </toDate>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                            </dateRange>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="../following-sibling::ead:note[@type='occuDateTo'][@label=$vOccuLabel] != ''">
                                <dateRange>
                                    <xsl:choose>
                                        <xsl:when test="../following-sibling::ead:note[@type='occuStandardTo'][@label=$vOccuLabel]/ead:p != ''">
                                            <toDate standardDate="{normalize-space(../following-sibling::ead:note[@type='occuStandardTo'][@label=$vOccuLabel]/ead:p)}">
                                                <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='occuDateTo'][@label=$vOccuLabel]/ead:p)" />
                                            </toDate>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <toDate>
                                                <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='occuDateTo'][@label=$vOccuLabel]/ead:p)" />
                                            </toDate>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </dateRange>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </occupation>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="tScript">
        <xsl:param name="vLangNameLabel" />
        <xsl:if test="$vScriptName != ''">
            <xsl:variable name="vScriptNameLabel" select="../@label" />
            <xsl:choose>
                <xsl:when test="../following-sibling::ead:note[@type='scriptCode']/ead:p=''">
                    <script xmlns="urn:isbn:1-931666-33-4">
                        <xsl:value-of select="normalize-space($vScriptName)" />
                    </script>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="../following-sibling::ead:note[@type='scriptCode'][@label=$vLangNameLabel]">
                        <script xmlns="urn:isbn:1-931666-33-4" scriptCode="{normalize-space(../following-sibling::ead:note[@type='scriptCode'][@label=$vLangNameLabel]/ead:p)}">
                            <xsl:value-of select="normalize-space($vScriptName)" />
                        </script>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
