<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eac="urn:isbn:1-931666-33-4" xmlns:ead="urn:isbn:1-931666-22-9" xmlns:exsl="http://exslt.org/common" xmlns:str="http://exslt.org/strings" xmlns:xlink="http://www.w3.org/1999/xlink" extension-element-prefixes="exsl str" exclude-result-prefixes="eac ead" version="1.0">
    <!--
        Author: Timothy A. Thompson
        University of Miami Libraries
        Copyright 2013 University of Miami. Licensed under the Educational Community License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://opensource.org/licenses/ECL-2.0 http://www.osedu.org/licenses/ECL-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
    -->
    <!--
        ead2eac.xsl creates EAC-CPF/XML from EAD/XML finding aids. 
    -->
    <!-- Parameters passed from PHP. -->
    <xsl:param name="pRecordId" />
    <xsl:param name="pAgencyCode" />
    <xsl:param name="pOtherAgencyCode" />
    <xsl:param name="pDate" />
    <xsl:param name="pAgencyName" />
    <xsl:param name="pShortAgencyName" />
    <xsl:param name="pArchonEac" />
    <xsl:param name="pServerName" />
    <xsl:param name="pLocalURL" />
    <xsl:param name="pRepositoryOne" />
    <xsl:param name="pRepositoryTwo" />
    <xsl:param name="pEventDescCreate" />
    <xsl:param name="pEventDescRevise" />
    <xsl:param name="pEventDescExport" />
    <xsl:param name="pEventDescDerive" />
    <xsl:param name="pEventDescRAMP" />
    <!-- Declare variables for basic pattern matching. -->
    <xsl:variable name="vUpper" select="'AÁÀÄBCDEÉÈFGHIÍJKLMNÑOÓPQRSTUÚÜVWXYZ'" />
    <xsl:variable name="vLower" select="'aáàäbcdeéèfghiíjklmnñoópqrstuúüvwxyz'" />
    <xsl:variable name="vAlpha" select="concat($vUpper,$vLower,$vPunct)" />
    <xsl:variable name="vAlpha2" select="concat($vUpper,$vLower,$vPunct2)" />
    <xsl:variable name="vDigits" select="'0123456789'" />
    <xsl:variable name="vPunct" select="'$;:.¿?!()[]-“”’'" />
    <xsl:variable name="vPunct2" select="'$;:.¿?!()[]“”’'" />
    <xsl:variable name="vPunct3" select="',.'" />
    <xsl:variable name="vCommaSpace" select="', '" />
    <xsl:variable name="vQuote">"</xsl:variable>
    <xsl:variable name="vApos">'</xsl:variable>
    <!-- Define variables for basic regex matching of dates. -->
    <xsl:variable name="vDates" select="translate(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]),concat($vAlpha2,$vCommaSpace,$vApos),'')" />
    <xsl:variable name="vDatesLen" select="string-length(translate(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]),concat($vAlpha,$vCommaSpace,$vApos),''))" />
    <xsl:variable name="vNameStringLen" select="string-length(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]))" />
    <xsl:variable name="vNameString" select="substring(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]),1,$vNameStringLen)" />
    <xsl:variable name="vNameString-1" select="substring(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]),$vNameStringLen, $vNameStringLen)" />
    <xsl:variable name="vNameString-6" select="substring(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]),1,$vNameStringLen -6)" />
    <xsl:variable name="vNameString-8" select="substring(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]),1,$vNameStringLen -8)" />
    <xsl:variable name="vNameString-10" select="substring(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]),1,$vNameStringLen -10)" />
    <xsl:variable name="vNameString-12" select="substring(normalize-space(//ead:archdesc/ead:did/ead:origination/child::node()[1]),1,$vNameStringLen -12)" />
    <!-- Define a variable to help de-dupe language elements. -->
    <xsl:variable name="vLangCheck" select="//ead:ead[1]/ead:archdesc/ead:did/ead:langmaterial/ead:language" />
    <!-- Define a key for Muenchian grouping of geogname elements. -->
    <xsl:key name="kGeogCheck" match="//ead:geogname" use="." />
    <!-- Define a key for Muenchian grouping of persgname elements. -->
    <xsl:key name="kNameCheck" match="//ead:scopecontent//ead:persname|//ead:bioghist//ead:persname|//ead:scopecontent//ead:corpname|//ead:scopecontent//ead:corpname" use="." />
    <!-- Define a key for Muenchian grouping of subject elements. -->
    <xsl:key name="kSubjCheck" match="//ead:controlaccess" use="child::node()[local-name()!='head']" />       
    <!-- Define variable for occupations. -->
    <xsl:variable name="vOccupation" select="//ead:ead/ead:archdesc//ead:controlaccess/ead:occupation" />
    <xsl:variable name="vOccuCount" select="count(//ead:occupation)" />
    <!-- Variable for grouping geogname elements. -->
    <xsl:variable name="vGeog">   
        <xsl:for-each select="//ead:geogname">       
            <xsl:sort select="translate(.,'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
            <ead:name>
                <xsl:choose>
                    <xsl:when test="substring(.,string-length(.))=',' or substring(.,string-length(.))='.' or substring(.,string-length(.))=';' or substring(.,string-length(.))=':'">
                        <xsl:value-of select="normalize-space(substring(.,1,string-length(.) -1))" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(.)" />
                    </xsl:otherwise>
                </xsl:choose>
            </ead:name>
        </xsl:for-each>
    </xsl:variable>
    <!-- Variable for grouping persname elements. -->
    <xsl:variable name="vCpfName">
        <xsl:for-each select="//ead:persname[not(contains(parent::ead:origination/@id,'RAMP'))]">   
            <xsl:sort select="translate(.,'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
            <persName>
                <xsl:choose>
                    <xsl:when test="substring(.,string-length(.))=','">
                        <xsl:value-of select="normalize-space(substring(.,1,string-length(.)-1))" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(.)" />
                    </xsl:otherwise>
                </xsl:choose>
            </persName>
        </xsl:for-each>
        <xsl:for-each select="//ead:corpname[not(contains(parent::ead:origination/@id,'RAMP'))]">
            <xsl:sort select="translate(.,'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
            <corpName>
                <xsl:choose>
                    <xsl:when test="substring(.,string-length(.))=',' or substring(.,string-length(.))='.' or substring(.,string-length(.))=';' or substring(.,string-length(.))=':'">
                        <xsl:value-of select="normalize-space(substring(.,1,string-length(.) -1))" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(.)" />
                    </xsl:otherwise>
                </xsl:choose>
            </corpName>
        </xsl:for-each>                
    </xsl:variable>
    <!-- Variables for new record form data. -->
    <xsl:variable name="vFrom" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='from']/ead:p" />
    <xsl:variable name="vTo" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='to']/ead:p" />
    <xsl:variable name="vGender" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='gender']/ead:p" />
    <xsl:variable name="vGenderDateFrom" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='genderDateFrom']/ead:p" />
    <xsl:variable name="vGenderDateTo" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='genderDateTo']/ead:p" />
    <xsl:variable name="vLangName" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='langName']/ead:p" />
    <xsl:variable name="vLangCode" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='langCode']/ead:p" />
    <xsl:variable name="vScriptName" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='scriptName']/ead:p" />
    <xsl:variable name="vScriptCode" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='scriptCode']/ead:p" />
    <xsl:variable name="vSubject" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='subject']/ead:p" />
    <xsl:variable name="vGenre" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='genre']/ead:p" />
    <xsl:variable name="vOccupationNew" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='occupation']/ead:p" />
    <xsl:variable name="vOccuDateFrom" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='occuDateFrom']/ead:p" />
    <xsl:variable name="vOccuDateTo" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='occuDateTo']/ead:p" />
    <xsl:variable name="vPlaceEntry" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='placeEntry']/ead:p" />
    <xsl:variable name="vPlaceRole" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='placeRole']/ead:p" />
    <xsl:variable name="vPlaceDateFrom" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='placeDateFrom']/ead:p" />
    <xsl:variable name="vPlaceDateTo" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='placeDateTo']/ead:p" />
    <xsl:variable name="vCitation" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='citation']/ead:p" />
    <xsl:variable name="vCpf" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='cpf']/ead:p" />
    <xsl:variable name="vResource" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='resource']/ead:p" />
    <xsl:variable name="vResourceID" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='resourceID']/ead:p" />
    <xsl:variable name="vSource" select="ead:ead/ead:archdesc/ead:did/ead:note[@type='source']/ead:p" />
    <xsl:strip-space elements="*" />
    <xsl:output method="xml" encoding="UTF-8" indent="yes" />
    <!-- Call the top-level templates. -->
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="/eac:eac-cpf">
                <xsl:copy-of select="@*|node()" />
            </xsl:when>
            <!-- Case to accommodate local merged EADs, which contain faux EAD wrapper elements. -->
            <xsl:when test="/ead:ead/ead:ead">
                <xsl:for-each select="ead:ead">
                	<eac-cpf xmlns="urn:isbn:1-931666-33-4" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:isbn:1-931666-33-4 http://eac.staatsbibliothek-berlin.de/schema/cpf.xsd" xmlns:xlink="http://www.w3.org/1999/xlink">
                        <xsl:call-template name="tControl" />
                        <xsl:call-template name="tCpfDescription" />
                    </eac-cpf>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
            	<eac-cpf xmlns="urn:isbn:1-931666-33-4" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:isbn:1-931666-33-4 http://eac.staatsbibliothek-berlin.de/schema/cpf.xsd" xmlns:xlink="http://www.w3.org/1999/xlink">
                    <xsl:call-template name="tControl" />
                    <xsl:call-template name="tCpfDescription" />
                </eac-cpf>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Process top-level control element. -->
    <xsl:template name="tControl">
        <control xmlns="urn:isbn:1-931666-33-4">
            <recordId>
                <xsl:choose>
                    <xsl:when test="contains(ead:ead/ead:eadheader/ead:eadid/@identifier,'RAMP')">
                        <xsl:value-of select="ead:ead/ead:eadheader/ead:eadid/@identifier" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('RAMP-',substring-before($pRecordId,'.'))" />
                    </xsl:otherwise>
                </xsl:choose>
            </recordId>
            <xsl:variable name="vEadHeaderCount" select="count(ead:ead/ead:eadheader)" />
            <xsl:choose>
                <!-- If it's an ingested Archon record (not created from within RAMP). -->
                <xsl:when test="contains(//ead:eadid/@identifier,'Archon')">                           
                    <xsl:for-each select="ead:ead/ead:eadheader">
                        <otherRecordId>
                            <xsl:choose>
                                <xsl:when test="$vEadHeaderCount&gt;1">
                                    <xsl:attribute name="localType">
                                        <xsl:value-of select="concat('merged',$pShortAgencyName)" />
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="localType">
                                        <xsl:value-of select="$pShortAgencyName" />
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>                            
                            <xsl:choose>
                                <xsl:when test="contains(ead:eadid,'/')">
                                    <xsl:value-of select="substring-after(ead:eadid,'/')" />
                                    <xsl:text>.</xsl:text>
                                    <xsl:value-of select="substring-after(ead:eadid/@identifier,':')" />
                                    <xsl:text>.</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="ead:eadid" />
                                    <xsl:text>.</xsl:text>
                                    <xsl:value-of select="substring-after(ead:eadid/@identifier,':')" />
                                    <xsl:text>.</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>                                                                         
                            <xsl:value-of select="substring-before($pRecordId,'-')" />
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
                    <xsl:value-of select="$pAgencyCode" />
                </agencyCode>
                <otherAgencyCode localType="MARC">
                    <xsl:value-of select="$pOtherAgencyCode" />
                </otherAgencyCode>
                <agencyName>
                    <xsl:value-of select="$pAgencyName" />
                </agencyName>
            </maintenanceAgency>
            <languageDeclaration>
                <language languageCode="eng">English</language>
                <script scriptCode="Latn">Latin</script>
            </languageDeclaration>
            <!--
            <conventionDeclaration>
                <abbreviation>BAV</abbreviation>
                <citation>Vatican Library</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>BIBSYS</abbreviation>
                <citation>National Library of Norway</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>BNC</abbreviation>
                <citation>National Library of Catalonia</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>BNE</abbreviation>
                <citation>National Library of Spain</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>BNF</abbreviation>
                <citation>National Library of France</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>DBC</abbreviation>
                <citation>Danish Library Center</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>DNB</abbreviation>
                <citation>German National Library</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>EGAXA</abbreviation>
                <citation>Library of Alexandria, Egypt</citation>
            </conventionDeclaration>
            -->
            <conventionDeclaration>
                <abbreviation>FAST</abbreviation>
                <citation>Faceted Application of Subject Terminology</citation>
            </conventionDeclaration>
            <!--
            <conventionDeclaration>
                <abbreviation>ICCU</abbreviation>
                <citation>Central Institute for the Union Catalogue of the Italian Libraries</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>ISNI</abbreviation>
                <citation>International Standard Name Identifier</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>JPG</abbreviation>
                <citation>Union List of Artist Names [Getty Research Institute]</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>LAC</abbreviation>
                <citation>Library and Archives Canada</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>LC</abbreviation>
                <citation>Library of Congress/NACO</citation>
            </conventionDeclaration>
            -->
            <conventionDeclaration>
                <abbreviation>LCCN</abbreviation>
                <citation>Library of Congress Control Number</citation>
            </conventionDeclaration>
            <!--
            <conventionDeclaration>
                <abbreviation>LNB</abbreviation>
                <citation>National Library of Latvia</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>LNL</abbreviation>
                <citation>Lebanese National Library</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>NDL</abbreviation>
                <citation>National Diet Library, Japan</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>NKC</abbreviation>
                <citation>National Library of the Czech Republic</citation>
            </conventionDeclaration>        
            <conventionDeclaration>
                <abbreviation>NLA</abbreviation>
                <citation>National Library of Australia</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>NLI</abbreviation>
                <citation>National Library of Israel</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>NLB</abbreviation>
                <citation>National Library Board, Singapore</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>NLP</abbreviation>
                <citation>National Library of Poland</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>NSK</abbreviation>
                <citation>National and University Library in Zagreb</citation>
            </conventionDeclaration>        
            <conventionDeclaration>
                <abbreviation>NSZL</abbreviation>
                <citation>National Széchényi Library, Hungary</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>NTA</abbreviation>
                <citation>National Library of the Netherlands</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>NUKAT</abbreviation>
                <citation>NUKAT Center of Warsaw University Library</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>PERSEUS</abbreviation>
                <citation>Perseus</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>PTBNP</abbreviation>
                <citation>National Library of Portugal</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>RERO</abbreviation>
                <citation>Library Network of Western Switzerland</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>RSL</abbreviation>
                <citation>Russian State Library</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>SELIBR</abbreviation>
                <citation>National Library of Sweden</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>SUDOC</abbreviation>
                <citation>Sudoc [ABES], France</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>SWNL</abbreviation>
                <citation>Swiss National Library</citation>
            </conventionDeclaration>
            <conventionDeclaration>
                <abbreviation>VLACC</abbreviation>
                <citation>Flemish Public Libraries</citation>
            </conventionDeclaration>
            -->
            <conventionDeclaration>
                <abbreviation>VIAF</abbreviation>
                <citation>Virtual International Authority File</citation>
            </conventionDeclaration>
            <!--
            <conventionDeclaration>
                <abbreviation>WIKIPEDIA</abbreviation>
                <citation>Wikipedia/DBpedia</citation>
            </conventionDeclaration>
            -->
            <conventionDeclaration>
                <abbreviation>WCI</abbreviation>
                <citation>WorldCat Identities</citation>
            </conventionDeclaration>
            <!--
            <conventionDeclaration>
                <abbreviation>WKP</abbreviation>
                <citation>English Wikipedia/DBpedia</citation>
            </conventionDeclaration>
            -->
            <maintenanceHistory>
                <maintenanceEvent>
                    <xsl:choose>
                        <!-- If it's an ingested record (not created from within RAMP). -->
                        <xsl:when test="not(contains(ead:ead/ead:eadheader/ead:eadid/@identifier,'RAMP'))">
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
                            <xsl:value-of select="$pDate" />
                        </xsl:attribute>
                    </eventDateTime>
                    <xsl:choose>
                        <!-- If it's an ingested record (not created from within RAMP). -->
                        <xsl:when test="not(contains(ead:ead/ead:eadheader/ead:eadid/@identifier,'RAMP'))">
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
                        <xsl:when test="not(contains(ead:ead/ead:eadheader/ead:eadid/@identifier,'RAMP'))">
                            <!-- Provide the appropriate eventDescription. -->
                            <eventDescription>
                                <xsl:value-of select="$pEventDescDerive" />
                            </eventDescription>
                        </xsl:when>
                        <!-- If it's a RAMP-created record... -->
                        <xsl:otherwise>
                            <!-- Provide the appropriate eventDescription. -->
                            <eventDescription>
                                <xsl:value-of select="ead:ead/ead:archdesc/ead:did/ead:note[@type='creation']/ead:p" />
                            </eventDescription>
                        </xsl:otherwise>
                    </xsl:choose>
                </maintenanceEvent>
            </maintenanceHistory>
            <xsl:call-template name="tSources" />
        </control>
    </xsl:template>
    <!-- Process source elements. -->
    <xsl:template name="tSources">
        <xsl:choose>
            <xsl:when test="ead:ead/ead:eadheader/ead:filedesc!=''">
                <sources xmlns="urn:isbn:1-931666-33-4">
                    <xsl:if test="ead:ead/ead:eadheader/ead:filedesc!=''">
                        <xsl:for-each select="ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper[not(@type='filing')]">
                        	<source xlink:href="{concat($pLocalURL,substring-after(../../../ead:eadid/@identifier,':'))}" xlink:type="simple">
                                <sourceEntry>
                                    <xsl:value-of select="normalize-space(.)" />
                                </sourceEntry>
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
                                                <xsl:choose>
                                                    <xsl:when test="../../../../ead:archdesc/ead:did/ead:note[@encodinganalog='500']">
                                                        <xsl:copy-of select="../../../../ead:archdesc/ead:did/ead:note[@encodinganalog='500']"/>    
                                                        <xsl:copy-of select="../../../../ead:archdesc/ead:did/ead:langmaterial"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:copy-of select="../../../../ead:archdesc/ead:did/ead:langmaterial"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>                                                                                               
                                            </did>
                                            <xsl:copy-of select="../../../../ead:archdesc/ead:descgrp"/>   
                                        </archdesc>
                                    </ead>                                    
                                </objectXMLWrap>
                            </source>
                        </xsl:for-each>
                    </xsl:if>
                </sources>
            </xsl:when>
            <xsl:when test="$vSource!=''">
                <sources xmlns="urn:isbn:1-931666-33-4">
                    <xsl:call-template name="tSourcesNew" />
                </sources>
            </xsl:when>
        </xsl:choose>               
    </xsl:template>
    <!-- Process top-level cpfDescription element. -->
    <xsl:template name="tCpfDescription">
        <cpfDescription xmlns="urn:isbn:1-931666-33-4">
            <xsl:call-template name="tIdentity" />
            <xsl:call-template name="tDescription" />
            <xsl:call-template name="tRelations" />
        </cpfDescription>
    </xsl:template>
    <!-- Process identity element. -->
    <xsl:template name="tIdentity">
        <!-- Check for entity type. -->
    	<identity xmlns="urn:isbn:1-931666-33-4">
            <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:origination[1]/child::node()[1][local-name()='persname']">
                <entityType>person</entityType>
            </xsl:if>
            <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:origination[1]/child::node()[1][local-name()='corpname']">
                <entityType>corporateBody</entityType>
            </xsl:if>
            <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:origination[1]/child::node()[1][local-name()='famname']">
                <entityType>family</entityType>
            </xsl:if>
    		<nameEntry scriptCode="Latn" xml:lang="en">
                <xsl:choose>
                    <!-- For Archon-exported EADs, use the value of the @normal attribute. -->
                    <xsl:when test="ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1]/@normal">
                        <part>
                            <xsl:value-of select="ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1]/@normal" />
                        </part>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Otherwise, try to do some pattern matching and string manipulation to parse names and dates. -->
                        <xsl:choose>
                            <xsl:when test="string-length(translate(normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1]),                                 concat($vAlpha,$vCommaSpace),''))&gt;=4">
                                <part>
                                    <xsl:choose>
                                        <xsl:when test="$vDatesLen=8">
                                            <xsl:choose>
                                                <xsl:when test="$vNameString-1=')'">
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
                                        <xsl:when test="$vDatesLen=4 or $vDatesLen=5">
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
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="ead:ead/ead:archdesc/ead:did/ead:origination/ead:persname[@encodinganalog='100_1']!=''">
                                        <part localType="surname">
                                            <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/ead:persname[@encodinganalog='100_1'])" />
                                        </part>
                                        <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:origination/ead:persname[@encodinganalog='100_0']!=''">
                                            <part localType="forename">
                                                <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/ead:persname[@encodinganalog='100_0'])" />
                                            </part>
                                        </xsl:if>
                                        <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:note[@type='nameAuth']/ead:p!=''">
                                            <authorizedForm>
                                                <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:note[@type='nameAuth']/ead:p)" />
                                            </authorizedForm>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:when test="ead:ead/ead:archdesc/ead:did/ead:origination/ead:persname[@encodinganalog='100_0']!=''">
                                        <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:origination/ead:persname[@encodinganalog='100_1']!=''">
                                            <part localType="surname">
                                                <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/ead:persname[@encodinganalog='100_1'])" />
                                            </part>
                                        </xsl:if>
                                        <part localType="forename">
                                            <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/ead:persname[@encodinganalog='100_0'])" />
                                        </part>
                                        <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:note[@type='nameAuth']/ead:p!=''">
                                            <authorizedForm>
                                                <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:note[@type='nameAuth']/ead:p)" />
                                            </authorizedForm>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <!-- Output the string as is. -->
                                        <part>
                                            <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1])" />
                                        </part>
                                        <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:note[@type='nameAuth']/ead:p!=''">
                                            <authorizedForm>
                                                <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:note[@type='nameAuth']/ead:p)" />
                                            </authorizedForm>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1]/@source">
                    <authorizedForm>
                        <xsl:value-of select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1]/@source)" />
                    </authorizedForm>
                </xsl:if>
            </nameEntry>
        </identity>
    </xsl:template>
    <!-- Process description element. -->
    <xsl:template name="tDescription">
        <description xmlns="urn:isbn:1-931666-33-4">
            <!-- Call template for parsing dates. -->
            <xsl:call-template name="tExistDates">
                <xsl:with-param name="pName" select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1])" />
            </xsl:call-template>
            <!-- De-dupe language elements, if needed. -->
            <xsl:if test="//ead:ead/ead:archdesc/ead:did/ead:langmaterial/ead:language!='' or $vLangName!=''">
                <xsl:choose>
                    <xsl:when test="//ead:ead[2]/ead:archdesc/ead:did/ead:langmaterial/ead:language">
                        <languagesUsed>
                            <languageUsed>
                                <language languageCode="{$vLangCheck/@langcode}">
                                    <xsl:value-of select="normalize-space($vLangCheck)" />
                                </language>
                                <!-- The majority of cases will be Latin, but will otherwise need to be modified. -->
                                <script scriptCode="Latn">Latin</script>
                            </languageUsed>
                            <xsl:for-each select="ead:ead/ead:archdesc/ead:did/ead:langmaterial/ead:language[.!=$vLangCheck]">
                                <languageUsed>
                                    <language languageCode="{./@langcode}">
                                        <xsl:value-of select="normalize-space(.)" />
                                    </language>
                                    <script scriptCode="Latn">Latin</script>
                                </languageUsed>
                            </xsl:for-each>
                        </languagesUsed>
                    </xsl:when>
                    <xsl:otherwise>
                        <languagesUsed>
                            <xsl:for-each select="ead:ead/ead:archdesc/ead:did/ead:langmaterial/ead:language">
                                <languageUsed>
                                    <language languageCode="{./@langcode}">
                                        <xsl:value-of select="normalize-space(.)" />
                                    </language>
                                    <script scriptCode="Latn">Latin</script>
                                </languageUsed>
                            </xsl:for-each>
                            <xsl:call-template name="tLangs" />
                        </languagesUsed>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <!-- Call template for subjects. -->
            <xsl:call-template name="tControlAccess" />
            <xsl:call-template name="tGenders" />
            <!-- Process biogHist element. -->
            <xsl:if test="ead:ead/ead:archdesc/ead:bioghist">
                <biogHist>
                    <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:abstract[.!='' and .!=' ']">
                        <xsl:apply-templates select="ead:ead/ead:archdesc/ead:did/ead:abstract" />
                    </xsl:if>
                    <!-- Match properly formatted chronologies -->
                    <xsl:choose>
                        <xsl:when test="ead:ead/ead:archdesc/ead:bioghist/ead:list">
                            <list>
                                <xsl:for-each select="ead:item">
                                    <xsl:apply-templates select="." />
                                </xsl:for-each>
                            </list>
                        </xsl:when>
                        <xsl:when test="ead:ead/ead:archdesc/ead:bioghist/ead:chronlist">
                            <chronList>
                                <xsl:for-each select="ead:ead/ead:archdesc/ead:bioghist/ead:chronlist/ead:chronitem">
                                    <xsl:variable name="vDateVal" select="normalize-space(ead:date)" />
                                    <chronItem>
                                        <xsl:choose>
                                            <xsl:when test="contains($vDateVal,'-')">
                                                <dateRange>
                                                    <fromDate standardDate="{substring-before($vDateVal,'-')}">
                                                        <xsl:value-of select="substring-before($vDateVal,'-')" />
                                                    </fromDate>
                                                    <toDate standardDate="{substring-after($vDateVal,'-')}">
                                                        <xsl:value-of select="substring-after($vDateVal,'-')" />
                                                    </toDate>
                                                </dateRange>
                                            </xsl:when>
                                        	<!-- Handle LOC formatted dates. -->
                                        	<xsl:when test="contains($vDateVal,'Jan.')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', Jan.')"/>                                        				
                                        				<xsl:text>-01-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'Jan. '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'Jan. ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>
                                        	</xsl:when>
                                        	<xsl:when test="contains($vDateVal,'Feb.')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', Feb.')"/>                                        				
                                        				<xsl:text>-02-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'Feb. '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'Feb. ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>
                                        	</xsl:when>
                                        	<xsl:when test="contains($vDateVal,'Mar.')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', Mar.')"/>                                        				
                                        				<xsl:text>-03-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'Mar. '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'Mar. ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>                                        		
                                        	</xsl:when>
                                        	<xsl:when test="contains($vDateVal,'Apr.')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', Apr.')"/>                                        				
                                        				<xsl:text>-04-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'Apr. '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'Apr. ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>
                                        	</xsl:when>
                                        	<xsl:when test="contains($vDateVal,'May')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', May')"/>                                        				
                                        				<xsl:text>-05-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'May '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'May ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>
                                        	</xsl:when>
                                        	<xsl:when test="contains($vDateVal,'Jun.')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', Jun.')"/>                                        				
                                        				<xsl:text>-06-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'Jun. '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'Jun. ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>
                                        	</xsl:when>
                                        	<xsl:when test="contains($vDateVal,'Jul.')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', Jul.')"/>                                        				
                                        				<xsl:text>-07-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'Jul. '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'Jul. ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>
                                        	</xsl:when>
                                        	<xsl:when test="contains($vDateVal,'Aug.')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', Aug.')"/>                                        				
                                        				<xsl:text>-08-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'Aug. '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'Aug. ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>
                                        	</xsl:when>
                                        	<xsl:when test="contains($vDateVal,'Sept.')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', Sept.')"/>                                        				
                                        				<xsl:text>-09-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'Sept. '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'Sept. ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>
                                        	</xsl:when>
                                        	<xsl:when test="contains($vDateVal,'Oct.')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', Oct.')"/>                                        				
                                        				<xsl:text>-10-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'Oct. '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'Oct. ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>
                                        	</xsl:when>
                                        	<xsl:when test="contains($vDateVal,'Nov.')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', Nov.')"/>                                        				
                                        				<xsl:text>-11-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'Nov. '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'Nov. ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>
                                        	</xsl:when>
                                        	<xsl:when test="contains($vDateVal,'Dec.')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', Dec.')"/>                                        				
                                        				<xsl:text>-12-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'Dec. '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'Dec. ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>
                                        	</xsl:when>
                                            <xsl:otherwise>
                                                <date standardDate="{$vDateVal}">
                                                    <xsl:value-of select="$vDateVal" />
                                                </date>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <event>
                                            <xsl:choose>
                                                <xsl:when test="ead:eventgrp">
                                                    <xsl:for-each select="ead:eventgrp/ead:event">
                                                        <xsl:variable name="vStrLen" select="string-length(.)" />
                                                        <xsl:choose>
                                                            <xsl:when test="substring(.,$vStrLen)=' '">
                                                                <xsl:value-of select="normalize-space(.)" />
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="normalize-space(.)" />
                                                            	<xsl:if test="position()!=last()">
                                                                	<xsl:text> </xsl:text>
                                                            	</xsl:if>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="normalize-space(ead:event)" />
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
                                    <xsl:for-each select="following-sibling::ead:p[string-length()&lt;=10]">
                                        <xsl:variable name="vDateVal" select="normalize-space(.)" />
                                        <chronItem>
                                            <xsl:choose>
                                                <xsl:when test="contains($vDateVal,'-')">
                                                    <dateRange>
                                                        <fromDate standardDate="{substring-before($vDateVal,'-')}">
                                                            <xsl:value-of select="substring-before($vDateVal,'-')" />
                                                        </fromDate>
                                                        <toDate standardDate="{substring-after($vDateVal,'-')}">
                                                            <xsl:value-of select="substring-after($vDateVal,'-')" />
                                                        </toDate>
                                                    </dateRange>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <date standardDate="{$vDateVal}">
                                                        <xsl:value-of select="$vDateVal" />
                                                    </date>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <event>
                                                <xsl:for-each select="following-sibling::ead:p[string-length()&gt;10]">
                                                    <xsl:if test="preceding-sibling::ead:p[string-length()&lt;=10][1]=$vDateVal">
                                                        <xsl:value-of select="normalize-space(.)" />
                                                        <xsl:text />
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </event>
                                        </chronItem>
                                    </xsl:for-each>
                                </chronList>
                            </xsl:when>
                            <xsl:when test="contains(.,'Employment History')">
                                <p>
                                    <xsl:value-of select="normalize-space(.)" />
                                </p>
                                <chronList>
                                    <xsl:for-each select="following-sibling::ead:p[string-length(substring(.,1,4))!=string-length(translate(substring(.,1,4),$vDigits,''))]">
                                        <xsl:variable name="vDateVal" select="substring-before(normalize-space(.),':')" />
                                        <chronItem>
                                            <xsl:choose>
                                                <xsl:when test="contains($vDateVal,'-')">
                                                    <dateRange>
                                                        <fromDate standardDate="{substring-before($vDateVal,'-')}">
                                                            <xsl:value-of select="substring-before($vDateVal,'-')" />
                                                        </fromDate>
                                                        <toDate standardDate="{substring-after($vDateVal,'-')}">
                                                            <xsl:value-of select="substring-after($vDateVal,'-')" />
                                                        </toDate>
                                                    </dateRange>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <date standardDate="{$vDateVal}">
                                                        <xsl:value-of select="$vDateVal" />
                                                    </date>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <event>
                                                <xsl:value-of select="substring-after(.,': ')" />
                                            </event>
                                        </chronItem>
                                    </xsl:for-each>
                                </chronList>
                            </xsl:when>                            
                            <xsl:otherwise>                                
                                <xsl:if test="not(contains(.,'Chronolog'))                                      
                                    and not(contains(.,'Timeline'))                                      
                                    and not(contains(.,'Employment History'))">
                                    <xsl:if test="not(preceding-sibling::ead:p[contains(.,'Chronolog')])                                          
                                        and (string-length(substring(.,1,4)) = string-length(translate(substring(.,1,4),$vDigits,'')))">
                                        <xsl:if test=".!=' ' and .!=''">
                                            <xsl:apply-templates select="."/>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:if>                                
                            </xsl:otherwise>                            
                        </xsl:choose>                        
                    </xsl:for-each>
                    
                    <!--
                    <xsl:if test="ead:ead/ead:archdesc/ead:bioghist/text()">
                        <xsl:apply-templates select="ead:ead/ead:archdesc/ead:bioghist" />
                    </xsl:if>
                    -->
                    <!-- <xsl:apply-templates select="ead:ead/ead:archdesc/ead:bioghist/ead:p[not(contains(.,'Chronolog')) and not(contains(preceding-sibling::ead:p,'Chronolog')) and not(contains(.,'Employment History')) and not(contains(preceding-sibling::ead:p,'Employment History'))]" /> -->
                                                            
                    <xsl:call-template name="tCitations" />
                </biogHist>
            </xsl:if>
        </description>
    </xsl:template>
    <!-- Template for processing subjects. -->
    <xsl:template match="ead:ead/ead:archdesc//ead:controlaccess" name="tControlAccess">
        <!-- Store the results of Muenchian grouping inside a variable. -->
        <xsl:variable name="vSubjCheck">
            <xsl:for-each select="ead:ead/ead:archdesc//ead:controlaccess[count(. | key('kSubjCheck', child::node()[local-name()!='head'])[1]) = 1]">
                <xsl:for-each select="child::node()[local-name()!='head']">
                    <ead:name encodinganalog="{@encodinganalog}" type="{local-name()}">
                        <xsl:value-of select="." />
                    </ead:name>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <!-- Then do a second pass over the node set using the EXSL node-set function. -->
        <xsl:for-each select="exsl:node-set($vSubjCheck)/ead:name[not(.=preceding-sibling::ead:name)]">
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
                <xsl:when test="@type='persname' and .!=$vNameString">
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
        <xsl:if test="$vDates!=''">
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
    <!-- Template for matching any epithets in name strings and adding to <occupation> elements. -->
    <xsl:template name="tOccupations">
        <xsl:choose>
            <xsl:when test="substring-after($vNameString,$vDates)!=''">
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
    <!-- Recursive template to turn "\n\n" into <p> tags. Formerly used for processing biography from new record form. Now defunct. -->
    <xsl:template name="tLineSplitter">
        <xsl:param name="line" />
        <xsl:param name="element" />
        <xsl:param name="element2" />
        <xsl:choose>
            <xsl:when test="contains($line,'\n') and not(contains($line,'\n\n'))">
                <xsl:choose>
                    <xsl:when test="$element2!=''">
                        <xsl:element name="{$element}" namespace="urn:isbn:1-931666-33-4">
                            <xsl:element name="{$element2}" namespace="urn:isbn:1-931666-33-4">
                                <xsl:value-of select="normalize-space(substring-before($line,'\n'))" />
                            </xsl:element>
                        </xsl:element>
                        <xsl:call-template name="tLineSplitter">
                            <xsl:with-param name="line" select="substring-after($line,'\n')" />
                            <xsl:with-param name="element" select="$element" />
                            <xsl:with-param name="element2" select="$element2" />
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="contains($line,'\n\n')">
                <xsl:choose>
                    <xsl:when test="$element2!=''">
                        <xsl:element name="{$element}" namespace="urn:isbn:1-931666-33-4">
                            <xsl:element name="{$element2}" namespace="urn:isbn:1-931666-33-4">
                                <xsl:value-of select="normalize-space(substring-before($line,'\n\n'))" />
                            </xsl:element>
                        </xsl:element>
                        <xsl:call-template name="tLineSplitter">
                            <xsl:with-param name="line" select="substring-after($line,'\n\n')" />
                            <xsl:with-param name="element" select="$element" />
                            <xsl:with-param name="element2" select="$element2" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="{$element}" namespace="urn:isbn:1-931666-33-4">
                            <xsl:value-of select="normalize-space(substring-before($line,'\n\n'))" />
                        </xsl:element>
                        <xsl:call-template name="tLineSplitter">
                            <xsl:with-param name="line" select="normalize-space(substring-after($line,'\n\n'))" />
                            <xsl:with-param name="element" select="$element" />
                            <xsl:with-param name="element2" select="$element2" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$element2!=''">
                        <xsl:element name="{$element}" namespace="urn:isbn:1-931666-33-4">
                            <xsl:element name="{$element2}" namespace="urn:isbn:1-931666-33-4">
                                <xsl:value-of select="normalize-space($line)" />
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="{$element}" namespace="urn:isbn:1-931666-33-4">
                            <xsl:value-of select="normalize-space($line)" />
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>	
	<xsl:template name="tCreatorSplitter">
		<xsl:param name="pCreators" />		
		<xsl:choose>
			<xsl:when test="contains($pCreators,';')">
				<relationEntry localType="creator" xmlns="urn:isbn:1-931666-33-4">
					<xsl:value-of select="normalize-space(substring-before($pCreators,';'))" />
				</relationEntry>
				<xsl:call-template name="tCreatorSplitter">
					<xsl:with-param name="pCreators" select="normalize-space(substring-after($pCreators,';'))"/>
				</xsl:call-template>			
			</xsl:when>			
			<xsl:otherwise>
				<relationEntry localType="creator" xmlns="urn:isbn:1-931666-33-4">
					<xsl:value-of select="normalize-space($pCreators)" />
				</relationEntry>						
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
    <!-- Process mixed content elements. -->
    <xsl:template match="ead:abstract">
        <abstract xmlns="urn:isbn:1-931666-33-4">
            <xsl:value-of select="normalize-space(.)" />
        </abstract>
    </xsl:template>    
    <xsl:template match="ead:bioghist/text()">
        <p xmlns="urn:isbn:1-931666-33-4">
            <xsl:value-of select="normalize-space(.)" />
        </p>
    </xsl:template>    
    <xsl:template match="ead:emph">
        <span xmlns="urn:isbn:1-931666-33-4">
            <xsl:attribute name="style">font-style:italic</xsl:attribute>
            <xsl:value-of select="normalize-space(.)" />
        </span>
    </xsl:template>
    <xsl:template match="ead:item">
        <item xmlns="urn:isbn:1-931666-33-4">
            <xsl:value-of select="normalize-space(.)" />
        </item>
    </xsl:template>
    <xsl:template match="ead:p">
        <p xmlns="urn:isbn:1-931666-33-4">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="ead:title">
        <span xmlns="urn:isbn:1-931666-33-4">
            <xsl:attribute name="style">font-style:italic</xsl:attribute>
            <xsl:value-of select="normalize-space(.)" />
        </span>
    </xsl:template>
    <!-- Process relation elements. -->
    <xsl:template name="tRelations">
        <relations xmlns="urn:isbn:1-931666-33-4">
            <!-- Turn associated creators into cpfRelation elements. -->
            <xsl:variable name="vFirstNode" select="ead:ead/ead:archdesc/ead:did/ead:origination[not(contains(@id,'RAMP'))]/child::node()[1]" />
            <xsl:for-each select="$vFirstNode">
                <xsl:if test="following-sibling::node()[not(@encodinganalog='100_0') and not(@encodinganalog='100_1')]">
                    <xsl:for-each select="following-sibling::node()">
                        <xsl:variable name="vEntType" select="local-name(.)" />
                        <xsl:variable name="vCpfRel" select="@normal" />
                        <xsl:if test="$vEntType='persname'">
                            <cpfRelation cpfRelationType="associative" xlink:role="http://rdvocab.info/uri/schema/FRBRentitiesRDA/Person" xlink:type="simple">
                                <relationEntry>
                                    <xsl:value-of select="normalize-space(.)" />
                                </relationEntry>
                                <descriptiveNote>
                                    <p>
                                        <xsl:text>recordId:</xsl:text>
                                        <xsl:choose>
                                            <xsl:when test="contains(../../../../ead:eadheader/ead:eadid,'/')">
                                                <xsl:value-of select="substring-after(../../../../ead:eadheader/ead:eadid,'/')" />
                                                <xsl:text>.</xsl:text>
                                                <xsl:value-of select="substring-after(../../../../ead:eadheader/ead:eadid/@identifier,':')" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="../../../../ead:eadheader/ead:eadid" />
                                                <xsl:text>.</xsl:text>
                                                <xsl:value-of select="substring-after(../../../../ead:eadheader/ead:eadid/@identifier,':')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:for-each select="following-sibling::ead:name">
                                            <xsl:variable name="vCpfId" select="@id" />
                                            <xsl:if test=".=$vCpfRel">
                                                <xsl:value-of select="concat('.',@id)" />
                                            </xsl:if>
                                        </xsl:for-each>
                                    </p>
                                </descriptiveNote>
                            </cpfRelation>
                        </xsl:if>
                        <xsl:if test="$vEntType='corpname'">
                            <cpfRelation cpfRelationType="associative" xlink:role="http://rdvocab.info/uri/schema/FRBRentitiesRDA/CorporateBody" xlink:type="simple">
                                <relationEntry>
                                    <xsl:value-of select="normalize-space(.)" />
                                </relationEntry>
                                <!-- Assign record IDs based on ID from Archon. -->
                                <descriptiveNote>
                                    <p>
                                        <xsl:text>recordId:</xsl:text>
                                        <xsl:choose>
                                            <xsl:when test="contains(../../../../ead:eadheader/ead:eadid,'/')">
                                                <xsl:value-of select="substring-after(../../../../ead:eadheader/ead:eadid,'/')" />
                                                <xsl:text>.</xsl:text>
                                                <xsl:value-of select="substring-after(../../../../ead:eadheader/ead:eadid/@identifier,':')" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="../../../../ead:eadheader/ead:eadid" />
                                                <xsl:text>.</xsl:text>
                                                <xsl:value-of select="substring-after(../../../../ead:eadheader/ead:eadid/@identifier,':')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:for-each select="following-sibling::ead:name">
                                            <xsl:if test=".=$vCpfRel">
                                                <xsl:value-of select="concat('.',@id)" />
                                            </xsl:if>
                                        </xsl:for-each>
                                    </p>
                                </descriptiveNote>
                            </cpfRelation>
                        </xsl:if>
                        <xsl:if test="$vEntType='famname'">
                            <cpfRelation cpfRelationType="associative" xlink:role="http://rdvocab.info/uri/schema/FRBRentitiesRDA/Family" xlink:type="simple">
                                <relationEntry>
                                    <xsl:value-of select="normalize-space(.)" />
                                </relationEntry>
                                <descriptiveNote>
                                    <p>
                                        <xsl:text>recordId:</xsl:text>
                                        <xsl:choose>
                                            <xsl:when test="contains(../../../../ead:eadheader/ead:eadid,'/')">
                                                <xsl:value-of select="substring-after(../../../../ead:eadheader/ead:eadid,'/')" />
                                                <xsl:text>.</xsl:text>
                                                <xsl:value-of select="substring-after(../../../../ead:eadheader/ead:eadid/@identifier,':')" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="../../../../ead:eadheader/ead:eadid" />
                                                <xsl:text>.</xsl:text>
                                                <xsl:value-of select="substring-after(../../../../ead:eadheader/ead:eadid/@identifier,':')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:for-each select="following-sibling::ead:name">
                                            <xsl:if test=".=$vCpfRel">
                                                <xsl:value-of select="concat('.',@id)" />
                                            </xsl:if>
                                        </xsl:for-each>
                                    </p>
                                </descriptiveNote>
                            </cpfRelation>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="exsl:node-set($vCpfName)/persName[not(.=preceding-sibling::persName)][not(.=$vFirstNode)]">                
                <cpfRelation cpfRelationType="associative" xlink:role="http://rdvocab.info/uri/schema/FRBRentitiesRDA/Person" xlink:type="simple">
                    <relationEntry>                        
                        <xsl:value-of select="normalize-space(.)" />
                    </relationEntry>
                </cpfRelation>
            </xsl:for-each>
            <xsl:for-each select="exsl:node-set($vCpfName)/corpName[not(.=preceding-sibling::corpName)][not(contains(.,'Cuban Heritage')) and not(contains(.,'Special Collections'))]">                
                <cpfRelation cpfRelationType="associative" xlink:role="http://rdvocab.info/uri/schema/FRBRentitiesRDA/CorporateBody" xlink:type="simple">
                    <relationEntry>                        
                        <xsl:value-of select="normalize-space(.)" />
                    </relationEntry>
                </cpfRelation>
            </xsl:for-each>
            <xsl:call-template name="tCpfs" />
            <!-- For local archival collections, output EAD snippet in objectXMLWrap. -->
            <xsl:for-each select="ead:ead/ead:archdesc/ead:did/ead:unittitle[.!='']">
                <resourceRelation resourceRelationType="creatorOf" xlink:href="{concat($pLocalURL,substring-after(../../../ead:eadheader/ead:eadid/@identifier,':'))}" xlink:role="archivalRecords" xlink:type="simple">
                    <relationEntry>
                        <!-- Process inclusive and bulk dates. -->
                        <xsl:value-of select="normalize-space(text())" />
                        <xsl:if test="child::ead:unitdate">
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="normalize-space(ead:unitdate)" />
                        </xsl:if>
                    </relationEntry>
                    <objectXMLWrap>
                        <archdesc xmlns="urn:isbn:1-931666-22-9">
                            <xsl:if test="../../../ead:archdesc/@level">
                                <xsl:attribute name="level">
                                    <xsl:value-of select="../../../ead:archdesc/@level"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="../../../ead:archdesc/@type">
                                <xsl:attribute name="type">
                                    <xsl:value-of select="../../../ead:archdesc/@type"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="../../../ead:archdesc/@audience">
                                <xsl:attribute name="audience">
                                    <xsl:value-of select="../../../ead:archdesc/@audience"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="../../../ead:archdesc/@relatedencoding">
                                <xsl:attribute name="relatedencoding">
                                    <xsl:value-of select="../../../ead:archdesc/@relatedencoding"/>
                                </xsl:attribute>
                            </xsl:if>                     
                            <did>
                                <xsl:copy-of select="parent::ead:did/ead:head" />
                                <xsl:copy-of select="." />
                                <xsl:copy-of select="parent::ead:did/ead:unitid" />
                                <xsl:element name="origination" namespace="urn:isbn:1-931666-22-9">
                                    <xsl:attribute name="label">
                                        <xsl:value-of select="parent::ead:did/ead:origination/@label" />
                                    </xsl:attribute>
                                    <xsl:attribute name="encodinganalog">
                                        <xsl:value-of select="parent::ead:did/ead:origination/@encodinganalog" />
                                    </xsl:attribute>
                                    <xsl:for-each select="parent::ead:did/ead:origination/child::node()[not(local-name()='name')]">
                                        <xsl:copy-of select="." />
                                    </xsl:for-each>
                                </xsl:element>
                                <xsl:for-each select="parent::ead:did/ead:origination/following-sibling::node()">
                                    <xsl:copy-of select="." />
                                </xsl:for-each>
                            </did>
                            <!-- Include Scope and Contents. -->
                            <xsl:if test="../../ead:scopecontent">
                                <xsl:if test=". != ' ' ">
                                    <xsl:copy-of select="../../ead:scopecontent" />
                                </xsl:if>
                            </xsl:if>
                        </archdesc>
                    </objectXMLWrap>
                </resourceRelation>
            </xsl:for-each>
            <!-- Process local digital collections. -->
            <xsl:if test="ead:ead/ead:archdesc/ead:dao">
                <xsl:for-each select="ead:ead/ead:archdesc/ead:dao">
                    <resourceRelation resourceRelationType="creatorOf" xlink:href="{@xlink:href}" xlink:role="archivalRecords" xlink:type="simple">
                        <relationEntry>
                            <xsl:value-of select="normalize-space(ead:daodesc/ead:p)" />                                                        
                        </relationEntry>
                    </resourceRelation>
                </xsl:for-each>
            </xsl:if>
            <xsl:call-template name="tResources" />
            <!-- The following represents different attempts to account for variations in local formatting / data entry for relatedmaterial elements. -->
            <!-- Code will need to be adapted to local markup. -->
            <xsl:if test="ead:ead/ead:archdesc/ead:descgrp/ead:relatedmaterial">
                <xsl:for-each select="ead:ead/ead:archdesc/ead:descgrp/ead:relatedmaterial/ead:p/ead:extref">
                    <xsl:choose>
                        <xsl:when test="contains(@href,$pServerName)">
                            <resourceRelation xlink:href="{@href}" xlink:role="archivalRecords" xlink:type="simple">
                                <relationEntry>
                                    <xsl:value-of select="normalize-space(.)" />
                                </relationEntry>
                            </resourceRelation>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="not(contains(@href,$pServerName))">
                                <resourceRelation xlink:href="{@href}" xlink:role="resource" xlink:type="simple">
                                    <relationEntry>
                                        <xsl:value-of select="normalize-space(.)" />
                                    </relationEntry>
                                </resourceRelation>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <!-- Working to parse relatedmaterial elements. For now, if it's not an <extref>, just output the contents in a simple <resourceRelation>. -->
                <xsl:for-each select="ead:ead/ead:archdesc/ead:descgrp/ead:relatedmaterial/ead:p[not(ead:extref)]">
                    <xsl:variable name="vRelatedCollection" select="translate(normalize-space(.),$vUpper,$vLower)" />
                    <xsl:if test="not(substring(.,string-length(.))=':')">
                        <resourceRelation>
                            <xsl:if test="contains($vRelatedCollection,'http:')">
                                <xsl:attribute name="xlink:href">
                                    <xsl:value-of select="concat('http:',substring-after(.,'http:'))" />
                                </xsl:attribute>
                                <xsl:attribute name="xlink:type">
                                    <xsl:value-of select="'simple'" />
                                </xsl:attribute>
                            </xsl:if>                            
                            <relationEntry>
                                <xsl:value-of select="." />
                            </relationEntry>
                        </resourceRelation>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </relations>
    </xsl:template>
    <!-- Template for parsing dates. -->
    <xsl:template name="tExistDates">
        <xsl:param name="pName" />
        <xsl:choose>
            <!-- If the first nameEntry contains a four-digit number (we assume a date)... -->
            <xsl:when test="string-length(translate($pName,concat($vAlpha,$vCommaSpace,$vApos),''))&gt;=4">
                <xsl:element name="existDates" namespace="urn:isbn:1-931666-33-4">
                    <xsl:element name="dateRange" namespace="urn:isbn:1-931666-33-4">
                        <!-- Output the birth year, if exists. -->
                        <xsl:choose>
                            <xsl:when test="substring-before($pName,'-')!=''">
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
                            <xsl:when test="substring-after($pName,'-')!=''">
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
            <xsl:when test="ead:ead/ead:archdesc/ead:did/ead:note[@type='from']/ead:p!=''">
                <existDates xmlns="urn:isbn:1-931666-33-4">
                    <dateRange>
                        <xsl:choose>
                            <xsl:when test="ead:ead/ead:archdesc/ead:did/ead:note[@type='standardFrom']/ead:p!=''">
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
                        <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:note[@type='to']/ead:p!=''">
                            <xsl:choose>
                                <xsl:when test="ead:ead/ead:archdesc/ead:did/ead:note[@type='standardTo']/ead:p!=''">
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
                <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:note[@type='to']/ead:p!=''">
                    <existDates xmlns="urn:isbn:1-931666-33-4">
                        <dateRange>
                            <xsl:choose>
                                <xsl:when test="ead:ead/ead:archdesc/ead:did/ead:note[@type='standardTo']/ead:p!=''">
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
    <xsl:template name="tGenders">
        <xsl:if test="$vGender!=''">
            <xsl:for-each select="$vGender[.!='']">
                <xsl:variable name="vGenderLabel" select="../@label" />
                <localDescription xmlns="urn:isbn:1-931666-33-4" localType="gender">
                    <term>
                        <xsl:value-of select="normalize-space(.)" />
                    </term>
                    <xsl:if test="../following-sibling::ead:note[@type='genderDateFrom']/ead:p!=''">
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
        <xsl:if test="$vLangName!=''">
            <xsl:for-each select="$vLangName[.!='']">
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
    <xsl:template name="tSubjects">
        <xsl:if test="$vSubject!=''">
            <xsl:for-each select="$vSubject[.!='']">
                <localDescription xmlns="urn:isbn:1-931666-33-4" localType="subject">
                    <term>
                        <xsl:value-of select="normalize-space(.)" />
                    </term>
                </localDescription>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template name="tGenres">
        <xsl:if test="$vGenre!=''">
            <xsl:for-each select="$vGenre[.!='']">
                <localDescription xmlns="urn:isbn:1-931666-33-4" localType="genre">
                    <term>
                        <xsl:value-of select="normalize-space(.)" />
                    </term>
                </localDescription>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template name="tOccupationsNew">
        <xsl:if test="$vOccupationNew!=''">
            <xsl:for-each select="$vOccupationNew[.!='']">
                <xsl:variable name="vOccuLabel" select="../@label" />
                <occupation xmlns="urn:isbn:1-931666-33-4">
                    <term>
                        <xsl:value-of select="normalize-space(.)" />
                    </term>
                    <xsl:choose>
                        <xsl:when test="../following-sibling::ead:note[@type='occuDateFrom']/ead:p!=''">
                            <dateRange>
                                <xsl:if test="../following-sibling::ead:note[@type='occuDateFrom'][@label=$vOccuLabel]">
                                    <xsl:choose>
                                        <xsl:when test="../following-sibling::ead:note[@type='occuStandardFrom'][@label=$vOccuLabel]/ead:p!=''">
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
                                <xsl:if test="../following-sibling::ead:note[@type='occuDateTo'][@label=$vOccuLabel]!=''">
                                    <xsl:choose>
                                        <xsl:when test="../following-sibling::ead:note[@type='occuStandardTo'][@label=$vOccuLabel]/ead:p!=''">
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
                            <xsl:if test="../following-sibling::ead:note[@type='occuDateTo'][@label=$vOccuLabel]!=''">
                                <dateRange>
                                    <xsl:choose>
                                        <xsl:when test="../following-sibling::ead:note[@type='occuStandardTo'][@label=$vOccuLabel]/ead:p!=''">
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
    <xsl:template name="tPlaces">
        <xsl:if test="$vPlaceRole!=''">
            <xsl:for-each select="$vPlaceRole[.!='']">
                <xsl:variable name="vPlaceRoleLabel" select="../@label" />
                <place xmlns="urn:isbn:1-931666-33-4">
                    <placeRole>
                        <xsl:value-of select="normalize-space(.)" />
                    </placeRole>
                    <xsl:if test="../following-sibling::ead:note[@type='placeEntry']/ead:p!=''">
                        <placeEntry>
                            <xsl:if test="../following-sibling::ead:note[@type='placeEntry'][@label=$vPlaceRoleLabel]">
                                <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='placeEntry'][@label=$vPlaceRoleLabel]/ead:p)" />
                            </xsl:if>
                        </placeEntry>
                        <xsl:choose>
                            <xsl:when test="../following-sibling::ead:note[@type='placeDateFrom']/ead:p!=''">
                                <dateRange>
                                    <xsl:if test="../following-sibling::ead:note[@type='placeDateFrom'][@label=$vPlaceRoleLabel]">
                                        <xsl:choose>
                                            <xsl:when test="../following-sibling::ead:note[@type='placeStandardFrom'][@label=$vPlaceRoleLabel]/ead:p!=''">
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
                                    <xsl:if test="../following-sibling::ead:note[@type='placeDateTo'][@label=$vPlaceRoleLabel]/ead:p!=''">
                                        <xsl:choose>
                                            <xsl:when test="../following-sibling::ead:note[@type='placeStandardTo'][@label=$vPlaceRoleLabel]/ead:p!=''">
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
                                <xsl:if test="../following-sibling::ead:note[@type='placeDateTo'][@label=$vPlaceRoleLabel]/ead:p!=''">
                                    <dateRange>
                                        <xsl:choose>
                                            <xsl:when test="../following-sibling::ead:note[@type='placeStandardTo'][@label=$vPlaceRoleLabel]/ead:p!=''">
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
    <xsl:template name="tCitations">
        <xsl:if test="$vCitation!=''">
            <xsl:for-each select="$vCitation[.!='']">
                <citation xmlns="urn:isbn:1-931666-33-4">
                    <xsl:value-of select="normalize-space(.)" />
                </citation>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template name="tCpfs">
        <xsl:if test="$vCpf!=''">
            <xsl:for-each select="$vCpf[.!='']">
                <xsl:variable name="vCpfLabel" select="../@label" />            	
            		<cpfRelation xmlns="urn:isbn:1-931666-33-4">            		
            			<xsl:if test="../following-sibling::ead:note[@type='cpfType'][@label=$vCpfLabel]/ead:p!=''">
            				<xsl:attribute name="cpfRelationType">
            					<xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='cpfType'][@label=$vCpfLabel]/ead:p)"/>
            				</xsl:attribute>
            			</xsl:if>
            			<xsl:if test="../following-sibling::ead:note[@type='cpfID'][@label=$vCpfLabel]/ead:p!=''">
            				<xsl:attribute name="xml:id">
            					<xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='cpfID'][@label=$vCpfLabel]/ead:p)"/>
            				</xsl:attribute>
            			</xsl:if>
            			<xsl:if test="../following-sibling::ead:note[@type='cpfURI'][@label=$vCpfLabel]/ead:p!=''">
            				<xsl:attribute name="xlink:href">
            					<xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='cpfURI'][@label=$vCpfLabel]/ead:p)"/>
            				</xsl:attribute>
            			</xsl:if>
            			<xsl:if test="../following-sibling::ead:note[@type='cpfRole'][@label=$vCpfLabel]/ead:p!=''">
            				<xsl:attribute name="xlink:role">
            					<xsl:value-of select="concat('http://rdvocab.info/uri/schema/FRBRentitiesRDA/',normalize-space(../following-sibling::ead:note[@type='cpfRole'][@label=$vCpfLabel]/ead:p))"/>
            				</xsl:attribute>
            			</xsl:if>            				            				            			
            			<xsl:attribute name="xlink:type">
            				<xsl:value-of select="'simple'"/>
            			</xsl:attribute>            			            			            		
            			<relationEntry>
            				<xsl:value-of select="normalize-space(.)" />
            			</relationEntry>
            			<xsl:if test="../following-sibling::ead:note[@type='cpfNote'][@label=$vCpfLabel]/ead:p!=''">
            				<descriptiveNote>
            					<p>
            						<xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='cpfNote'][@label=$vCpfLabel]/ead:p)" />
            					</p>
            				</descriptiveNote>
            			</xsl:if>
            		</cpfRelation>            	
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template name="tResources">
        <xsl:if test="$vResource!=''">
            <xsl:for-each select="$vResource[.!='']">
                <xsl:variable name="vResourceLabel" select="../@label" />            	
            	<xsl:choose>
            		<xsl:when test="normalize-space(../following-sibling::ead:note[@type='resourceCreator'][@label=$vResourceLabel]/ead:p)!=''">
            			<resourceRelation xmlns="urn:isbn:1-931666-33-4">            				
            				<xsl:if test="../following-sibling::ead:note[@type='resourceType'][@label=$vResourceLabel]/ead:p!=''">
            					<xsl:attribute name="resourceRelationType">
            						<xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='resourceType'][@label=$vResourceLabel]/ead:p)"/>
            					</xsl:attribute>		
            				</xsl:if>
            				<xsl:if test="../following-sibling::ead:note[@type='resourceID'][@label=$vResourceLabel]/ead:p!=''">
            					<xsl:attribute name="xml:id">
            						<xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='resourceID'][@label=$vResourceLabel]/ead:p)"/>
            					</xsl:attribute>		
            				</xsl:if>
            				<xsl:if test="../following-sibling::ead:note[@type='resourceURI'][@label=$vResourceLabel]/ead:p!=''">
            					<xsl:attribute name="xlink:href">
            						<xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='resourceURI'][@label=$vResourceLabel]/ead:p)"/>
            					</xsl:attribute>
            				</xsl:if>
            				<xsl:if test="../following-sibling::ead:note[@type='resourceRole'][@label=$vResourceLabel]/ead:p!=''">
            					<xsl:attribute name="xlink:role">
            						<xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='resourceRole'][@label=$vResourceLabel]/ead:p)"/>
            					</xsl:attribute>		
            				</xsl:if>            					            				
            				<xsl:attribute name="xlink:type">
            					<xsl:value-of select="'simple'"/>
            				</xsl:attribute>
            				<relationEntry localType="title">
            					<xsl:value-of select="normalize-space(.)" />
            				</relationEntry>
            				<xsl:call-template name="tCreatorSplitter">
            					<xsl:with-param name="pCreators" select="../following-sibling::ead:note[@type='resourceCreator'][@label=$vResourceLabel]/ead:p"></xsl:with-param>
            				</xsl:call-template>                                                                                                                        
            				<xsl:if test="../following-sibling::ead:note[@type='resourceNote'][@label=$vResourceLabel]/ead:p!=''">
            					<descriptiveNote>
            						<p>
            							<xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='resourceNote'][@label=$vResourceLabel]/ead:p)" />
            						</p>
            					</descriptiveNote>
            				</xsl:if>
            			</resourceRelation>
            		</xsl:when>
            		<xsl:otherwise>
            			<resourceRelation xmlns="urn:isbn:1-931666-33-4">            				
            				<xsl:if test="../following-sibling::ead:note[@type='resourceType'][@label=$vResourceLabel]/ead:p!=''">
            					<xsl:attribute name="resourceRelationType">
            						<xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='resourceType'][@label=$vResourceLabel]/ead:p)"/>
            					</xsl:attribute>		
            				</xsl:if>
            				<xsl:if test="../following-sibling::ead:note[@type='resourceID'][@label=$vResourceLabel]/ead:p!=''">
            					<xsl:attribute name="xml:id">
            						<xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='resourceID'][@label=$vResourceLabel]/ead:p)"/>
            					</xsl:attribute>		
            				</xsl:if>
            				<xsl:if test="../following-sibling::ead:note[@type='resourceURI'][@label=$vResourceLabel]/ead:p!=''">
            					<xsl:attribute name="xlink:href">
            						<xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='resourceURI'][@label=$vResourceLabel]/ead:p)"/>
            					</xsl:attribute>
            				</xsl:if>
            				<xsl:if test="../following-sibling::ead:note[@type='resourceRole'][@label=$vResourceLabel]/ead:p!=''">
            					<xsl:attribute name="xlink:role">
            						<xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='resourceRole'][@label=$vResourceLabel]/ead:p)"/>
            					</xsl:attribute>		
            				</xsl:if>            					            				
            				<xsl:attribute name="xlink:type">
            					<xsl:value-of select="'simple'"/>
            				</xsl:attribute>
            				<relationEntry localType="title">
            					<xsl:value-of select="normalize-space(.)" />
            				</relationEntry>
            				<xsl:if test="../following-sibling::ead:note[@type='resourceType'][@label=$vResourceLabel]/ead:p='creatorOf'">
            					<xsl:choose>
            						<xsl:when test="//ead:origination/child::node()[2][@encodinganalog='100_1']!=''">
            							<relationEntry localType="creator">
            								<xsl:value-of select="normalize-space(//ead:origination/child::node()[2][@encodinganalog='100_1'])" />
            								<xsl:if test="//ead:origination/child::node()[3][@encodinganalog='100_0']!=''">
            									<xsl:text>, </xsl:text>
            									<xsl:value-of select="normalize-space(//ead:origination/child::node()[3][@encodinganalog='100_0'])" />
            								</xsl:if>
            							</relationEntry>
            						</xsl:when>
            						<xsl:otherwise>
            							<xsl:choose>
            								<xsl:when test="//ead:origination/child::node()[3][@encodinganalog='100_0']!=''">
            									<xsl:value-of select="normalize-space(//ead:origination/child::node()[3][@encodinganalog='100_0'])" />
            								</xsl:when>
            								<xsl:otherwise>
            									<relationEntry localType="creator">
            										<xsl:value-of select="normalize-space(//ead:origination/child::node()[1])" />
            									</relationEntry>
            								</xsl:otherwise>
            							</xsl:choose>
            						</xsl:otherwise>
            					</xsl:choose>
            				</xsl:if>
            				<xsl:if test="../following-sibling::ead:note[@type='resourceNote'][@label=$vResourceLabel]/ead:p!=''">
            					<descriptiveNote>
            						<p>
            							<xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='resourceNote'][@label=$vResourceLabel]/ead:p)" />
            						</p>
            					</descriptiveNote>
            				</xsl:if>
            			</resourceRelation>
            		</xsl:otherwise>
            	</xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template name="tSourcesNew">
        <xsl:if test="$vSource!=''">
            <xsl:for-each select="$vSource[.!='']">
                <source xmlns="urn:isbn:1-931666-33-4">
                    <sourceEntry>
                        <xsl:value-of select="normalize-space(.)" />
                    </sourceEntry>
                </source>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template name="tScript">
        <xsl:param name="vLangNameLabel" />
        <xsl:if test="$vScriptName!=''">
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