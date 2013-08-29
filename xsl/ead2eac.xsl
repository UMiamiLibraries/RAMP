<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:ead="urn:isbn:1-931666-22-9" xmlns:eac="urn:isbn:1-931666-33-4"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl"
    exclude-result-prefixes="eac xsi" version="1.0">

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
    <xsl:variable name="vUpper" select="'AÁÀBCDEÉÈFGHIÍJKLMNÑOÓPQRSTUÚÜVWXYZ'"/>

    <xsl:variable name="vLower" select="'aáàbcdeéèfghiíjklmnñoópqrstuúüvwxyz'"/>

    <xsl:variable name="vAlpha" select="concat($vUpper,$vLower,$vPunct)"/>

    <xsl:variable name="vDigits" select="'0123456789'"/>

    <xsl:variable name="vPunct" select="';:.¿?!()[]-“”’'"/>

    <xsl:variable name="vPunct2" select="',.'"/>

    <xsl:variable name="vCommaSpace" select="', '"/>

    <xsl:variable name="vQuote">"</xsl:variable>

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- Call the top-level templates. -->
    <xsl:template match="/">
        <xsl:choose>
            <!-- Case to accommodate local merged EADs, which contain fake EAD wrapper elements. -->
            <xsl:when test="/ead:ead/ead:ead">
                <xsl:for-each select="ead:ead">
                    <eac-cpf xmlns="urn:isbn:1-931666-33-4" xmlns:ead="urn:isbn:1-931666-22-9"
                        xmlns:xlink="http://www.w3.org/1999/xlink">
                        <xsl:call-template name="control"/>
                        <xsl:call-template name="cpfDescription"/>
                    </eac-cpf>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <eac-cpf xmlns="urn:isbn:1-931666-33-4" xmlns:ead="urn:isbn:1-931666-22-9"
                    xmlns:xlink="http://www.w3.org/1999/xlink">
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
                    <xsl:when test="contains(ead:ead/ead:eadheader/ead:eadid/@identifier,'ramp')">
                        <xsl:value-of select="ead:ead/ead:eadheader/ead:eadid/@identifier"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('ramp-',substring-before($pRecordId,'.'))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </recordId>
            <xsl:choose>
                <!-- If it's an ingested record (not created from within RAMP). -->
                <xsl:when test="not(contains(ead:ead/ead:eadheader/ead:eadid/@identifier,'ramp'))">
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
                            test="not(contains(ead:ead/ead:eadheader/ead:eadid/@identifier,'ramp'))">
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
                            test="not(contains(ead:ead/ead:eadheader/ead:eadid/@identifier,'ramp'))">
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
                            test="not(contains(ead:ead/ead:eadheader/ead:eadid/@identifier,'ramp'))">
                            <!-- Provide the appropriate eventDescription. -->
                            <eventDescription>
                                <xsl:value-of select="$pEventDescDerive"/>
                            </eventDescription>
                        </xsl:when>
                        <!-- If it's a RAMP-created record... -->
                        <xsl:otherwise>
                            <!-- Provide the appropriate eventDescription. -->
                            <eventDescription>
                                <xsl:value-of select="$pEventDescRAMP"/>
                            </eventDescription>
                        </xsl:otherwise>
                    </xsl:choose>
                </maintenanceEvent>
            </maintenanceHistory>
            <xsl:choose>
                <!-- If it's an ingested record (not created from within RAMP). -->
                <xsl:when test="not(contains(ead:ead/ead:eadheader/ead:eadid/@identifier,'ramp'))">
                    <xsl:call-template name="sources"/>
                </xsl:when>
                <!-- If it's RAMP-created, do not include a sources section. -->
                <xsl:otherwise/>
            </xsl:choose>
        </control>
    </xsl:template>

    <!-- Process source elements. -->
    <xsl:template name="sources">
        <sources xmlns="urn:isbn:1-931666-33-4">
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
        </sources>
    </xsl:template>

    <!-- controlAccess template currently empty because of problems with output from Archon. -->
    <xsl:template match="ead:ead/ead:archdesc/ead:controlaccess" name="controlAccess"/>

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
            <nameEntry xmlns="urn:isbn:1-931666-33-4">
                <!-- If the first nameEntry contains a four-digit number (we assume a date)... -->
                <xsl:choose>
                    <xsl:when
                        test="string-length(translate(normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1]),
                        concat($vAlpha,$vCommaSpace),''))&gt;=4">
                        <part>
                            <xsl:value-of
                                select="normalize-space(concat(substring-before(ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1],', '),', ',
                                substring-before(substring-after(ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1],', '),', ')))"
                            />
                        </part>
                    </xsl:when>
                    <xsl:otherwise>
                        <part>
                            <xsl:value-of
                                select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1])"
                            />
                        </part>
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
            <xsl:call-template name="tExistDates">
                <xsl:with-param name="pName"
                    select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1])"
                />
            </xsl:call-template>
            <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:langmaterial/ead:language">
                <languagesUsed>
                    <xsl:for-each
                        select="ead:ead/ead:archdesc/ead:did/ead:langmaterial/ead:language">
                        <languageUsed>
                            <language languageCode="{./@langcode}">
                                <xsl:value-of select="."/>
                            </language>
                            <!-- The majority of cases will be Latin, but will otherwise need to be modified. -->
                            <script scriptCode="Latn">Latin</script>
                        </languageUsed>
                    </xsl:for-each>
                </languagesUsed>
            </xsl:if>
            <!-- Process biogHist element. -->
            <xsl:if test="ead:ead/ead:archdesc/ead:bioghist">
                <biogHist>
                    <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:abstract">
                        <xsl:if test=". != '&#160;' ">
                            <abstract>
                                <xsl:apply-templates
                                    select="ead:ead/ead:archdesc/ead:did/ead:abstract"/>
                            </abstract>
                        </xsl:if>
                    </xsl:if>
                    <!-- Attempt to match local formatting for Chronologies in Archon -->
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
                                        <xsl:if test=". != '&#160;' ">
                                            <xsl:choose>
                                                <xsl:when test="contains(.,'\n\n')">
                                                  <xsl:call-template name="lineSplitter">
                                                  <xsl:with-param name="line" select="."/>
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

    <!-- Recursive template to turn "\n\n" into <p> tags. -->
    <xsl:template name="lineSplitter">
        <xsl:param name="line"/>
        <xsl:choose>
            <xsl:when test="contains($line,'\n\n') or contains($line,'\r\n\r\n')">
                <xsl:element name="p" namespace="urn:isbn:1-931666-33-4">
                    <xsl:if test="contains($line,'\n\n')">
                        <xsl:value-of select="normalize-space(substring-before($line,'\n\n'))"/>
                    </xsl:if>
                    <xsl:if test="contains($line,'\r\n\r\n')">
                        <xsl:value-of select="normalize-space(substring-before($line,'\r\n\r\n'))"/>
                    </xsl:if>
                </xsl:element>
                <xsl:choose>
                    <xsl:when test="contains($line,'\n\n')">
                        <xsl:call-template name="lineSplitter">
                            <xsl:with-param name="line"
                                select="normalize-space(substring-after($line,'\n\n'))"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains($line,'\r\n\r\n')">
                        <xsl:call-template name="lineSplitter">
                            <xsl:with-param name="line"
                                select="normalize-space(substring-after($line,'r\n\r\n'))"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="p" namespace="urn:isbn:1-931666-33-4">
                    <xsl:value-of select="normalize-space($line)"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Process mixed content emph and p elements. -->
    <xsl:template match="ead:emph">
        <span xmlns="urn:isbn:1-931666-33-4">
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
            <xsl:variable name="vFirstNode"
                select="ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1]"/>
            <xsl:for-each select="$vFirstNode">
                <xsl:if test="following-sibling::node()">
                    <xsl:for-each select="following-sibling::node()">
                        <xsl:variable name="vEntType">
                            <xsl:value-of select="local-name(.)"/>
                        </xsl:variable>
                        <xsl:if test="$vEntType='persname'">
                            <cpfRelation xlink:arcrole="associatedWith"
                                xlink:role="http://RDVocab.info/uri/schema/FRBRentitiesRDA/Person"
                                xlink:type="simple" xmlns:xlink="http://www.w3.org/1999/xlink">
                                <relationEntry>
                                    <xsl:value-of select="."/>
                                </relationEntry>
                            </cpfRelation>
                        </xsl:if>
                        <xsl:if test="$vEntType='corpname'">
                            <cpfRelation xlink:arcrole="associatedWith"
                                xlink:role="http://RDVocab.info/uri/schema/FRBRentitiesRDA/CorporateBody"
                                xlink:type="simple" xmlns:xlink="http://www.w3.org/1999/xlink">
                                <relationEntry>
                                    <xsl:value-of select="."/>
                                </relationEntry>
                            </cpfRelation>
                        </xsl:if>
                        <xsl:if test="$vEntType='famname'">
                            <cpfRelation xlink:arcrole="associatedWith"
                                xlink:role="http://RDVocab.info/uri/schema/FRBRentitiesRDA/Family"
                                xlink:type="simple" xmlns:xlink="http://www.w3.org/1999/xlink">
                                <relationEntry>
                                    <xsl:value-of select="."/>
                                </relationEntry>
                            </cpfRelation>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
            </xsl:for-each>
            <!-- For local archival collections, output EAD snippet in objectXMLWrap. -->
            <xsl:for-each select="ead:ead/ead:archdesc/ead:did/ead:unittitle">
                <resourceRelation xmlns="urn:isbn:1-931666-33-4" xlink:arcrole="creatorOf"
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
                                    <xsl:text>; </xsl:text>
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
                            <xsl:copy-of select="parent::node()"/>
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
                    <resourceRelation xmlns="urn:isbn:1-931666-33-4" xlink:arcrole="creatorOf"
                        xlink:href="{@xlink:href}" xlink:role="archivalRecords" xlink:type="simple"
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

            <!-- Not currently including subject headings due to corrupt output from Archon batch export.
            <xsl:for-each select="/ead:ead/ead:archdesc/ead:controlaccess/ead:controlaccess/ead:persname">
                <cpfRelation>
                    <relationEntry>
                        <xsl:value-of select="normalize-space(.)"/>
                    </relationEntry>
                </cpfRelation>
            </xsl:for-each>
            -->

            <!-- The following represents different attempts to account for variations in local formatting / data entry for relatedmaterial elements. -->
            <!-- Code will need to be adapted to local markup. -->
            <xsl:if test="ead:ead/ead:archdesc/ead:descgrp/ead:relatedmaterial">
                <xsl:for-each
                    select="ead:ead/ead:archdesc/ead:descgrp/ead:relatedmaterial/ead:p/ead:extref">
                    <xsl:choose>
                        <xsl:when test="contains(@href,$pServerName)">
                            <resourceRelation xmlns="urn:isbn:1-931666-33-4" xlink:href="{@href}"
                                xlink:role="archivalRecords" xlink:type="simple">
                                <relationEntry>
                                    <xsl:value-of select="normalize-space(.)"/>
                                </relationEntry>
                            </resourceRelation>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="not(contains(@href,$pServerName))">
                                <resourceRelation xmlns="urn:isbn:1-931666-33-4"
                                    xlink:href="{@href}" xlink:role="resource" xlink:type="simple">
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
                        <resourceRelation xmlns="urn:isbn:1-931666-33-4">
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

    <xsl:template name="tExistDates">
        <xsl:param name="pName"/>
        <xsl:choose>
            <!-- If the first nameEntry contains a four-digit number (we assume a date)... -->
            <xsl:when test="string-length(translate($pName,concat($vAlpha,$vCommaSpace),''))&gt;=4">
                <xsl:element name="existDates" namespace="urn:isbn:1-931666-33-4">
                    <xsl:element name="dateRange" namespace="urn:isbn:1-931666-33-4">
                        <!-- Output the birth year, if exists. -->
                        <xsl:if test="substring-before($pName,'-')">
                            <xsl:element name="fromDate" namespace="urn:isbn:1-931666-33-4">
                                <xsl:value-of
                                    select="normalize-space(substring-after(substring-after(substring-before($pName,'-'),', '),', '))"
                                />
                            </xsl:element>
                        </xsl:if>
                        <!-- Output the death year, if exists. -->
                        <xsl:if test="substring-after($pName,'-')">
                            <xsl:element name="toDate" namespace="urn:isbn:1-931666-33-4">
                                <xsl:value-of select="normalize-space(substring-after($pName,'-'))"
                                />
                            </xsl:element>
                        </xsl:if>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
