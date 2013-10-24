<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:eac="urn:isbn:1-931666-33-4" xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:exsl="http://exslt.org/common" xmlns:str="http://exslt.org/strings"
    extension-element-prefixes="exsl str" exclude-result-prefixes="eac ead" version="1.0">

    <!--
        Author: Timothy A. Thompson
        University of Miami Libraries
        Copyright 2013 University of Miami. Licensed under the Educational Community License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://opensource.org/licenses/ECL-2.0 http://www.osedu.org/licenses/ECL-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
    -->

    <!--
        ead2eac.xsl creates EAC-CPF/XML from EAD/XML finding aids. 
    -->

    <!-- Parameters passed from PHP. -->
    <xsl:param name="pRecordId"/>
    <xsl:param name="pAgencyCode"/>
    <xsl:param name="pOtherAgencyCode"/>
    <xsl:param name="pDate"/>
    <xsl:param name="pAgencyName"/>
    <xsl:param name="pShortAgencyName"/>
    <xsl:param name="pArchonEac"/>
    <xsl:param name="pServerName"/>
    <xsl:param name="pLocalURL"/>
    <xsl:param name="pRepositoryOne"/>
    <xsl:param name="pRepositoryTwo"/>
    <xsl:param name="pEventDescCreate"/>
    <xsl:param name="pEventDescRevise"/>
    <xsl:param name="pEventDescExport"/>
    <xsl:param name="pEventDescDerive"/>
    <xsl:param name="pEventDescRAMP"/>

    <!-- Declare variables for basic pattern matching. -->
    <xsl:variable name="vUpper" select="'AÁÀÄBCDEÉÈFGHIÍJKLMNÑOÓPQRSTUÚÜVWXYZ'"/>

    <xsl:variable name="vLower" select="'aáàäbcdeéèfghiíjklmnñoópqrstuúüvwxyz'"/>

    <xsl:variable name="vAlpha" select="concat($vUpper,$vLower,$vPunct)"/>

    <xsl:variable name="vDigits" select="'0123456789'"/>

    <xsl:variable name="vPunct" select="'$;:.¿?!()[]-“”’'"/>

    <xsl:variable name="vPunct2" select="',.'"/>

    <xsl:variable name="vCommaSpace" select="', '"/>

    <xsl:variable name="vQuote">"</xsl:variable>

    <xsl:variable name="vApos">'</xsl:variable>

    <!-- Define a variable to help de-dupe language elements. -->
    <xsl:variable name="vLangCheck"
        select="//ead:ead[1]/ead:archdesc/ead:did/ead:langmaterial/ead:language"/>

    <!-- Define a key for Muenchian grouping of subject elements. -->
    <xsl:key name="kSubjCheck" match="ead:controlaccess/ead:controlaccess"
        use="child::node()[local-name()!='head']"/>

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- Call the top-level templates. -->
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="/eac:eac-cpf">
                <xsl:copy-of select="@*|node()"/>
            </xsl:when>
            <!-- Case to accommodate local merged EADs, which contain faux EAD wrapper elements. -->
            <xsl:when test="/ead:ead/ead:ead">
                <xsl:for-each select="ead:ead">
                    <eac-cpf
                        xmlns="urn:isbn:1-931666-33-4"
                        xmlns:xlink="http://www.w3.org/1999/xlink"
                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                        xsi:schemaLocation="urn:isbn:1-931666-33-4 http://eac.staatsbibliothek-berlin.de/schema/cpf.xsd">
                        <xsl:call-template name="control"/>
                        <xsl:call-template name="cpfDescription"/>
                    </eac-cpf>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <eac-cpf 
                    xmlns="urn:isbn:1-931666-33-4"
                    xmlns:xlink="http://www.w3.org/1999/xlink"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xsi:schemaLocation="urn:isbn:1-931666-33-4 http://eac.staatsbibliothek-berlin.de/schema/cpf.xsd">
                    <xsl:call-template name="control"/>
                    <xsl:call-template name="cpfDescription"/>
                </eac-cpf>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Process top-level control element. -->
    <xsl:template name="control">
        <control xmlns="urn:isbn:1-931666-33-4">
            <recordId>
                <xsl:choose>
                    <xsl:when test="contains(ead:ead/ead:eadheader/ead:eadid/@identifier,'RAMP')">
                        <xsl:value-of select="ead:ead/ead:eadheader/ead:eadid/@identifier"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('RAMP-',substring-before($pRecordId,'.'))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </recordId>
            <xsl:variable name="vEadHeaderCount" select="count(ead:ead/ead:eadheader)"/>
            <xsl:choose>
                <!-- If it's an ingested record (not created from within RAMP). -->
                <xsl:when test="not(contains(ead:ead/ead:eadheader/ead:eadid/@identifier,'RAMP'))">
                    <xsl:for-each select="ead:ead/ead:eadheader">
                        <otherRecordId>
                            <xsl:choose>
                                <xsl:when test="$vEadHeaderCount&gt;1">
                                    <xsl:attribute name="localType">
                                        <xsl:value-of select="concat('merged',$pShortAgencyName)"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="localType">
                                        <xsl:value-of select="$pShortAgencyName"/>
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="contains(ead:eadid,'/')">
                                    <xsl:value-of select="substring-after(ead:eadid,'/')"/>
                                    <xsl:text>.</xsl:text>
                                    <xsl:value-of
                                        select="substring-after(ead:eadid/@identifier,':')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="ead:eadid"/>
                                    <xsl:text>.</xsl:text>
                                    <xsl:value-of
                                        select="substring-after(ead:eadid/@identifier,':')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:text>.r</xsl:text>
                            <xsl:value-of select="substring-before($pRecordId,'-')"/>
                        </otherRecordId>
                    </xsl:for-each>
                    <!-- maintenanceStatus = "derived" -->
                    <maintenanceStatus>derived</maintenanceStatus>
                </xsl:when>
                <!-- If it's a RAMP-created record. -->
                <xsl:otherwise>
                    <!-- maintenanceStatus = "new" -->
                    <maintenanceStatus>new</maintenanceStatus>
                </xsl:otherwise>
            </xsl:choose>
            <publicationStatus>inProcess</publicationStatus>
            <maintenanceAgency>
                <agencyCode>
                    <xsl:value-of select="$pAgencyCode"/>
                </agencyCode>
                <otherAgencyCode localType="OCLC">
                    <xsl:value-of select="$pOtherAgencyCode"/>
                </otherAgencyCode>
                <agencyName>
                    <xsl:value-of select="$pAgencyName"/>
                </agencyName>
            </maintenanceAgency>
            <languageDeclaration>
                <language languageCode="eng">English</language>
                <script scriptCode="Latn">Latin</script>
            </languageDeclaration>
            <maintenanceHistory>
                <maintenanceEvent>
                    <xsl:choose>
                        <!-- If it's an ingested record (not created from within RAMP). -->
                        <xsl:when
                            test="not(contains(ead:ead/ead:eadheader/ead:eadid/@identifier,'RAMP'))">
                            <!-- eventType = "derived" -->
                            <eventType>derived</eventType>
                        </xsl:when>
                        <!-- If it's a RAMP-created record. -->
                        <xsl:otherwise>
                            <!-- eventType = "created" -->
                            <eventType>created</eventType>
                        </xsl:otherwise>
                    </xsl:choose>
                    <eventDateTime>
                        <xsl:attribute name="standardDateTime">
                            <xsl:value-of select="$pDate"/>
                        </xsl:attribute>
                    </eventDateTime>
                    <xsl:choose>
                        <!-- If it's an ingested record (not created from within RAMP). -->
                        <xsl:when
                            test="not(contains(ead:ead/ead:eadheader/ead:eadid/@identifier,'RAMP'))">
                            <!-- agentType = "machine" -->
                            <agentType>machine</agentType>
                        </xsl:when>
                        <!-- If it's a RAMP-created record. -->
                        <xsl:otherwise>
                            <!-- agentType = "human" -->
                            <agentType>human</agentType>
                        </xsl:otherwise>
                    </xsl:choose>
                    <agent>XSLT ead2eac.xsl/libxslt</agent>
                    <xsl:choose>
                        <!-- If it's an ingested record (not created from within RAMP). -->
                        <xsl:when
                            test="not(contains(ead:ead/ead:eadheader/ead:eadid/@identifier,'RAMP'))">
                            <!-- Provide the appropriate eventDescription. -->
                            <eventDescription>
                                <xsl:value-of select="$pEventDescDerive"/>
                            </eventDescription>
                        </xsl:when>
                        <!-- If it's a RAMP-created record... -->
                        <xsl:otherwise>
                            <!-- Provide the appropriate eventDescription. -->
                            <eventDescription>
                                <xsl:value-of
                                    select="ead:ead/ead:archdesc/ead:did/ead:note[@type='creation']/ead:p"
                                />
                            </eventDescription>
                        </xsl:otherwise>
                    </xsl:choose>
                </maintenanceEvent>
            </maintenanceHistory>
            <xsl:call-template name="sources"/>
        </control>
    </xsl:template>

    <!-- Process source elements. -->
    <xsl:template name="sources">
        <xsl:if test="ead:ead/ead:eadheader/ead:filedesc!=''">
            <sources xmlns="urn:isbn:1-931666-33-4">
                <xsl:if test="ead:ead/ead:eadheader/ead:filedesc!=''">
                    <xsl:for-each
                        select="ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper[not(@type='filing')]">
                        <source xlink:type="simple"
                            xlink:href="{concat($pLocalURL,substring-after(../../../ead:eadid/@identifier,':'))}">
                            <sourceEntry>
                                <xsl:value-of select="."/>
                            </sourceEntry>
                            <objectXMLWrap>
                                <eadheader xmlns="urn:isbn:1-931666-22-9">
                                    <xsl:copy-of select="../../../ead:eadid"/>
                                    <filedesc>
                                        <xsl:copy-of select="parent::ead:titlestmt"/>
                                        <xsl:if
                                            test="contains(../../../../ead:archdesc/ead:did/ead:note,'Creative Commons Attribution-Sharealike 3.0')">
                                            <publicationstmt>
                                                <p>
                                                  <xsl:value-of
                                                  select="../../../../ead:archdesc/ead:did/ead:note/ead:p[2]"
                                                  />
                                                </p>
                                            </publicationstmt>
                                        </xsl:if>
                                    </filedesc>
                                    <xsl:copy-of select="../../../ead:profiledesc"/>
                                    <xsl:copy-of select="../../../ead:revisiondesc"/>
                                </eadheader>
                            </objectXMLWrap>
                        </source>
                    </xsl:for-each>
                </xsl:if>
            </sources>
        </xsl:if>
    </xsl:template>

    <!-- Process top-level cpfDescription element. -->
    <xsl:template name="cpfDescription">
        <cpfDescription xmlns="urn:isbn:1-931666-33-4">
            <xsl:call-template name="identity"/>
            <xsl:call-template name="description"/>
            <xsl:call-template name="relations"/>
        </cpfDescription>
    </xsl:template>

    <!-- Process identity element. -->
    <xsl:template name="identity">
        <!-- Define variables for crude regex matching of dates. -->
        <xsl:variable name="vDates"
            select="string-length(translate(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]),concat($vAlpha,$vCommaSpace,$vApos),''))"/>
        <xsl:variable name="vNameStringLen"
            select="string-length(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]))"/>
        <xsl:variable name="vNameString"
            select="substring(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]),1,$vNameStringLen)"/>
        <xsl:variable name="vNameString-1"
            select="substring(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]),$vNameStringLen, $vNameStringLen)"/>
        <xsl:variable name="vNameString-6"
            select="substring(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]),1,$vNameStringLen -6)"/>
        <xsl:variable name="vNameString-8"
            select="substring(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]),1,$vNameStringLen -8)"/>
        <xsl:variable name="vNameString-10"
            select="substring(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]),1,$vNameStringLen -10)"/>
        <xsl:variable name="vNameString-12"
            select="substring(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]),1,$vNameStringLen -12)"/>

        <!-- Check for entity type. -->
        <identity xmlns="urn:isbn:1-931666-33-4">
            <xsl:if
                test="ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1][local-name()='persname']">
                <entityType>person</entityType>
            </xsl:if>
            <xsl:if
                test="ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1][local-name()='corpname']">
                <entityType>corporateBody</entityType>
            </xsl:if>
            <xsl:if
                test="ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1][local-name()='famname']">
                <entityType>family</entityType>
            </xsl:if>
            <nameEntry scriptCode="Latn" xml:lang="en">
                <xsl:choose>
                    <!-- For Archon-exported EADs, use the value of the @normal attribute. -->
                    <xsl:when
                        test="ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1]/@normal">
                        <part>
                            <xsl:value-of
                                select="ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1]/@normal"
                            />
                        </part>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Otherwise, try to do some pattern matching and string manipulation to parse names and dates. -->
                        <xsl:choose>
                            <xsl:when
                                test="string-length(translate(normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1]),
                                concat($vAlpha,$vCommaSpace),''))&gt;=4">
                                <part>
                                    <xsl:choose>
                                        <xsl:when test="$vDates=8">
                                            <xsl:choose>
                                                <xsl:when test="$vNameString-1=')'">
                                                  <xsl:value-of
                                                  select="substring-before($vNameString-10,',')"/>
                                                  <xsl:text>, </xsl:text>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="contains(substring-after($vNameString-12,', '),',')">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after($vNameString-12,', '),',')"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="substring-after($vNameString-12,', ')"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="substring-before($vNameString-10,',')"/>
                                                  <xsl:text>, </xsl:text>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="contains(substring-after($vNameString-10,', '),',')">
                                                  <xsl:value-of
                                                  select="substring-before(substring-after($vNameString-10,', '),',')"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="substring-after($vNameString-10,', ')"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:when test="$vDates=4 or $vDates=5">
                                            <xsl:choose>
                                                <xsl:when test="$vNameString-1=')'">
                                                  <xsl:value-of
                                                  select="substring-before($vNameString-6,',')"/>
                                                  <xsl:text>, </xsl:text>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="contains(substring-after($vNameString-8,', '),',')">
                                                  <xsl:choose>
                                                  <xsl:when test="contains($vNameString,' b. ')">
                                                  <xsl:value-of
                                                  select="substring-after(substring-before($vNameString,', b. '),', ')"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when test="contains($vNameString,' b ')">
                                                  <xsl:value-of
                                                  select="substring-after(substring-before($vNameString,', b '),', ')"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when test="contains($vNameString,' d. ')">
                                                  <xsl:value-of
                                                  select="substring-after(substring-before($vNameString,', d. '),', ')"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when test="contains($vNameString,' d ')">
                                                  <xsl:value-of
                                                  select="substring-after(substring-before($vNameString,', d '),', ')"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="substring-before(substring-after($vNameString-8,', '),',')"
                                                  />
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="substring-after($vNameString-8,', ')"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="substring-before($vNameString-6,',')"/>
                                                  <xsl:text>, </xsl:text>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="contains(substring-after($vNameString-6,', '),',')">
                                                  <xsl:choose>
                                                  <xsl:when test="contains($vNameString-6,' b. ')">
                                                  <xsl:value-of
                                                  select="substring-after(substring-before($vNameString,', b. '),', ')"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when test="contains($vNameString-6,' b ')">
                                                  <xsl:value-of
                                                  select="substring-after(substring-before($vNameString,', b '),', ')"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when test="contains($vNameString-6,' d. ')">
                                                  <xsl:value-of
                                                  select="substring-after(substring-before($vNameString,', d. '),', ')"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when test="contains($vNameString-6,' d ')">
                                                  <xsl:value-of
                                                  select="substring-after(substring-before($vNameString,', d '),', ')"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="substring-before(substring-after($vNameString-6,', '),',')"
                                                  />
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="substring-after($vNameString-6,', ')"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                    </xsl:choose>
                                </part>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- For corporate bodies, output the string as is. -->
                                <part>
                                    <xsl:value-of
                                        select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1])"
                                    />
                                </part>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1]/@source">
                    <authorizedForm>
                        <xsl:value-of
                            select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1]/@source)"
                        />
                    </authorizedForm>
                </xsl:if>
            </nameEntry>
        </identity>
    </xsl:template>

    <!-- Process description element. -->
    <xsl:template name="description">
        <description xmlns="urn:isbn:1-931666-33-4">
            <!-- Call template for parsing dates. -->
            <xsl:call-template name="tExistDates">
                <xsl:with-param name="pName"
                    select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1])"
                />
            </xsl:call-template>

            <!-- De-dupe language elements, if needed. -->
            <xsl:if test="//ead:ead/ead:archdesc/ead:did/ead:langmaterial/ead:language!=''">
                <xsl:choose>
                    <xsl:when test="//ead:ead[2]/ead:archdesc/ead:did/ead:langmaterial/ead:language">
                        <languagesUsed>
                            <languageUsed>
                                <language languageCode="{$vLangCheck/@langcode}">
                                    <xsl:value-of select="$vLangCheck"/>
                                </language>
                                <!-- The majority of cases will be Latin, but will otherwise need to be modified. -->
                                <script scriptCode="Latn">Latin</script>
                            </languageUsed>
                            <xsl:for-each
                                select="ead:ead/ead:archdesc/ead:did/ead:langmaterial/ead:language[.!=$vLangCheck]">
                                <languageUsed>
                                    <language languageCode="{./@langcode}">
                                        <xsl:value-of select="."/>
                                    </language>
                                    <script scriptCode="Latn">Latin</script>
                                </languageUsed>
                            </xsl:for-each>
                        </languagesUsed>
                    </xsl:when>
                    <xsl:otherwise>
                        <languagesUsed>
                            <xsl:for-each
                                select="ead:ead/ead:archdesc/ead:did/ead:langmaterial/ead:language">
                                <languageUsed>
                                    <language languageCode="{./@langcode}">
                                        <xsl:value-of select="."/>
                                    </language>
                                    <script scriptCode="Latn">Latin</script>
                                </languageUsed>
                            </xsl:for-each>
                        </languagesUsed>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <!-- Call template for subjects. -->
            <xsl:call-template name="controlAccess"/>

            <!-- Process biogHist element. -->
            <xsl:if test="ead:ead/ead:archdesc/ead:bioghist">
                <biogHist>
                    <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:abstract">
                        <xsl:if test=".!='&#160;' and .!=''">
                            <abstract>
                                <xsl:apply-templates
                                    select="ead:ead/ead:archdesc/ead:did/ead:abstract"/>
                            </abstract>
                        </xsl:if>
                    </xsl:if>
                    <!-- Match properly formatted chronologies -->
                    <xsl:choose>
                        <xsl:when test="ead:ead/ead:archdesc/ead:bioghist/ead:list">
                            <list>
                                <xsl:for-each select="ead:item">
                                    <item>
                                        <xsl:apply-templates/>
                                    </item>
                                </xsl:for-each>
                            </list>
                        </xsl:when>
                        <xsl:when test="ead:ead/ead:archdesc/ead:bioghist/ead:chronlist">
                            <chronList>
                                <xsl:for-each
                                    select="ead:ead/ead:archdesc/ead:bioghist/ead:chronlist/ead:chronitem">
                                    <xsl:variable name="vDateVal" select="normalize-space(ead:date)"/>
                                    <chronItem>
                                        <xsl:choose>
                                            <xsl:when test="contains($vDateVal,'-')">
                                                <dateRange>
                                                  <fromDate
                                                  standardDate="{substring-before($vDateVal,'-')}">
                                                  <xsl:value-of
                                                  select="substring-before($vDateVal,'-')"/>
                                                  </fromDate>
                                                  <toDate
                                                  standardDate="{substring-after($vDateVal,'-')}">
                                                  <xsl:value-of
                                                  select="substring-after($vDateVal,'-')"/>
                                                  </toDate>
                                                </dateRange>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <date standardDate="{$vDateVal}">
                                                  <xsl:value-of select="$vDateVal"/>
                                                </date>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <event>
                                            <xsl:choose>
                                                <xsl:when test="ead:eventgrp">
                                                  <xsl:for-each select="ead:eventgrp/ead:event">
                                                  <xsl:variable name="vStrLen"
                                                  select="string-length(.)"/>
                                                  <xsl:choose>
                                                  <xsl:when test="substring(.,$vStrLen)=' '">
                                                  <xsl:value-of select="normalize-space(.)"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="normalize-space(.)"/>
                                                  <xsl:text> </xsl:text>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of select="normalize-space(ead:event)"
                                                  />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </event>
                                    </chronItem>
                                </xsl:for-each>
                            </chronList>
                        </xsl:when>
                    </xsl:choose>

                    <!-- Attempt to match local formatting for chronologies in Archon -->
                    <xsl:for-each select="ead:ead[1]/ead:archdesc/ead:bioghist/ead:p">
                        <xsl:choose>
                            <xsl:when test="contains(.,'Chronolog') or contains(.,'Timeline')">
                                <chronList>
                                    <xsl:for-each
                                        select="following-sibling::ead:p[string-length()&lt;=10]">
                                        <xsl:variable name="vDateVal" select="normalize-space(.)"/>
                                        <chronItem>
                                            <xsl:choose>
                                                <xsl:when test="contains($vDateVal,'-')">
                                                  <dateRange>
                                                  <fromDate
                                                  standardDate="{substring-before($vDateVal,'-')}">
                                                  <xsl:value-of
                                                  select="substring-before($vDateVal,'-')"/>
                                                  </fromDate>
                                                  <toDate
                                                  standardDate="{substring-after($vDateVal,'-')}">
                                                  <xsl:value-of
                                                  select="substring-after($vDateVal,'-')"/>
                                                  </toDate>
                                                  </dateRange>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <date standardDate="{$vDateVal}">
                                                  <xsl:value-of select="$vDateVal"/>
                                                  </date>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <event>
                                                <xsl:for-each
                                                  select="following-sibling::ead:p[string-length()&gt;10]">
                                                  <xsl:if
                                                  test="preceding-sibling::ead:p[string-length()&lt;=10][1]=$vDateVal">
                                                  <xsl:value-of select="normalize-space(.)"/>
                                                  <xsl:text> </xsl:text>
                                                  </xsl:if>
                                                </xsl:for-each>
                                            </event>
                                        </chronItem>
                                    </xsl:for-each>
                                </chronList>
                            </xsl:when>
                            <xsl:when test="contains(.,'Employment History')">
                                <p>
                                    <xsl:value-of select="normalize-space(.)"/>
                                </p>
                                <chronList>
                                    <xsl:for-each
                                        select="following-sibling::ead:p[string-length(substring(.,1,4))!=string-length(translate(substring(.,1,4),$vDigits,''))]">
                                        <xsl:variable name="vDateVal"
                                            select="substring-before(normalize-space(.),':')"/>
                                        <chronItem>
                                            <xsl:choose>
                                                <xsl:when test="contains($vDateVal,'-')">
                                                  <dateRange>
                                                  <fromDate
                                                  standardDate="{substring-before($vDateVal,'-')}">
                                                  <xsl:value-of
                                                  select="substring-before($vDateVal,'-')"/>
                                                  </fromDate>
                                                  <toDate
                                                  standardDate="{substring-after($vDateVal,'-')}">
                                                  <xsl:value-of
                                                  select="substring-after($vDateVal,'-')"/>
                                                  </toDate>
                                                  </dateRange>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <date standardDate="{$vDateVal}">
                                                  <xsl:value-of select="$vDateVal"/>
                                                  </date>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <event>
                                                <xsl:value-of select="substring-after(.,': ')"/>
                                            </event>
                                        </chronItem>
                                    </xsl:for-each>
                                </chronList>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if
                                    test="not(contains(.,'Chronolog')) 
                                    and not(contains(.,'Timeline')) 
                                    and not(contains(.,'Employment History'))">
                                    <xsl:if
                                        test="not(preceding-sibling::ead:p[contains(.,'Chronolog')]) 
                                        and (string-length(substring(.,1,4)) = string-length(translate(substring(.,1,4),$vDigits,'')))">
                                        <xsl:if test=".!=' ' and .!=''">
                                            <xsl:choose>
                                                <xsl:when test="contains(.,'\n')">
                                                  <xsl:call-template name="lineSplitter">
                                                  <xsl:with-param name="line"
                                                  select="normalize-space(.)"/>
                                                  <xsl:with-param name="element">p</xsl:with-param>
                                                  </xsl:call-template>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <p>
                                                  <xsl:apply-templates/>
                                                  </p>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </biogHist>
            </xsl:if>
        </description>
    </xsl:template>

    <!-- Template for processing subjects. -->
    <xsl:template match="ead:ead/ead:archdesc/ead:controlaccess/ead:controlaccess"
        name="controlAccess">
        <!-- Store the results of Muenchian grouping inside a variable. -->
        <xsl:variable name="vSubjCheck">
            <xsl:for-each
                select="ead:ead/ead:archdesc/ead:controlaccess/ead:controlaccess[count(. | key('kSubjCheck', child::node()[local-name()!='head'])[1]) = 1]">
                <xsl:for-each select="child::node()[local-name()!='head']">
                    <ead:name encodinganalog="{@encodinganalog}">
                        <xsl:value-of select="."/>
                    </ead:name>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <!-- Then do a second pass over the node set using the EXSL node-set function. -->
        <xsl:for-each
            select="exsl:node-set($vSubjCheck)/ead:name[not(.=preceding-sibling::ead:name)]">
            <xsl:choose>
                <xsl:when test="@encodinganalog='700'">
                    <localDescription localType="700" xmlns="urn:isbn:1-931666-33-4">
                        <term>
                            <xsl:value-of select="."/>
                        </term>
                    </localDescription>
                </xsl:when>
                <xsl:when test="contains(@encodinganalog,'600')">
                    <localDescription localType="600" xmlns="urn:isbn:1-931666-33-4">
                        <term>
                            <xsl:value-of select="."/>
                        </term>
                    </localDescription>
                </xsl:when>
                <xsl:when test="contains(@encodinganalog,'610')">
                    <localDescription localType="610" xmlns="urn:isbn:1-931666-33-4">
                        <term>
                            <xsl:value-of select="."/>
                        </term>
                    </localDescription>
                </xsl:when>
                <xsl:when test="@encodinganalog='650'">
                    <localDescription localType="650" xmlns="urn:isbn:1-931666-33-4">
                        <term>
                            <xsl:value-of select="."/>
                        </term>
                    </localDescription>
                </xsl:when>
                <xsl:when test="@encodinganalog='651'">
                    <localDescription localType="651" xmlns="urn:isbn:1-931666-33-4">
                        <term>
                            <xsl:value-of select="."/>
                        </term>
                    </localDescription>
                </xsl:when>
                <xsl:when test="@encodinganalog='656'">
                    <occupation localType="656" xmlns="urn:isbn:1-931666-33-4">
                        <term>
                            <xsl:value-of select="."/>
                        </term>
                    </occupation>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <!-- Recursive template to turn "\n\n" into <p> tags. Used for processing biography from new record form. To be developed further. -->
    <xsl:template name="lineSplitter">
        <xsl:param name="line"/>
        <xsl:param name="element"/>
        <xsl:param name="element2"/>
        <xsl:choose>
            <xsl:when test="contains($line,'\n') and not(contains($line,'\n\n'))">
                <xsl:choose>
                    <xsl:when test="$element2!=''">
                        <xsl:element name="{$element}" namespace="urn:isbn:1-931666-33-4">
                            <xsl:element name="{$element2}" namespace="urn:isbn:1-931666-33-4">
                                <xsl:value-of select="substring-before($line,'\n')"/>
                            </xsl:element>
                        </xsl:element>
                        <xsl:call-template name="lineSplitter">
                            <xsl:with-param name="line" select="substring-after($line,'\n')"/>
                            <xsl:with-param name="element" select="$element"/>
                            <xsl:with-param name="element2" select="$element2"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="contains($line,'\n\n')">
                <xsl:choose>
                    <xsl:when test="$element2!=''">
                        <xsl:element name="{$element}" namespace="urn:isbn:1-931666-33-4">
                            <xsl:element name="{$element2}" namespace="urn:isbn:1-931666-33-4">
                                <xsl:value-of select="substring-before($line,'\n\n')"/>
                            </xsl:element>
                        </xsl:element>
                        <xsl:call-template name="lineSplitter">
                            <xsl:with-param name="line" select="substring-after($line,'\n\n')"/>
                            <xsl:with-param name="element" select="$element"/>
                            <xsl:with-param name="element2" select="$element2"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="{$element}" namespace="urn:isbn:1-931666-33-4">
                            <xsl:value-of select="substring-before(normalize-space($line),'\n\n')"/>
                        </xsl:element>
                        <xsl:call-template name="lineSplitter">
                            <xsl:with-param name="line"
                                select="substring-after(normalize-space($line),'\n\n')"/>
                            <xsl:with-param name="element" select="$element"/>
                            <xsl:with-param name="element2" select="$element2"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$element2!=''">
                        <xsl:element name="{$element}" namespace="urn:isbn:1-931666-33-4">
                            <xsl:element name="{$element2}" namespace="urn:isbn:1-931666-33-4">
                                <xsl:value-of select="normalize-space($line)"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="{$element}" namespace="urn:isbn:1-931666-33-4">
                            <xsl:value-of select="normalize-space($line)"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Process mixed content elements. -->
    <xsl:template match="ead:abstract">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

    <xsl:template match="ead:emph">
        <span>
            <xsl:attribute name="style">font-style:italic</xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </span>
    </xsl:template>
    
    <xsl:template match="ead:item">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

    <xsl:template match="ead:title">
        <span>
            <xsl:attribute name="style">font-style:italic</xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </span>
    </xsl:template>

    <xsl:template match="ead:p">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

    <!-- Process relation elements. -->
    <xsl:template name="relations">
        <relations xmlns="urn:isbn:1-931666-33-4">
            <!-- Turn associated creators into cpfRelation elements. -->
            <xsl:variable name="vFirstNode"
                select="ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1]"/>
            <xsl:for-each select="$vFirstNode">
                <xsl:if test="following-sibling::node()">
                    <xsl:for-each select="following-sibling::node()">
                        <xsl:variable name="vEntType" select="local-name(.)"/>
                        <xsl:variable name="vCpfRel" select="@normal"/>
                        <xsl:if test="$vEntType='persname'">
                            <cpfRelation xlink:arcrole="associatedWith"
                                xlink:role="http://rdvocab.info/uri/schema/FRBRentitiesRDA/Person"
                                xlink:type="simple" xmlns:xlink="http://www.w3.org/1999/xlink">
                                <relationEntry>
                                    <xsl:value-of select="normalize-space(.)"/>
                                </relationEntry>
                                <descriptiveNote>
                                    <p>
                                        <xsl:text>recordId: </xsl:text>
                                        <xsl:choose>
                                            <xsl:when
                                                test="contains(../../../../ead:eadheader/ead:eadid,'/')">
                                                <xsl:value-of
                                                  select="substring-after(../../../../ead:eadheader/ead:eadid,'/')"/>
                                                <xsl:text>.</xsl:text>
                                                <xsl:value-of
                                                  select="substring-after(../../../../ead:eadheader/ead:eadid/@identifier,':')"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of
                                                  select="../../../../ead:eadheader/ead:eadid"/>
                                                <xsl:text>.</xsl:text>
                                                <xsl:value-of
                                                  select="substring-after(../../../../ead:eadheader/ead:eadid/@identifier,':')"
                                                />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:for-each select="following-sibling::ead:name">
                                            <xsl:variable name="vCpfId" select="@id"/>
                                            <xsl:if test=".=$vCpfRel">
                                                <xsl:value-of select="concat('.',@id)"/>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </p>
                                </descriptiveNote>
                            </cpfRelation>
                        </xsl:if>
                        <xsl:if test="$vEntType='corpname'">
                            <cpfRelation xlink:arcrole="associatedWith"
                                xlink:role="http://rdvocab.info/uri/schema/FRBRentitiesRDA/CorporateBody"
                                xlink:type="simple" xmlns:xlink="http://www.w3.org/1999/xlink">
                                <relationEntry>
                                    <xsl:value-of select="normalize-space(.)"/>
                                </relationEntry>
                                <!-- Assign record IDs based on ID from Archon. -->
                                <descriptiveNote>
                                    <p>
                                        <xsl:text>recordId: </xsl:text>
                                        <xsl:choose>
                                            <xsl:when
                                                test="contains(../../../../ead:eadheader/ead:eadid,'/')">
                                                <xsl:value-of
                                                  select="substring-after(../../../../ead:eadheader/ead:eadid,'/')"/>
                                                <xsl:text>.</xsl:text>
                                                <xsl:value-of
                                                  select="substring-after(../../../../ead:eadheader/ead:eadid/@identifier,':')"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of
                                                  select="../../../../ead:eadheader/ead:eadid"/>
                                                <xsl:text>.</xsl:text>
                                                <xsl:value-of
                                                  select="substring-after(../../../../ead:eadheader/ead:eadid/@identifier,':')"
                                                />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:for-each select="following-sibling::ead:name">
                                            <xsl:if test=".=$vCpfRel">
                                                <xsl:value-of select="concat('.',@id)"/>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </p>
                                </descriptiveNote>
                            </cpfRelation>
                        </xsl:if>
                        <xsl:if test="$vEntType='famname'">
                            <cpfRelation xlink:arcrole="associatedWith"
                                xlink:role="http://rdvocab.info/uri/schema/FRBRentitiesRDA/Family"
                                xlink:type="simple" xmlns:xlink="http://www.w3.org/1999/xlink">
                                <relationEntry>
                                    <xsl:value-of select="normalize-space(.)"/>
                                </relationEntry>
                                <descriptiveNote>
                                    <p>
                                        <xsl:text>recordId: </xsl:text>
                                        <xsl:choose>
                                            <xsl:when
                                                test="contains(../../../../ead:eadheader/ead:eadid,'/')">
                                                <xsl:value-of
                                                  select="substring-after(../../../../ead:eadheader/ead:eadid,'/')"/>
                                                <xsl:text>.</xsl:text>
                                                <xsl:value-of
                                                  select="substring-after(../../../../ead:eadheader/ead:eadid/@identifier,':')"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of
                                                  select="../../../../ead:eadheader/ead:eadid"/>
                                                <xsl:text>.</xsl:text>
                                                <xsl:value-of
                                                  select="substring-after(../../../../ead:eadheader/ead:eadid/@identifier,':')"
                                                />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:for-each select="following-sibling::ead:name">
                                            <xsl:if test=".=$vCpfRel">
                                                <xsl:value-of select="concat('.',@id)"/>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </p>
                                </descriptiveNote>
                            </cpfRelation>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
            </xsl:for-each>

            <!-- For local archival collections, output EAD snippet in objectXMLWrap. -->
            <xsl:for-each select="ead:ead/ead:archdesc/ead:did/ead:unittitle">
                <resourceRelation resourceRelationType="creatorOf"
                    xlink:href="{concat($pLocalURL,substring-after(../../../ead:eadheader/ead:eadid/@identifier,':'))}"
                    xlink:role="archivalRecords" xlink:type="simple"
                    xmlns:xlink="http://www.w3.org/1999/xlink">
                    <relationEntry>
                        <xsl:choose>
                            <!-- Process inclusive and bulk dates. -->
                            <xsl:when test=".">
                                <xsl:value-of select="normalize-space(text())"/>
                                <xsl:text>, </xsl:text>
                                <xsl:value-of
                                    select="normalize-space(ead:unitdate[@type='inclusive'])"/>
                                <xsl:if test="ead:unitdate[@type='bulk']">
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of
                                        select="normalize-space(ead:unitdate[@type='bulk'])"/>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(.)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </relationEntry>
                    <objectXMLWrap>
                        <xsl:element name="archdesc" namespace="urn:isbn:1-931666-22-9">
                            <xsl:copy-of select="parent::ead:did/ead:head"/>
                            <xsl:copy-of select="."/>
                            <xsl:copy-of select="parent::ead:did/ead:unitid"/>
                            <xsl:element name="origination" namespace="urn:isbn:1-931666-22-9">
                                <xsl:attribute name="label">
                                    <xsl:value-of select="parent::ead:did/ead:origination/@label"/>
                                </xsl:attribute>
                                <xsl:attribute name="encodinganalog">
                                    <xsl:value-of
                                        select="parent::ead:did/ead:origination/@encodinganalog"/>
                                </xsl:attribute>
                                <xsl:for-each
                                    select="parent::ead:did/ead:origination/child::node()[not(local-name()='name')]">
                                    <xsl:copy-of select="."/>
                                </xsl:for-each>
                            </xsl:element>
                            <xsl:for-each
                                select="parent::ead:did/ead:origination/following-sibling::node()">
                                <xsl:copy-of select="."/>
                            </xsl:for-each>
                            <!-- Include Scope and Contents. -->
                            <xsl:if test="../../ead:scopecontent">
                                <xsl:if test=". != '&#160;' ">
                                    <xsl:copy-of select="../../ead:scopecontent"/>
                                </xsl:if>
                            </xsl:if>
                        </xsl:element>
                    </objectXMLWrap>
                </resourceRelation>
            </xsl:for-each>
            <!-- Process local digital collections. -->
            <xsl:if test="ead:ead/ead:archdesc/ead:dao">
                <xsl:for-each select="ead:ead/ead:archdesc/ead:dao">
                    <resourceRelation resourceRelationType="creatorOf" xlink:href="{@xlink:href}"
                        xlink:role="archivalRecords" xlink:type="simple"
                        xmlns:xlink="http://www.w3.org/1999/xlink">
                        <relationEntry>
                            <xsl:value-of select="normalize-space(ead:daodesc/ead:p)"/>
                            <xsl:if
                                test="not(contains(ead:daodesc/ead:p,'Digit') and not(contains(ead:daodesc/ead:p,'digit')))">
                                <xsl:text> (digital collection)</xsl:text>
                            </xsl:if>
                        </relationEntry>
                    </resourceRelation>
                </xsl:for-each>
            </xsl:if>

            <!-- The following represents different attempts to account for variations in local formatting / data entry for relatedmaterial elements. -->
            <!-- Code will need to be adapted to local markup. -->
            <xsl:if test="ead:ead/ead:archdesc/ead:descgrp/ead:relatedmaterial">
                <xsl:for-each
                    select="ead:ead/ead:archdesc/ead:descgrp/ead:relatedmaterial/ead:p/ead:extref">
                    <xsl:choose>
                        <xsl:when test="contains(@href,$pServerName)">
                            <resourceRelation xlink:href="{@href}" xlink:role="archivalRecords"
                                xlink:type="simple">
                                <relationEntry>
                                    <xsl:value-of select="normalize-space(.)"/>
                                </relationEntry>
                            </resourceRelation>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="not(contains(@href,$pServerName))">
                                <resourceRelation xlink:href="{@href}" xlink:role="resource"
                                    xlink:type="simple">
                                    <relationEntry>
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </relationEntry>
                                </resourceRelation>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <!-- Working to parse relatedmaterial elements. For now, if it's not an <extref>, just output the contents in a simple <resourRelation>. -->
                <xsl:for-each
                    select="ead:ead/ead:archdesc/ead:descgrp/ead:relatedmaterial/ead:p[not(ead:extref)]">
                    <xsl:variable name="vRelatedCollection"
                        select="translate(normalize-space(.),$vUpper,$vLower)"/>
                    <xsl:if test="not(substring(.,string-length(.))=':')">
                        <resourceRelation>
                            <xsl:if test="contains($vRelatedCollection,'http:')">
                                <xsl:attribute name="xlink:href">
                                    <xsl:value-of
                                        select="concat('http:',substring-after(.,'http:'))"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:attribute name="xlink:type">
                                <xsl:value-of select="'simple'"/>
                            </xsl:attribute>
                            <relationEntry>
                                <xsl:value-of select="."/>
                            </relationEntry>
                        </resourceRelation>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </relations>
    </xsl:template>

    <!-- Template for parsing dates. -->
    <xsl:template name="tExistDates">
        <xsl:param name="pName"/>
        <xsl:choose>
            <!-- If the first nameEntry contains a four-digit number (we assume a date)... -->
            <xsl:when
                test="string-length(translate($pName,concat($vAlpha,$vCommaSpace,$vApos),''))&gt;=4">
                <xsl:element name="existDates" namespace="urn:isbn:1-931666-33-4">
                    <xsl:element name="dateRange" namespace="urn:isbn:1-931666-33-4">
                        <!-- Output the birth year, if exists. -->
                        <xsl:choose>
                            <xsl:when test="substring-before($pName,'-')!=''">
                                <xsl:choose>
                                    <xsl:when test="contains(substring-after($pName,'-'),'-')">
                                        <xsl:element name="fromDate"
                                            namespace="urn:isbn:1-931666-33-4">
                                            <xsl:value-of
                                                select="translate(substring-before(substring-after($pName,'-'),'-'),concat($vAlpha,$vCommaSpace,$vApos),'')"
                                            />
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="fromDate"
                                            namespace="urn:isbn:1-931666-33-4">
                                            <xsl:value-of
                                                select="translate(substring-before($pName,'-'),concat($vAlpha,$vCommaSpace,$vApos),'')"
                                            />
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($pName,' b ')">
                                <xsl:element name="fromDate" namespace="urn:isbn:1-931666-33-4">
                                    <xsl:value-of select="substring-after($pName,' b ')"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($pName,' b. ')">
                                <xsl:element name="fromDate" namespace="urn:isbn:1-931666-33-4">
                                    <xsl:value-of select="substring-after($pName,' b. ')"/>
                                </xsl:element>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                            <!-- Output the death year, if exists. -->
                            <xsl:when test="substring-after($pName,'-')!=''">
                                <xsl:choose>
                                    <xsl:when test="contains(substring-after($pName,'-'),'-')">
                                        <xsl:element name="toDate"
                                            namespace="urn:isbn:1-931666-33-4">
                                            <xsl:value-of
                                                select="translate(substring-after(substring-after($pName,'-'),'-'),concat($vAlpha,$vCommaSpace,$vApos),'')"
                                            />
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="toDate"
                                            namespace="urn:isbn:1-931666-33-4">
                                            <xsl:value-of
                                                select="translate(substring-after($pName,'-'),concat($vAlpha,$vCommaSpace,$vApos),'')"
                                            />
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="contains($pName,' d ')">
                                <xsl:element name="toDate" namespace="urn:isbn:1-931666-33-4">
                                    <xsl:value-of select="substring-after($pName,' d ')"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="contains($pName,' d. ')">
                                <xsl:element name="toDate" namespace="urn:isbn:1-931666-33-4">
                                    <xsl:value-of select="substring-after($pName,' d. ')"/>
                                </xsl:element>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
