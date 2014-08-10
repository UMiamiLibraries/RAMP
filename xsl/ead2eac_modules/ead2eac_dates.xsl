<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eac="urn:isbn:1-931666-33-4"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings" xmlns:xlink="http://www.w3.org/1999/xlink"
    extension-element-prefixes="exsl str" exclude-result-prefixes="eac ead" version="1.0"> 

    <!-- Define variables for basic pattern matching of dates. -->
    <xsl:variable name="vDates" select="translate(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1] 
        | ead:ead/ead:archdesc/ead:controlaccess/child::node()[1][contains(@role,'Collector')]),concat($vAlpha2,$vCommaSpace,$vApos),'')" />
    <xsl:variable name="vDatesLen" select="string-length(translate(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]
        | ead:ead/ead:archdesc/ead:controlaccess/child::node()[1][contains(@role,'Collector')]),concat($vAlpha,$vCommaSpace,$vApos),''))" />
    <xsl:variable name="vNameStringLen" select="string-length(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]
        | ead:ead/ead:archdesc/ead:controlaccess/child::node()[1][contains(@role,'Collector')]))" />
    <xsl:variable name="vNameString" select="substring(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]
        | ead:ead/ead:archdesc/ead:controlaccess/child::node()[1][contains(@role,'Collector')]),1,$vNameStringLen)" />
    <xsl:variable name="vNameString-1" select="substring(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]
        | ead:ead/ead:archdesc/ead:controlaccess/child::node()[1][contains(@role,'Collector')]),$vNameStringLen, $vNameStringLen)" />
    <xsl:variable name="vNameString-6" select="substring(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]
        | ead:ead/ead:archdesc/ead:controlaccess/child::node()[1][contains(@role,'Collector')]),1,$vNameStringLen - 6)" />
    <xsl:variable name="vNameString-8" select="substring(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]
        | ead:ead/ead:archdesc/ead:controlaccess/child::node()[1][contains(@role,'Collector')]),1,$vNameStringLen - 8)" />
    <xsl:variable name="vNameString-10" select="substring(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]
        | ead:ead/ead:archdesc/ead:controlaccess/child::node()[1][contains(@role,'Collector')]),1,$vNameStringLen - 10)" />
    <xsl:variable name="vNameString-12" select="substring(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]
        | ead:ead/ead:archdesc/ead:controlaccess/child::node()[1][contains(@role,'Collector')]),1,$vNameStringLen - 12)" />

    <!-- Template for parsing eac:existDates. -->
    <xsl:template name="tExistDates">
        <xsl:param name="pName" />
        <xsl:choose>
            <!-- If the first nameEntry contains a four-digit number (we assume a date)... -->
            <xsl:when test="string-length(translate($pName,concat($vAlpha,$vCommaSpace,$vApos),'')) &gt;= 4">
                <xsl:element name="existDates" namespace="urn:isbn:1-931666-33-4">
                    <xsl:element name="dateRange" namespace="urn:isbn:1-931666-33-4">
                        <!-- Output the birth year, if exists. -->
                        <xsl:choose>
                            <xsl:when test="substring-before($pName,'-') != ''">
                                <xsl:choose>
                                    <xsl:when test="contains(substring-after($pName,'-'),'-')">
                                        <xsl:element name="fromDate" namespace="urn:isbn:1-931666-33-4">
                                            <xsl:value-of select="translate(substring-before(substring-after($pName,'-'),'-'),concat($vAlpha,$vCommaSpace,$vApos),'')" />
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="fromDate" namespace="urn:isbn:1-931666-33-4">
                                            <xsl:value-of select="translate(substring-before($pName,'-'),concat($vAlpha,$vCommaSpace,$vApos),'')" />
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($pName,' b ')">
                                <xsl:element name="fromDate" namespace="urn:isbn:1-931666-33-4">
                                    <xsl:value-of select="substring-after($pName,' b ')" />
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($pName,' b. ')">
                                <xsl:element name="fromDate" namespace="urn:isbn:1-931666-33-4">
                                    <xsl:value-of select="substring-after($pName,' b. ')" />
                                </xsl:element>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                            <!-- Output the death year, if exists. -->
                            <xsl:when test="substring-after($pName,'-') != ''">
                                <xsl:choose>
                                    <xsl:when test="contains(substring-after($pName,'-'),'-')">
                                        <xsl:element name="toDate" namespace="urn:isbn:1-931666-33-4">
                                            <xsl:value-of select="translate(substring-after(substring-after($pName,'-'),'-'),concat($vAlpha,$vCommaSpace,$vApos),'')" />
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="toDate" namespace="urn:isbn:1-931666-33-4">
                                            <xsl:value-of select="translate(substring-after($pName,'-'),concat($vAlpha,$vCommaSpace,$vApos),'')" />
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($pName,' d ')">
                                <xsl:element name="toDate" namespace="urn:isbn:1-931666-33-4">
                                    <xsl:value-of select="substring-after($pName,' d ')" />
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($pName,' d. ')">
                                <xsl:element name="toDate" namespace="urn:isbn:1-931666-33-4">
                                    <xsl:value-of select="substring-after($pName,' d. ')" />
                                </xsl:element>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <!-- For RAMP-created records... -->
            <xsl:when test="ead:ead/ead:archdesc/ead:did/ead:note[@type='from']/ead:p != ''">
                <existDates xmlns="urn:isbn:1-931666-33-4">
                    <dateRange>
                        <xsl:choose>
                            <xsl:when test="ead:ead/ead:archdesc/ead:did/ead:note[@type='standardFrom']/ead:p != ''">
                                <fromDate standardDate="{normalize-space(ead:ead/ead:archdesc/ead:did/ead:note[@type='standardFrom']/ead:p)}">
                                    <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:note[@type='from']/ead:p)" />
                                </fromDate>
                            </xsl:when>
                            <xsl:otherwise>
                                <fromDate>
                                    <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:note[@type='from']/ead:p)" />
                                </fromDate>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:note[@type='to']/ead:p != ''">
                            <xsl:choose>
                                <xsl:when test="ead:ead/ead:archdesc/ead:did/ead:note[@type='standardTo']/ead:p != ''">
                                    <toDate standardDate="{normalize-space(ead:ead/ead:archdesc/ead:did/ead:note[@type='standardTo']/ead:p)}">
                                        <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:note[@type='to']/ead:p)" />
                                    </toDate>
                                </xsl:when>
                                <xsl:otherwise>
                                    <toDate>
                                        <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:note[@type='to']/ead:p)" />
                                    </toDate>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </dateRange>
                </existDates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:note[@type='to']/ead:p != ''">
                    <existDates xmlns="urn:isbn:1-931666-33-4">
                        <dateRange>
                            <xsl:choose>
                                <xsl:when test="ead:ead/ead:archdesc/ead:did/ead:note[@type='standardTo']/ead:p != ''">
                                    <toDate standardDate="{normalize-space(ead:ead/ead:archdesc/ead:did/ead:note[@type='standardTo']/ead:p)}">
                                        <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:note[@type='to']/ead:p)" />
                                    </toDate>
                                </xsl:when>
                                <xsl:otherwise>
                                    <toDate>
                                        <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:note[@type='to']/ead:p)" />
                                    </toDate>
                                </xsl:otherwise>
                            </xsl:choose>
                        </dateRange>
                    </existDates>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
