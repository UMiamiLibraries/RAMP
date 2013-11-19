<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eac="urn:isbn:1-931666-33-4" xmlns:ead="urn:isbn:1-931666-22-9" xmlns:exsl="http://exslt.org/common" xmlns:xlink="http://www.w3.org/1999/xlink" extension-element-prefixes="exsl" exclude-result-prefixes="eac" version="1.0">
    <!--
        Author: Timothy A. Thompson
        University of Miami Libraries
        Copyright 2013 University of Miami. Licensed under the Educational Community License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://opensource.org/licenses/ECL-2.0 http://www.osedu.org/licenses/ECL-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
    -->
    <!--
        eac2wiki.xsl creates wiki markup from EAC-CPF/XML. 
    -->
    <!-- Import additional params. -->
    <xsl:import href="eac2wikiParams.xsl" />
    <xsl:output method="text" indent="yes" encoding="UTF-8" />
    <xsl:template match="/">
        <!-- Check to see if we are creating a person or corporate body record. -->
        <xsl:choose>
            <xsl:when test="eac:eac-cpf/eac:cpfDescription/eac:identity/eac:entityType[text()='person']">
                <xsl:call-template name="tPerson" />
            </xsl:when>
            <!-- Records for families are not supported at this time. -->
            <xsl:when test="/eac:eac-cpf/eac:cpfDescription/eac:identity/eac:entityType[text()='family']">
                <xsl:text>Conversion to wiki markup is not currently available for family records. Please choose a person or corporate body record for wiki editing.</xsl:text>
            </xsl:when>
            <xsl:when test="eac:eac-cpf/eac:cpfDescription/eac:identity/eac:entityType[text()='corporateBody']">
                <xsl:call-template name="tCorporateBody" />
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <!-- Call templates for persons. -->
    <xsl:template name="tPerson">
        <!-- Infobox -->
        <xsl:call-template name="tPersonInfobox" />
        <!-- Lede -->
        <xsl:text />
        <xsl:text>'''</xsl:text>
        <xsl:call-template name="tParseName2">
            <xsl:with-param name="pNameType">person</xsl:with-param>
            <xsl:with-param name="pPersName" select="$pPersName" />
            <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
            <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
        </xsl:call-template>
        <xsl:text>''' ...</xsl:text>
        <xsl:text />
        <!-- Biography -->
        <xsl:text />
        <xsl:text>==Biography==</xsl:text>
        <xsl:text />
        <xsl:if test="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation/eac:objectXMLWrap/ead:archdesc/ead:scopecontent or $pBiogHist/eac:abstract">
            <xsl:text>&lt;!-- The following info about the collection that may contain relevant historical details and that may be useful for providing a brief description of the "External link" to the finding aid from Wikipedia. This text should be deleted after relevant information has been incorporated into the Wikipedia entry: --&gt;</xsl:text>
            <xsl:text />
            <xsl:text />
        </xsl:if>
        <xsl:if test="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation/eac:objectXMLWrap/ead:archdesc/ead:scopecontent">
            <xsl:text />
            <xsl:text>&lt;!--</xsl:text>
            <xsl:for-each select="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation/eac:objectXMLWrap/ead:archdesc/ead:scopecontent/ead:p">
                <xsl:value-of select="normalize-space(.)" />
                <xsl:choose>
                    <xsl:when test="position()!=last()">
                        <xsl:text />
                        <xsl:text />
                    </xsl:when>
                    <xsl:otherwise />
                </xsl:choose>
            </xsl:for-each>
            <xsl:text>--&gt;</xsl:text>
            <xsl:text />
        </xsl:if>
        <xsl:if test="$pBiogHist/eac:abstract">
            <xsl:text>&lt;!--</xsl:text>
            <xsl:value-of select="normalize-space($pBiogHist/eac:abstract)" />
            <xsl:text>--&gt;</xsl:text>
            <xsl:text />
            <xsl:text />
            <xsl:choose>
                <xsl:when test="following-sibling::eac:p">
                    <xsl:text />
                </xsl:when>
                <xsl:otherwise />
            </xsl:choose>
        </xsl:if>
        <xsl:for-each select="$pBiogHist/eac:p">
            <xsl:value-of select="normalize-space(.)" />
            <xsl:if test="following-sibling::*[1][self::eac:list]">
                <xsl:text />
                <xsl:text />
                <xsl:for-each select="following-sibling::*[1][self::eac:list]/eac:item">
                    <xsl:value-of select="normalize-space(.)" />
                    <xsl:choose>
                        <xsl:when test="position()!=last()">
                            <xsl:text />
                            <xsl:text />
                        </xsl:when>
                        <xsl:otherwise />
                    </xsl:choose>
                </xsl:for-each>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="position()!=last()">
                    <xsl:text />
                    <xsl:text />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <!-- Timeline -->
        <xsl:if test="$pBiogHist/eac:chronList/eac:chronItem">
            <xsl:call-template name="tTimeline" />
        </xsl:if>
        <!-- Publications -->
        <xsl:call-template name="tPub" />
        <!-- Relations -->
        <xsl:if test="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:cpfRelation | eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType='subject'] | eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType[contains(.,'7')]] | eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType[contains(.,'610')]]">
            <xsl:call-template name="tRelations">
                <xsl:with-param name="pNameType">person</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <!-- References -->
        <xsl:call-template name="tReferences" />
        <!-- Further reading -->
        <xsl:call-template name="tFurther" />
        <!-- External links -->
        <xsl:call-template name="tExternalLinks" />
        <!-- VIAF -->
        <xsl:call-template name="tVIAF" />
        <!-- Persondata -->
        <xsl:call-template name="tPersonData" />
        <!-- Categories -->
        <xsl:call-template name="tCategories">
            <xsl:with-param name="pNameType">person</xsl:with-param>
            <xsl:with-param name="pPersName" select="$pPersName" />
            <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
            <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
            <xsl:with-param name="pBiogHist" select="$pBiogHist" />
        </xsl:call-template>
    </xsl:template>
    <!-- Call templates for corporate bodies. -->
    <xsl:template name="tCorporateBody">
        <!-- Infobox -->
        <xsl:call-template name="tCBodyInfobox" />
        <!-- Lede -->
        <xsl:text />
        <xsl:text>'''</xsl:text>
        <xsl:call-template name="tParseName2">
            <xsl:with-param name="pNameType">corporate</xsl:with-param>
            <xsl:with-param name="pCorpName" select="$pCorpName" />
        </xsl:call-template>
        <xsl:text>''' ...</xsl:text>
        <xsl:text />
        <!-- History -->
        <xsl:text />
        <xsl:text>==History==</xsl:text>
        <xsl:text />
        <xsl:if test="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation/eac:objectXMLWrap/ead:archdesc/ead:scopecontent or $pBiogHist/eac:abstract">
            <xsl:text>&lt;!-- The following info about the collection that may contain relevant historical details and that may be useful for providing a brief description of the "External link" to the finding aid from Wikipedia. This text should be deleted after relevant information has been incorporated into the Wikipedia entry: --&gt;</xsl:text>
            <xsl:text />
            <xsl:text />
        </xsl:if>
        <xsl:if test="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation/eac:objectXMLWrap/ead:archdesc/ead:scopecontent">
            <xsl:text />
            <xsl:text>&lt;!--</xsl:text>
            <xsl:for-each select="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation/eac:objectXMLWrap/ead:archdesc/ead:scopecontent/ead:p">
                <xsl:value-of select="normalize-space(.)" />
                <xsl:choose>
                    <xsl:when test="position()!=last()">
                        <xsl:text />
                        <xsl:text />
                    </xsl:when>
                    <xsl:otherwise />
                </xsl:choose>
            </xsl:for-each>
            <xsl:text>--&gt;</xsl:text>
            <xsl:text />
        </xsl:if>
        <xsl:if test="$pBiogHist/eac:abstract">
            <xsl:text>&lt;!--</xsl:text>
            <xsl:value-of select="normalize-space($pBiogHist/eac:abstract)" />
            <xsl:text>--&gt;</xsl:text>
            <xsl:text />
            <xsl:text />
            <xsl:choose>
                <xsl:when test="following-sibling::eac:p">
                    <xsl:text />
                </xsl:when>
                <xsl:otherwise />
            </xsl:choose>
        </xsl:if>
        <xsl:for-each select="$pBiogHist/eac:p[.!='']">
            <xsl:value-of select="normalize-space(.)" />
            <xsl:if test="following-sibling::*[1][self::eac:list]">
                <xsl:text />
                <xsl:text />
                <xsl:for-each select="following-sibling::*[1][self::eac:list]/eac:item">
                    <xsl:value-of select="normalize-space(.)" />
                    <xsl:choose>
                        <xsl:when test="position()!=last()">
                            <xsl:text />
                            <xsl:text />
                        </xsl:when>
                        <xsl:otherwise />
                    </xsl:choose>
                </xsl:for-each>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="position()!=last()">
                    <xsl:text />
                    <xsl:text />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:if test="$pBiogHist/eac:chronList/eac:chronItem">
            <xsl:call-template name="tTimeline" />
        </xsl:if>
        <!-- Corporate Structure -->
        <xsl:if test="eac:eac-cpf/eac:cpfDescription/eac:description/eac:structureOrGenealogy">
            <xsl:for-each select="eac:eac-cpf/eac:cpfDescription/eac:description/eac:structureOrGenealogy/eac:p">
                <p>
                    <xsl:value-of select="." />
                </p>
            </xsl:for-each>
        </xsl:if>
        <!-- Publications -->
        <xsl:call-template name="tPub" />
        <!-- Relations -->
        <xsl:if test="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:cpfRelation | eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType='subject'] | eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType[contains(.,'7')]] | eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType[contains(.,'610')]]">
            <xsl:call-template name="tRelations">
                <xsl:with-param name="pNameType">corporate</xsl:with-param>
                <xsl:with-param name="pCorpName" select="$pCorpName" />
            </xsl:call-template>
        </xsl:if>
        <!-- References -->
        <xsl:call-template name="tReferences" />
        <!-- Further reading -->
        <xsl:call-template name="tFurther" />
        <!-- External links -->
        <xsl:call-template name="tExternalLinks" />
        <!-- VIAF -->
        <xsl:call-template name="tVIAF" />
        <!-- Categories -->
        <xsl:call-template name="tCategories">
            <xsl:with-param name="pNameType">corporate</xsl:with-param>
            <xsl:with-param name="pCorpName" select="$pCorpName" />
            <xsl:with-param name="pBiogHist" select="$pBiogHist" />
        </xsl:call-template>
    </xsl:template>
    <!-- Output Infobox for persons. -->
    <xsl:template name="tPersonInfobox">
        <xsl:param name="pPersName" select="$pPersName" />
        <xsl:param name="pPersNameSur" select="$pPersNameSur" />
        <xsl:param name="pPersNameFore" select="$pPersNameFore" />
        <xsl:text>{{Infobox person</xsl:text>
        <xsl:text />
        <xsl:text>&lt;!-- See http://en.wikipedia.org/wiki/Template:Infobox_person for complete template --&gt;</xsl:text>
        <xsl:text />
        <xsl:text>| name</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:call-template name="tParseName">
            <xsl:with-param name="pNameType">person</xsl:with-param>
            <xsl:with-param name="pPersName" select="$pPersName" />
            <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
            <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
        </xsl:call-template>
        <xsl:text>| nationality</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text />
        <xsl:text>| other_names</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text />
        <xsl:text>| ethnicity</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text>&lt;!-- Ethnicity should be supported with a citation from a reliable source --&gt;</xsl:text>
        <xsl:text />
        <xsl:text>| citizenship</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text />
        <xsl:text>| education</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text />
        <xsl:text>| alma_mater</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text />
        <xsl:text>| occupation</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:choose>
            <xsl:when test="/eac:eac-cpf/eac:cpfDescription/eac:description/eac:occupation/eac:term != '' or /eac:eac-cpf/eac:cpfDescription/eac:description/eac:occupations/eac:occupation/eac:term != ''">
                <xsl:for-each select="/eac:eac-cpf/eac:cpfDescription/eac:description/eac:occupation|/eac:eac-cpf/eac:cpfDescription/eac:description/eac:occupations/eac:occupation">
                    <xsl:variable name="vOccupationLen" select="string-length(eac:term)" />
                    <xsl:variable name="vOccupation-1" select="substring(eac:term,$vOccupationLen,$vOccupationLen)" />
                    <xsl:choose>
                        <xsl:when test="position()!=last()">
                            <xsl:choose>
                                <xsl:when test="$vOccupation-1='.'">
                                    <xsl:value-of select="normalize-space(eac:term)" />
                                    <xsl:text />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(eac:term)" />
                                    <xsl:text>;</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(eac:term)" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:text />
            </xsl:when>
            <xsl:otherwise>
                <xsl:text />
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>| known_for</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text />
        <xsl:text>| notable_works</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text />
        <xsl:text>| religion</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text>&lt;!-- Religion should be supported with a citation from a reliable source --&gt;</xsl:text>
        <xsl:text />
        <xsl:text>| spouse</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text />
        <xsl:text>| partner</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text>&lt;!-- Unmarried life partner; use ''Name (1950–present)'' --&gt;</xsl:text>
        <xsl:text />
        <xsl:text>| children</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text />
        <xsl:text>| parents</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text>&lt;!-- Use &lt;br /&gt; to separate names --&gt;</xsl:text>
        <xsl:text />
        <xsl:text>| relatives</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text />
        <xsl:text>}}</xsl:text>
        <xsl:text />
    </xsl:template>
    <!-- Output Infobox for corporate bodies. -->
    <xsl:template name="tCBodyInfobox">
        <xsl:text>{{Infobox organization</xsl:text>
        <xsl:text>&lt;!-- See https://en.wikipedia.org/wiki/Template:Infobox_organization for complete template --&gt;</xsl:text>
        <xsl:text />
        <xsl:text>| name</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:call-template name="tParseName">
            <xsl:with-param name="pNameType">corporate</xsl:with-param>
            <xsl:with-param name="pCorpName" select="$pCorpName" />
        </xsl:call-template>
        <xsl:text>| extinction</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text>&lt;!-- Date of extinction, optional --&gt;</xsl:text>
        <xsl:text />
        <xsl:text>| merger</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text />
        <xsl:text>| merged</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text />
        <xsl:text>| type</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text>&lt;!-- [[Governmental organization|GO]], [[Non-governmental organization|NGO]], etc. --&gt;</xsl:text>
        <xsl:text />
        <xsl:text>| status</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text>&lt;!-- Ad hoc, treaty, foundation, etc. --&gt;</xsl:text>
        <xsl:text />
        <xsl:text>| purpose</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text>&lt;!-- focus as e.g. humanitarian, peacekeeping, etc. --&gt;</xsl:text>
        <xsl:text />
        <xsl:text>| headquarters</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text />
        <xsl:text>| location</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:choose>
            <xsl:when test="/eac:eac-cpf/eac:cpfDescription/eac:description/eac:place/eac:placeEntry != ''">
                <xsl:value-of select="normalize-space(/eac:eac-cpf/eac:cpfDescription/eac:description/eac:place/eac:placeEntry)" />
                <xsl:text />
            </xsl:when>
            <xsl:otherwise>
                <xsl:text />
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>| coords</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text>&lt;!-- Coordinates of location using a coordinates template --&gt;</xsl:text>
        <xsl:text />
        <xsl:text>| region_served</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text />
        <xsl:text>| membership</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text />
        <xsl:text>| language</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text>&lt;!-- Official languages --&gt;</xsl:text>
        <xsl:text />
        <xsl:text>| leader_title</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text>&lt;!-- Position title for the leader of the org. --&gt;</xsl:text>
        <xsl:text />
        <xsl:text>| leader_name</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text>&lt;!-- Name of leader --&gt;</xsl:text>
        <xsl:text />
        <xsl:text>| key_people</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text />
        <xsl:text>| main_organ</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text>&lt;!-- General assembly, board of directors, etc. --&gt;</xsl:text>
        <xsl:text />
        <xsl:text>| parent_organization</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text>&lt;!-- If exists --&gt;</xsl:text>
        <xsl:text />
        <xsl:text>| affiliations</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text>&lt;!-- If any --&gt;</xsl:text>
        <xsl:text />
        <xsl:text>| budget</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text />
        <xsl:text>| num_staff</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text />
        <xsl:text>| num_volunteers</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text />
        <xsl:text>| website</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text>&lt;!-- {{URL|}} --&gt;</xsl:text>
        <xsl:text />
        <xsl:text>}}</xsl:text>
        <xsl:text />
    </xsl:template>
    <!-- Wikipedia content block templates. -->
    <!-- Output timeline, if available. -->
    <xsl:template name="tTimeline">
        <xsl:text />
        <xsl:text>==Timeline==</xsl:text>
        <xsl:text />
        <xsl:text>{{timeline-start}}</xsl:text>
        <xsl:for-each select="$pBiogHist/eac:chronList/eac:chronItem">
            <xsl:text />
            <xsl:text>{{timeline-item|</xsl:text>
            <xsl:text>{{start date|</xsl:text>
            <xsl:choose>
                <xsl:when test="eac:date">
                    <xsl:value-of select="eac:date" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="eac:dateRange/eac:fromDate" />
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="eac:dateRange/eac:toDate" />
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>}}|</xsl:text>
            <xsl:for-each select="eac:event">
                <xsl:value-of select="normalize-space(.)" />
                <xsl:if test="position() != last()">
                    <xsl:text />
                </xsl:if>
            </xsl:for-each>
            <xsl:text>}}</xsl:text>
            <xsl:text />
        </xsl:for-each>
        <xsl:text />
        <xsl:text>{{timeline-end}}</xsl:text>
        <xsl:text />
        <!-- Alternative timeline formatting
        <xsl:choose>
            <xsl:when
                test="/eac:eac-cpf/eac:cpfDescription/eac:description/eac:biogHist/eac:chronList/eac:chronItem">
                <xsl:text>&#10;</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>==Chronology==</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>{{timeline-start}}</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:for-each
                    select="/eac:eac-cpf/eac:cpfDescription/eac:description/eac:biogHist/eac:chronList/eac:chronItem">
                    <xsl:text>{{Timeline-event|date=</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:choose>
                        <xsl:when test="eac:date">
                            <xsl:value-of select="eac:date"/>
                        </xsl:when>
                        <xsl:when test="eac:dateRange">
                            <xsl:value-of select="eac:fromDate"/>
                            <xsl:text>-</xsl:text>
                            <xsl:value-of select="eac:toDate"/>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>|event=</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:value-of select="eac:event"/>
                    <xsl:text> }}</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                </xsl:for-each>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>{{timeline-end}}</xsl:text>
                <xsl:text>&#10;</xsl:text>
            </xsl:when>
        </xsl:choose> -->
    </xsl:template>
    <!-- Output "Notes and references" section. Right now, only default reference is to the finding aid we've used, if any. -->
    <xsl:template name="tReferences">
        <xsl:text />
        <xsl:text>==Notes and references==</xsl:text>
        <xsl:text />
        <xsl:choose>
            <xsl:when test="eac:eac-cpf/eac:control/eac:sources/eac:source/eac:objectXMLWrap">
                <!-- Insert a default reference to the finding aid itself. -->
                <xsl:text>&lt;!-- Basic citation for the finding aid. Author names will need to be adjusted (inverted, updated based on revision info, etc.). --&gt;</xsl:text>
                <xsl:for-each select="eac:eac-cpf/eac:control/eac:sources/eac:source[eac:sourceEntry]">
                    <xsl:text />
                    <xsl:choose>
                        <xsl:when test="//ead:author">
                            <xsl:value-of select="normalize-space(//ead:author)" />
                            <xsl:text>. "[</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>"[</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="normalize-space(@xlink:href)" />
                    <xsl:text>#bioghist</xsl:text>
                    <xsl:value-of select="normalize-space(eac:sourceEntry)" />
                    <xsl:text>],"</xsl:text>
                    <xsl:value-of select="$pFindingAidInfo" />
                    <xsl:text />
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="//eac:citation">
                <!-- Add any citation elements. -->
                <xsl:for-each select="//eac:citation">
                    <xsl:choose>
                        <xsl:when test="contains(.,'http')">
                            <xsl:text>*[</xsl:text>
                            <xsl:value-of select="normalize-space(.)" />
                            <xsl:text>]</xsl:text>
                            <xsl:text />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>*</xsl:text>
                            <xsl:value-of select="normalize-space(.)" />
                            <xsl:text />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise />
        </xsl:choose>
    </xsl:template>
    <!-- Output "Further reading" ("works about") section.  -->
    <xsl:template name="tFurther">
        <xsl:text />
        <xsl:text>==Further reading==</xsl:text>
        <xsl:text />
        <xsl:choose>
            <xsl:when test="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation[@resourceRelationType='subjectOf' and @xlink:role='resource']">
                <xsl:for-each select="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation[@resourceRelationType='subjectOf' and @xlink:role='resource']">
                    <xsl:sort select="translate(eac:relationEntry[@localType='creator'],'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
                    <xsl:for-each select="eac:relationEntry[1]">
                        <xsl:variable name="vStrLen" select="string-length(.)" />
                        <xsl:text>*</xsl:text>
                        <xsl:choose>
                            <xsl:when test="normalize-space(following-sibling::eac:relationEntry[@localType='creator'])">
                                <xsl:value-of select="normalize-space(following-sibling::eac:relationEntry[@localType='creator'])" />
                                <xsl:choose>
                                    <xsl:when test="contains(../@xlink:href,'q=kw')">
                                        <xsl:text>.</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:if test="not(substring(.,string-length(.))='.')">
                                            <xsl:text>. ''</xsl:text>
                                        </xsl:if>
                                        <xsl:if test="substring(.,string-length(.))='.'">
                                            <xsl:text />
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>''</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="contains(../@xlink:href,'q=kw')">
                                <xsl:text>[</xsl:text>
                                <xsl:value-of select="../@xlink:href" />
                                <xsl:text />
                                <xsl:text>''</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="substring(.,string-length(.))='.'">
                                        <xsl:value-of select="normalize-space(substring-before(substring(.,1,$vStrLen -1),'.'))" />
                                        <xsl:text>''</xsl:text>
                                        <xsl:text>].</xsl:text>
                                        <xsl:value-of select="normalize-space(substring-after(substring(.,1,$vStrLen -1),'.'))" />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="normalize-space(substring-before(.,'.'))" />
                                        <xsl:text>''</xsl:text>
                                        <xsl:text>].</xsl:text>
                                        <xsl:value-of select="normalize-space(substring-after(.,'.'))" />
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:text>.</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="contains(../@xlink:href,'oclc/') and following-sibling::eac:relationEntry[@localType='isbn']">
                                <xsl:value-of select="normalize-space(.)" />
                                <xsl:text>''.</xsl:text>
                                <xsl:text>{{OCLC|</xsl:text>
                                <xsl:value-of select="substring-after(../@xlink:href,'oclc/')" />
                                <xsl:text>}},</xsl:text>
                                <xsl:text>ISBN</xsl:text>
                                <xsl:value-of select="following-sibling::eac:relationEntry[@localType='isbn']" />
                            </xsl:when>
                            <xsl:when test="contains(../@xlink:href,'oclc/') and not(following-sibling::eac:relationEntry[@localType='isbn'])">
                                <xsl:value-of select="normalize-space(.)" />
                                <xsl:text>''.</xsl:text>
                                <xsl:text>{{OCLC|</xsl:text>
                                <xsl:value-of select="substring-after(../@xlink:href,'oclc/')" />
                                <xsl:text>}}</xsl:text>
                            </xsl:when>
                            <xsl:when test="following-sibling::eac:relationEntry[@localType='isbn'] and not(contains(../@xlink:href,'oclc/'))">
                                <xsl:value-of select="normalize-space(.)" />
                                <xsl:text>''.</xsl:text>
                                <xsl:text>ISBN</xsl:text>
                                <xsl:value-of select="following-sibling::eac:relationEntry[@localType='isbn']" />
                            </xsl:when>
                            <xsl:otherwise />
                        </xsl:choose>
                        <xsl:text />
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation[not(@resourceRelationType) and not(@xlink:role='resource')]">
                <xsl:for-each select="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation[not(@resourceRelationType) and not(@xlink:role='resource')]">
                    <xsl:sort select="translate(eac:relationEntry[@localType='creator'],'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
                    <xsl:text>*</xsl:text>
                    <xsl:value-of select="normalize-space(.)" />
                    <xsl:text />
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise />
        </xsl:choose>
    </xsl:template>
    <!-- Output "Works or publications" ("works by") section. -->
    <xsl:template name="tPub">
        <xsl:text />
        <xsl:text>==Works or publications==</xsl:text>
        <xsl:text />
        <xsl:choose>
            <xsl:when test="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation[@resourceRelationType='creatorOf' and @xlink:role='resource']">
                <!-- Check for works by the person or corporate body. -->
                <xsl:for-each select="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation[@resourceRelationType='creatorOf' and @xlink:role='resource']">
                    <xsl:sort select="translate(eac:relationEntry[1],'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
                    <xsl:variable name="vStrLen" select="string-length(eac:relationEntry[1])" />
                    <xsl:text>*</xsl:text>
                    <xsl:choose>
                        <xsl:when test="normalize-space(child::eac:relationEntry[@localType='creator'])">
                            <xsl:text>''</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>''</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="substring(eac:relationEntry[1],$vStrLen)='.'">
                            <xsl:variable name="vTitleVal" select="substring(eac:relationEntry[1],1,$vStrLen -1)" />
                            <xsl:value-of select="substring-before($vTitleVal,' . ')" />
                            <xsl:text>''.</xsl:text>
                            <xsl:value-of select="substring-after($vTitleVal,' . ')" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(eac:relationEntry[1])" />
                            <xsl:text>''.</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="contains(@xlink:href,'oclc/') and eac:relationEntry[@localType='isbn']">
                            <xsl:text>{{OCLC|</xsl:text>
                            <xsl:value-of select="substring-after(@xlink:href,'oclc/')" />
                            <xsl:text>}},</xsl:text>
                            <xsl:text>ISBN</xsl:text>
                            <xsl:value-of select="eac:relationEntry[@localType='isbn']" />
                        </xsl:when>
                        <xsl:when test="contains(@xlink:href,'oclc/') and not(eac:relationEntry[@localType='isbn'])">
                            <xsl:text>{{OCLC|</xsl:text>
                            <xsl:value-of select="substring-after(@xlink:href,'oclc/')" />
                            <xsl:text>}}</xsl:text>
                        </xsl:when>
                        <xsl:when test="eac:relationEntry[@localType='isbn'] and not(contains(@xlink:href,'oclc/'))">
                            <xsl:text>ISBN</xsl:text>
                            <xsl:value-of select="eac:relationEntry[@localType='isbn']" />
                        </xsl:when>
                        <xsl:otherwise />
                    </xsl:choose>
                    <xsl:text />
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <!-- Output "External links" section. -->
    <xsl:template name="tExternalLinks">
        <xsl:text />
        <xsl:text>==External links==</xsl:text>
        <!-- Include a link to a local discovery service. -->
        <xsl:text />
        <xsl:text>Library and archival resources by or about [</xsl:text>
        <xsl:call-template name="tParseName3">
            <xsl:with-param name="pNameType" select="'person' or 'corporate'" />
            <xsl:with-param name="pPersName" select="$pPersName" />
            <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
            <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
            <xsl:with-param name="pCorpName" select="$pCorpName" />
        </xsl:call-template>
        <xsl:text />
        <xsl:choose>
            <xsl:when test="eac:eac-cpf/eac:control/eac:otherRecordId[@localType='WCI']">
                <!-- Add ID nonstandard WorldCat IDs -->
                <xsl:text>*{{worldcat|description="WorldCat Identities page for</xsl:text>
                <xsl:call-template name="tParseName2">
                    <xsl:with-param name="pNameType" select="'person' or 'corporate'" />
                    <xsl:with-param name="pPersName" select="$pPersName" />
                    <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
                    <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
                    <xsl:with-param name="pCorpName" select="$pCorpName" />
                </xsl:call-template>
                <xsl:text>"|name=</xsl:text>
                <xsl:call-template name="tParseName2">
                    <xsl:with-param name="pNameType" select="'person' or 'corporate'" />
                    <xsl:with-param name="pPersName" select="$pPersName" />
                    <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
                    <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
                    <xsl:with-param name="pCorpName" select="$pCorpName" />
                </xsl:call-template>
                <xsl:text>|id=</xsl:text>
                <xsl:value-of select="translate(eac:eac-cpf/eac:control/eac:otherRecordId[@localType='WCI'],' ','+')" />
                <xsl:text>}}</xsl:text>
                <xsl:text />
            </xsl:when>
            <xsl:when test="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation[@xlink:role='archivalRecords']">
                <!-- Check for archival/digital collections created by or associated with the person or corporate body. -->
                <xsl:for-each select="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation[@xlink:role='archivalRecords']">
                    <xsl:sort select="translate(eac:relationEntry,'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
                    <xsl:text>*[</xsl:text>
                    <xsl:choose>
                        <xsl:when test="contains(@xlink:href,' ')">
                            <xsl:value-of select="normalize-space(translate(@xlink:href,' ','+'))" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="contains(@xlink:href,'oclc/')">
                                    <xsl:value-of select="normalize-space(@xlink:href)" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(@xlink:href)" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text />
                    <xsl:choose>
                        <xsl:when test="contains(normalize-space(eac:relationEntry),' . ')">
                            <xsl:value-of select="normalize-space(substring-before(eac:relationEntry,' . '))" />
                            <xsl:text>]</xsl:text>
                            <xsl:value-of select="normalize-space(substring-after(eac:relationEntry,' . '))" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(eac:relationEntry)" />
                            <xsl:text>]</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text />
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation[@resourceRelationType='other' and @xlink:role='resource']">
                    <xsl:sort select="translate(eac:relationEntry,'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
                    <xsl:text>*[</xsl:text>
                    <xsl:choose>
                        <xsl:when test="contains(@xlink:href,' ')">
                            <xsl:value-of select="normalize-space(translate(@xlink:href,' ','+'))" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="contains(@xlink:href,'oclc/')">
                                    <xsl:value-of select="normalize-space(@xlink:href)" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(@xlink:href)" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text />
                    <xsl:choose>
                        <xsl:when test="contains(normalize-space(eac:relationEntry),' . ')">
                            <xsl:value-of select="normalize-space(substring-before(eac:relationEntry,' . '))" />
                            <xsl:text>]</xsl:text>
                            <xsl:value-of select="normalize-space(substring-after(eac:relationEntry,' . '))" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(eac:relationEntry)" />
                            <xsl:text>]</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text />
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Output VIAF ID and/or LCCN, if available. -->
    <xsl:template name="tVIAF">
        <xsl:choose>
            <xsl:when test="eac:eac-cpf/eac:control/eac:sources/eac:source/@xlink:href[contains(.,'viaf')]">
                <xsl:text />
                <xsl:text />
                <xsl:for-each select="eac:eac-cpf/eac:control/eac:sources/eac:source/@xlink:href[contains(.,'viaf')]">
                    <xsl:text>{{Authority control|VIAF=</xsl:text>
                    <xsl:value-of select="substring-after(.,'viaf/')" />
                    <xsl:choose>
                        <xsl:when test="../../../eac:otherRecordId[@localType='WCI:LCCN']">
                            <xsl:text>|LCCN=</xsl:text>
                            <xsl:choose>
                                <xsl:when test="contains(../../../eac:otherRecordId[@localType='WCI:LCCN'],'no')">
                                    <xsl:variable name="lccn" select="substring-after(../../../eac:otherRecordId[@localType='WCI:LCCN'],'lccn-no')" />
                                    <xsl:value-of select="concat('no/',translate($lccn,'-','/'))" />
                                </xsl:when>
                                <xsl:when test="contains(../../../eac:otherRecordId[@localType='WCI:LCCN'],'nr')">
                                    <xsl:variable name="lccn" select="substring-after(../../../eac:otherRecordId[@localType='WCI:LCCN'],'lccn-nr')" />
                                    <xsl:value-of select="concat('nr/',translate($lccn,'-','/'))" />
                                </xsl:when>
                                <xsl:when test="contains(../../../eac:otherRecordId[@localType='WCI:LCCN'],'sh')">
                                    <xsl:variable name="lccn" select="substring-after(../../../eac:otherRecordId[@localType='WCI:LCCN'],'lccn-sh')" />
                                    <xsl:value-of select="concat('sh/',translate($lccn,'-','/'))" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:variable name="lccn" select="substring-after(../../../eac:otherRecordId[@localType='WCI:LCCN'],'lccn-n')" />
                                    <xsl:value-of select="concat('n/',translate($lccn,'-','/'))" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:text>}}</xsl:text>
                    <xsl:text />
                    <xsl:text />
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="eac:eac-cpf/eac:control/eac:otherRecordId[@localType='WCI:LCCN']">
                        <xsl:text />
                        <xsl:text />
                        <xsl:text>{{Authority control|LCCN=</xsl:text>
                        <xsl:choose>
                            <xsl:when test="contains(eac:eac-cpf/eac:control/eac:otherRecordId[@localType='WCI:LCCN'],'no')">
                                <xsl:variable name="lccn" select="substring-after(eac:eac-cpf/eac:control/eac:otherRecordId[@localType='WCI:LCCN'],'lccn-no')" />
                                <xsl:value-of select="concat('no/',translate($lccn,'-','/'))" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="lccn" select="substring-after(eac:eac-cpf/eac:control/eac:otherRecordId[@localType='WCI:LCCN'],'lccn-n')" />
                                <xsl:value-of select="concat('n/',translate($lccn,'-','/'))" />
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>}}</xsl:text>
                        <xsl:text />
                        <xsl:text />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Output PersonDate template. -->
    <xsl:template name="tPersonData">
        <xsl:param name="pPersName" select="$pPersName" />
        <xsl:param name="pPersNameSur" select="$pPersNameSur" />
        <xsl:param name="pPersNameFore" select="$pPersNameFore" />
        <xsl:text />
        <xsl:text>{{Persondata</xsl:text>
        <xsl:text>&lt;!-- Metadata: see [[Wikipedia:Persondata]]. --&gt;</xsl:text>
        <xsl:text />
        <xsl:text>| NAME</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:choose>
            <xsl:when test="$pPersNameFore or $pPersNameSur">
                <xsl:value-of select="normalize-space($pPersNameSur)" />
                <xsl:text>,</xsl:text>
                <xsl:value-of select="normalize-space($pPersNameFore)" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <!-- If the name contains no dates ... -->
                    <xsl:when test="string-length(translate($pPersName,concat($vAlpha,$vCommaSpace),''))=0">
                        <!-- ... then output as is. -->
                        <xsl:value-of select="$pPersName" />
                    </xsl:when>
                    <!-- If the name does contain dates ... -->
                    <xsl:when test="string-length(translate($pPersName,concat($vAlpha,$vCommaSpace),''))&gt;0">
                        <!-- ... output the part of the name before the dates. -->
                        <xsl:value-of select="substring-before($pPersName,', ')" />
                        <xsl:text>,</xsl:text>
                        <xsl:value-of select="substring-before(substring-after($pPersName,', '),', ')" />
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text />
        <xsl:text>| ALTERNATIVE NAMES</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text />
        <xsl:text>| SHORT DESCRIPTION</xsl:text>
        <xsl:text>=</xsl:text>
        <xsl:text />
        <xsl:text>| DATE OF BIRTH</xsl:text>
        <xsl:text>=</xsl:text>
        <!-- Call template to attempt to prepopulate birth date info. -->
        <xsl:call-template name="tNameDateParser">
            <xsl:with-param name="pBirthYr" select="'true'" />
            <xsl:with-param name="pCheckInfo" select="'false'" />
        </xsl:call-template>
        <xsl:text />
        <xsl:text>| PLACE OF BIRTH</xsl:text>
        <xsl:text>=</xsl:text>
        <!-- Call template to attempt to prepopulate birth place info. -->
        <!-- Under revision ...
        <xsl:call-template name="tBirthPlaceFinder">
            <xsl:with-param name="pBiogHist" select="$pBiogHist"/>
        </xsl:call-template>
        -->
        <xsl:text />
        <xsl:text>| DATE OF DEATH</xsl:text>
        <xsl:text>=</xsl:text>
        <!-- Call template to attempt to prepopulate death date info. -->
        <xsl:call-template name="tNameDateParser">
            <xsl:with-param name="pDeathYr" select="'true'" />
            <xsl:with-param name="pCheckInfo" select="'false'" />
        </xsl:call-template>
        <xsl:text />
        <xsl:text>| PLACE OF DEATH</xsl:text>
        <xsl:text>=</xsl:text>
        <!-- Call template to attempt to prepopulate death place info. -->
        <!-- Under revision ...
        <xsl:call-template name="tDeathPlaceFinder">
            <xsl:with-param name="pBiogHist" select="$pBiogHist"/>
        </xsl:call-template>
        -->
        <xsl:text />
        <xsl:text>}}</xsl:text>
        <xsl:text />
        <xsl:text />
        <xsl:choose>
            <!-- If the name contains no dates ... -->
            <xsl:when test="string-length(translate($pPersName,concat($vAlpha,$vCommaSpace),''))=0">
                <!-- ... then output as is. -->
                <xsl:text>{{DEFAULTSORT:</xsl:text>
                <xsl:choose>
                    <xsl:when test="$pPersName">
                        <xsl:value-of select="$pPersName" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space($pPersNameSur)" />
                        <xsl:text>,</xsl:text>
                        <xsl:value-of select="normalize-space($pPersNameFore)" />
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>}}</xsl:text>
                <xsl:text />
            </xsl:when>
            <!-- If the name does contain dates ... -->
            <xsl:when test="string-length(translate($pPersName,concat($vAlpha,$vCommaSpace),''))&gt;0">
                <!-- ... output the part of the name before the dates. -->
                <xsl:text>{{DEFAULTSORT:</xsl:text>
                <xsl:value-of select="substring-before($pPersName,', ')" />
                <xsl:text>,</xsl:text>
                <xsl:value-of select="substring-before(substring-after($pPersName,', '),', ')" />
                <xsl:text>}}</xsl:text>
                <xsl:text />
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <!-- Include some basic categories. -->
    <xsl:template name="tCategories">
        <xsl:param name="pNameType" />
        <xsl:param name="pBiogHist" />
        <xsl:text />
        <xsl:if test="$pNameType='person'">
            <xsl:if test="eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates/eac:dateRange/eac:fromDate!=''">
                <xsl:text>[[Category:</xsl:text>
                <xsl:call-template name="tNameDateParser">
                    <xsl:with-param name="pBirthYr" select="'true'" />
                    <xsl:with-param name="pCheckInfo" select="'false'" />
                </xsl:call-template>
                <xsl:text>births]]</xsl:text>
                <xsl:text />
            </xsl:if>
            <xsl:if test="eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates/eac:dateRange/eac:toDate!=''">
                <xsl:text>[[Category:</xsl:text>
                <xsl:call-template name="tNameDateParser">
                    <xsl:with-param name="pDeathYr" select="'true'" />
                    <xsl:with-param name="pCheckInfo" select="'false'" />
                </xsl:call-template>
                <xsl:text>deaths]]</xsl:text>
                <xsl:text />
            </xsl:if>
            <xsl:if test="eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType[contains(.,'6')]]|eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType='subject']">
                <xsl:text />
                <xsl:text>&lt;!-- Note: the following categories have been generated from the the EAC input form, the original EAD finding aid, or else using FAST headings added from WorldCat Identities. These categories should be replaced with appropriate Wikipedia categories (for example, using the HotCat tool).</xsl:text>
                <xsl:text />
                <xsl:text />
                <xsl:for-each select="eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType[contains(.,'6')]]|eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType='subject']">
                    <xsl:sort select="translate(eac:term,'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
                    <xsl:text>[[Category:</xsl:text>
                    <xsl:value-of select="normalize-space(eac:term)" />
                    <xsl:text>]]</xsl:text>
                    <xsl:text />
                </xsl:for-each>
                <xsl:text />
                <xsl:text>--&gt;</xsl:text>
                <xsl:text />
            </xsl:if>
            <!-- Output some sample thematic categories, along with stub template, if appropriate. NB: Experimental. This is an area to developed. -->
            <xsl:choose>
                <xsl:when test="contains($pBiogHist,'Cuban')">
                    <xsl:if test="contains($pBiogHist,'exile') or contains($pBiogHist,'exiled') or contains(eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation/eac:objectXMLWrap/ead:scopecontent, 'exile')">
                        <xsl:text>[[Category:Cuban exiles]]</xsl:text>
                    </xsl:if>
                    <xsl:if test="contains($pBiogHist,'novelist') or contains($pBiogHist,'novels')">
                        <xsl:text />
                        <xsl:text>[[Category:Cuban novelists]]</xsl:text>
                    </xsl:if>
                    <xsl:if test="contains($pBiogHist,'anthropologist') or contains($pBiogHist,'anthropology')">
                        <xsl:text />
                        <xsl:text>[[Category:Cuban anthropologists]]</xsl:text>
                    </xsl:if>
                    <!-- If the person bio is less than 5000 characters, consider it a stub. -->
                    <xsl:if test="string-length($pBiogHist) &lt; 5000">
                        <xsl:text />
                        <xsl:text />
                        <xsl:text>{{Cuba-bio-stub}}</xsl:text>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="string-length($pBiogHist) &lt; 5000">
                        <xsl:text />
                        <xsl:text />
                        <xsl:text>{{Bio-stub}}</xsl:text>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$pNameType='corporate'">
            <xsl:choose>
                <xsl:when test="eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType[contains(.,'6')]|@localType='subject']">
                    <xsl:text>&lt;!-- Note: the following categories have been generated from the the EAC input form, the original EAD finding aid, or else using FAST headings added from WorldCat Identities. These categories should be replaced with appropriate Wikipedia categories (for example, using the HotCat tool).</xsl:text>
                    <xsl:text />
                    <xsl:text />
                    <xsl:for-each select="eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType[contains(.,'6')]|@localType='subject']">
                        <xsl:sort select="translate(eac:term,'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
                        <xsl:text>[[Category:</xsl:text>
                        <xsl:value-of select="normalize-space(.)" />
                        <xsl:text>]]</xsl:text>
                        <xsl:text />
                    </xsl:for-each>
                    <xsl:text />
                    <xsl:text>--&gt;</xsl:text>
                    <xsl:text />
                    <xsl:if test="string-length($pBiogHist) &lt; 5000">
                        <xsl:text />
                        <xsl:text>{{Org-stub}}</xsl:text>
                    </xsl:if>
                </xsl:when>
                <!-- If the corporate body bio is less than 5000 characters, consider it a stub. -->
                <xsl:when test="string-length($pBiogHist) &lt; 5000">
                    <xsl:text>{{Org-stub}}</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <!-- Temporarily, provide a list of related enties from subject headings or cpfRelations so that users can explore possibilities for links from other pages. 
         NB: This is an area to developed. -->
    <xsl:template name="tRelations">
        <xsl:param name="pNameType" />
        <xsl:text />
        <xsl:text>==See also==</xsl:text>
        <xsl:text />
        <xsl:choose>
            <xsl:when test="$pNameType='person'">
                <xsl:text>&lt;!--</xsl:text>
                <xsl:call-template name="tParseName2">
                    <xsl:with-param name="pNameType">person</xsl:with-param>
                    <xsl:with-param name="pPersName" select="$pPersName" />
                    <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
                    <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
                </xsl:call-template>
                <xsl:text>may be associated with the following entities. These names were extracted from appropriate subject headings or from the &lt;cpfRelation&gt; elements in the EAC-CPF record. They may be useful for creating links to this page from other Wikipedia pages. Some names may be duplicates; however, different name forms can useful for testing whether an entity has an existing page on Wikipedia.</xsl:text>
                <xsl:text />
                <xsl:text />
                <xsl:text>The 'See also' section should not link to pages that do not exist (red links) nor to disambiguation pages (unless used for further disambiguation in a disambiguation page).</xsl:text>
                <xsl:text />
                <xsl:text />
                <xsl:text>Editors should provide a brief annotation when a link's relevance is not immediately apparent, when the meaning of the term may not be generally known, or when the term is ambiguous. For example:</xsl:text>
                <xsl:text />
                <xsl:text />
                <xsl:text>[[Related person]]—made a similar achievement on April 4, 2005</xsl:text>
                <xsl:text />
                <xsl:text>--&gt;</xsl:text>
                <xsl:text />
                <xsl:text />
                <xsl:for-each select="eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription">
                    <xsl:sort select="translate(eac:term,'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
                    <xsl:if test="contains(@localType,'7')">
                        <xsl:text>*[[</xsl:text>
                        <xsl:call-template name="tParseName2">
                            <xsl:with-param name="pNameType">person</xsl:with-param>
                            <xsl:with-param name="pPersName" select="eac:term" />
                        </xsl:call-template>
                        <xsl:text>]]</xsl:text>
                        <xsl:text />
                    </xsl:if>
                    <xsl:if test="contains(@localType,'610')">
                        <xsl:text>*[[</xsl:text>
                        <xsl:call-template name="tParseName2">
                            <xsl:with-param name="pNameType">corporate</xsl:with-param>
                            <xsl:with-param name="pCorpName" select="eac:term" />
                        </xsl:call-template>
                        <xsl:text>]]</xsl:text>
                        <xsl:text />
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:cpfRelation">
                    <xsl:sort select="translate(eac:relationEntry[1],'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
                    <xsl:choose>
                        <xsl:when test="contains(eac:relationEntry,', ')">
                            <xsl:text>*[[</xsl:text>
                            <xsl:call-template name="tParseName2">
                                <xsl:with-param name="pNameType">person</xsl:with-param>
                                <xsl:with-param name="pPersName" select="eac:relationEntry[1]" />
                            </xsl:call-template>
                            <xsl:text>]]</xsl:text>
                            <xsl:text />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>*[[</xsl:text>
                            <xsl:call-template name="tParseName2">
                                <xsl:with-param name="pNameType">corporate</xsl:with-param>
                                <xsl:with-param name="pCorpName" select="eac:relationEntry[1]" />
                            </xsl:call-template>
                            <xsl:text>]]</xsl:text>
                            <xsl:text />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="$pNameType='corporate'">
                <xsl:text>&lt;!--</xsl:text>
                <xsl:call-template name="tParseName2">
                    <xsl:with-param name="pNameType">corporate</xsl:with-param>
                    <xsl:with-param name="pCorpName" select="$pCorpName" />
                </xsl:call-template>
                <xsl:text>may be associated with the following entities. These names were extracted from the &lt;cpfRelation&gt; elements in the EAC-CPF record and may be useful for creating links to this page from other Wikipedia pages. Some names may be duplicates; however, different name forms can useful for testing whether an entity has an existing page on Wikipedia.</xsl:text>
                <xsl:text />
                <xsl:text />
                <xsl:text>The 'See also' section should not link to pages that do not exist (red links) nor to disambiguation pages (unless used for further disambiguation in a disambiguation page).</xsl:text>
                <xsl:text />
                <xsl:text />
                <xsl:text>Editors should provide a brief annotation when a link's relevance is not immediately apparent, when the meaning of the term may not be generally known, or when the term is ambiguous. For example:</xsl:text>
                <xsl:text />
                <xsl:text />
                <xsl:text>[[Related person]]—made a similar achievement on April 4, 2005</xsl:text>
                <xsl:text />
                <xsl:text>--&gt;</xsl:text>
                <xsl:text />
                <xsl:text />
                <xsl:for-each select="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:cpfRelation">
                    <xsl:sort select="translate(eac:relationEntry[1],'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
                    <xsl:choose>
                        <xsl:when test="@xlink:role='http://rdvocab.info/uri/schema/FRBRentitiesRDA/Person'">
                            <xsl:text>*[[</xsl:text>
                            <xsl:call-template name="tParseName2">
                                <xsl:with-param name="pNameType">person</xsl:with-param>
                                <xsl:with-param name="pPersName" select="eac:relationEntry[1]" />
                            </xsl:call-template>
                            <xsl:text>]]</xsl:text>
                            <xsl:text />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>*[[</xsl:text>
                            <xsl:call-template name="tParseName2">
                                <xsl:with-param name="pNameType">corporate</xsl:with-param>
                                <xsl:with-param name="pCorpName" select="eac:relationEntry[1]" />
                            </xsl:call-template>
                            <xsl:text>]]</xsl:text>
                            <xsl:text />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Template for parsing Infobox names and related info. -->
    <xsl:template name="tParseName">
        <xsl:param name="pNameType" />
        <xsl:param name="pPersName" select="$pPersName" />
        <xsl:param name="pCorpName" select="$pCorpName" />
        <xsl:param name="pPersNameSur" select="$pPersNameSur" />
        <xsl:param name="pPersNameFore" select="$pPersNameFore" />
        <!-- Parse names for people first. -->
        <xsl:if test="$pNameType='person'">
            <xsl:choose>
                <xsl:when test="$pPersName">
                    <!-- If the name contains no dates ... -->
                    <xsl:if test="string-length(translate($pPersName,concat($vAlpha,$vCommaSpace),''))=0">
                        <!-- ... then reverse the order of the name parts accordingly. -->
                        <xsl:value-of select="substring-after($pPersName,', ')" />
                        <xsl:text />
                        <xsl:value-of select="substring-before($pPersName,', ')" />
                        <xsl:text />
                        <xsl:text>| image</xsl:text>
                        <xsl:text>=</xsl:text>
                        <xsl:text />
                        <xsl:text>| size</xsl:text>
                        <xsl:text>=</xsl:text>
                        <xsl:text>&lt;!-- Default 200px --&gt;</xsl:text>
                        <xsl:text />
                        <xsl:text>| alt</xsl:text>
                        <xsl:text>=</xsl:text>
                        <xsl:text />
                        <xsl:text>| caption</xsl:text>
                        <xsl:text>=</xsl:text>
                        <xsl:text />
                        <xsl:text>| birth_name</xsl:text>
                        <xsl:text>=</xsl:text>
                        <xsl:text />
                        <xsl:text>| birth_date</xsl:text>
                        <xsl:text>=</xsl:text>
                        <!-- Call template to attempt to prepopulate birth date info. -->
                        <xsl:call-template name="tNameDateParser">
                            <xsl:with-param name="pBirthYr" select="'true'" />
                            <xsl:with-param name="pCheckInfo" select="'true'" />
                        </xsl:call-template>
                        <xsl:text>&lt;!-- {{Birth date and age|YYYY|MM|DD}} --&gt;</xsl:text>
                        <xsl:text />
                        <xsl:text>| birth_place</xsl:text>
                        <xsl:text>=</xsl:text>
                        <!-- Call template to attempt to prepopulate birth place info. -->
                        <!-- Under revision ...
                    <xsl:call-template name="tBirthPlaceFinder">
                        <xsl:with-param name="pBiogHist" select="$pBiogHist"/>
                    </xsl:call-template>
                    -->
                        <xsl:text />
                        <xsl:text>| death_date</xsl:text>
                        <xsl:text>=</xsl:text>
                        <!-- Call template to attempt to prepopulate death date info. -->
                        <xsl:call-template name="tNameDateParser">
                            <xsl:with-param name="pDeathYr" select="'true'" />
                            <xsl:with-param name="pCheckInfo" select="'true'" />
                        </xsl:call-template>
                        <xsl:text>&lt;!-- {{Death date and age|YYYY|MM|DD|YYYY|MM|DD}} (death date then birth date) --&gt;</xsl:text>
                        <xsl:text />
                        <xsl:text>| death_place</xsl:text>
                        <xsl:text>=</xsl:text>
                        <!-- Call template to attempt to prepopulate death place info. -->
                        <!-- Under revision ...
                    <xsl:call-template name="tDeathPlaceFinder">
                        <xsl:with-param name="pBiogHist" select="$pBiogHist"/>
                    </xsl:call-template>
                    -->
                        <xsl:text />
                    </xsl:if>
                    <!-- If the name does contain dates ... -->
                    <xsl:if test="string-length(translate($pPersName,concat($vAlpha,$vCommaSpace),''))&gt;=4">
                        <!-- ... reverse the order of the name parts accordingly. -->
                        <xsl:value-of select="substring-before(substring-after($pPersName,','),',')" />
                        <xsl:text />
                        <xsl:value-of select="substring-before($pPersName,',')" />
                        <xsl:text />
                        <xsl:text>| image</xsl:text>
                        <xsl:text>=</xsl:text>
                        <xsl:text />
                        <xsl:text>| size</xsl:text>
                        <xsl:text>=</xsl:text>
                        <xsl:text>&lt;!-- Default 200px --&gt;</xsl:text>
                        <xsl:text />
                        <xsl:text>| alt</xsl:text>
                        <xsl:text>=</xsl:text>
                        <xsl:text />
                        <xsl:text>| caption</xsl:text>
                        <xsl:text>=</xsl:text>
                        <xsl:text />
                        <xsl:text>| birth_name</xsl:text>
                        <xsl:text>=</xsl:text>
                        <xsl:text />
                        <xsl:text>| birth_date</xsl:text>
                        <xsl:text>=</xsl:text>
                        <!-- Call template to attempt to prepopulate birth date info. -->
                        <xsl:call-template name="tNameDateParser">
                            <xsl:with-param name="pBirthYr" select="'true'" />
                            <xsl:with-param name="pCheckInfo" select="'true'" />
                        </xsl:call-template>
                        <xsl:text>&lt;!-- {{Birth date and age|YYYY|MM|DD}} --&gt;</xsl:text>
                        <xsl:text />
                        <xsl:text>| birth_place</xsl:text>
                        <xsl:text>=</xsl:text>
                        <!-- Call template to attempt to prepopulate birth place info. -->
                        <!-- Under revision ...
                    <xsl:call-template name="tBirthPlaceFinder">
                        <xsl:with-param name="pBiogHist" select="$pBiogHist"/>
                    </xsl:call-template>
                    -->
                        <xsl:text />
                        <xsl:text>| death_date</xsl:text>
                        <xsl:text>=</xsl:text>
                        <!-- Call template to attempt to prepopulate death date info. -->
                        <xsl:call-template name="tNameDateParser">
                            <xsl:with-param name="pDeathYr" select="'true'" />
                            <xsl:with-param name="pCheckInfo" select="'true'" />
                        </xsl:call-template>
                        <xsl:text>&lt;!-- {{Death date and age|YYYY|MM|DD|YYYY|MM|DD}} (death date then birth date) --&gt;</xsl:text>
                        <xsl:text />
                        <xsl:text>| death_place</xsl:text>
                        <xsl:text>=</xsl:text>
                        <!-- Call template to attempt to prepopulate death place info. -->
                        <!-- Under revision ...
                    <xsl:call-template name="tDeathPlaceFinder">
                        <xsl:with-param name="pBiogHist" select="$pBiogHist"/>
                    </xsl:call-template>
                    -->
                        <xsl:text />
                    </xsl:if>
                </xsl:when>
                <!-- If there are name parts... -->
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($pPersNameFore)" />
                    <xsl:text />
                    <xsl:value-of select="normalize-space($pPersNameSur)" />
                    <xsl:text />
                    <xsl:text>| image</xsl:text>
                    <xsl:text>=</xsl:text>
                    <xsl:text />
                    <xsl:text>| size</xsl:text>
                    <xsl:text>=</xsl:text>
                    <xsl:text>&lt;!-- Default 200px --&gt;</xsl:text>
                    <xsl:text />
                    <xsl:text>| alt</xsl:text>
                    <xsl:text>=</xsl:text>
                    <xsl:text />
                    <xsl:text>| caption</xsl:text>
                    <xsl:text>=</xsl:text>
                    <xsl:text />
                    <xsl:text>| birth_name</xsl:text>
                    <xsl:text>=</xsl:text>
                    <xsl:text />
                    <xsl:text>| birth_date</xsl:text>
                    <xsl:text>=</xsl:text>
                    <!-- Call template to attempt to prepopulate birth date info. -->
                    <xsl:call-template name="tNameDateParser">
                        <xsl:with-param name="pBirthYr" select="'true'" />
                        <xsl:with-param name="pCheckInfo" select="'true'" />
                    </xsl:call-template>
                    <xsl:text>&lt;!-- {{Birth date and age|YYYY|MM|DD}} --&gt;</xsl:text>
                    <xsl:text />
                    <xsl:text>| birth_place</xsl:text>
                    <xsl:text>=</xsl:text>
                    <!-- Call template to attempt to prepopulate birth place info. -->
                    <!-- Under revision ...
                    <xsl:call-template name="tBirthPlaceFinder">
                        <xsl:with-param name="pBiogHist" select="$pBiogHist"/>
                    </xsl:call-template>
                    -->
                    <xsl:text />
                    <xsl:text>| death_date</xsl:text>
                    <xsl:text>=</xsl:text>
                    <!-- Call template to attempt to prepopulate death date info. -->
                    <xsl:call-template name="tNameDateParser">
                        <xsl:with-param name="pDeathYr" select="'true'" />
                        <xsl:with-param name="pCheckInfo" select="'true'" />
                    </xsl:call-template>
                    <xsl:text>&lt;!-- {{Death date and age|YYYY|MM|DD|YYYY|MM|DD}} (death date then birth date) --&gt;</xsl:text>
                    <xsl:text />
                    <xsl:text>| death_place</xsl:text>
                    <xsl:text>=</xsl:text>
                    <!-- Call template to attempt to prepopulate death place info. -->
                    <!-- Under revision ...
                    <xsl:call-template name="tDeathPlaceFinder">
                        <xsl:with-param name="pBiogHist" select="$pBiogHist"/>
                    </xsl:call-template>
                    -->
                    <xsl:text />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <!-- Then parse names for corporate bodies. -->
        <xsl:if test="$pNameType='corporate'">
            <!-- Name order stays as is. -->
            <xsl:value-of select="$pCorpName" />
            <xsl:text />
            <xsl:text>| image</xsl:text>
            <xsl:text>=</xsl:text>
            <xsl:text />
            <xsl:text>| size</xsl:text>
            <xsl:text>=</xsl:text>
            <xsl:text>&lt;!-- Default 200px --&gt;</xsl:text>
            <xsl:text />
            <xsl:text>| alt</xsl:text>
            <xsl:text>=</xsl:text>
            <xsl:text />
            <xsl:text>| caption</xsl:text>
            <xsl:text>=</xsl:text>
            <xsl:text />
            <xsl:text>| abbreviation</xsl:text>
            <xsl:text>=</xsl:text>
            <xsl:text />
            <xsl:text>| motto</xsl:text>
            <xsl:text>=</xsl:text>
            <xsl:text />
            <xsl:text>| predecessor</xsl:text>
            <xsl:text>=</xsl:text>
            <xsl:text />
            <xsl:text>| successor</xsl:text>
            <xsl:text>=</xsl:text>
            <xsl:text />
            <xsl:text>| formation</xsl:text>
            <xsl:text>=</xsl:text>
            <xsl:choose>
                <xsl:when test="/eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates/@standardDate">
                    <xsl:value-of select="normalize-space(/eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates/@standardDate)" />
                    <xsl:text />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&lt;!-- {{Start date and age|YYYY|MM|DD}} --&gt;</xsl:text>
                    <xsl:text />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <!-- General template for parsing names and dates. -->
    <xsl:template name="tParseName2">
        <xsl:param name="pNameType" />
        <xsl:param name="pPersName" />
        <xsl:param name="pPersNameSur" select="$pPersNameSur" />
        <xsl:param name="pPersNameFore" select="$pPersNameFore" />
        <xsl:param name="pCorpName" />
        <!-- Parse names for people first. -->
        <xsl:if test="$pNameType='person'">
            <xsl:choose>
                <xsl:when test="$pPersNameFore or $pPersNameSur">
                    <xsl:value-of select="normalize-space($pPersNameFore)" />
                    <xsl:text />
                    <xsl:value-of select="normalize-space($pPersNameSur)" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <!-- If the name contains dates ... -->
                        <xsl:when test="string-length(translate($pPersName,$vDigits,''))&lt;string-length($pPersName)">
                            <!-- ... then reverse the order of the name parts accordingly. -->
                            <xsl:choose>
                                <xsl:when test="contains(substring-after(normalize-space($pPersName),', '), ' ') and not(contains(substring-after(normalize-space($pPersName),', '), ', ')) and not(contains(substring-after(normalize-space($pPersName),', '), ' b ')) and not(contains(substring-after(normalize-space($pPersName),', '), ' b. '))">
                                    <xsl:value-of select="substring-before(substring-after(normalize-space($pPersName),', '),' ')" />
                                    <xsl:text />
                                    <xsl:value-of select="substring-before(normalize-space($pPersName),', ')" />
                                </xsl:when>
                                <xsl:when test="contains(substring-after(normalize-space($pPersName),', '), ' b. ') and not(contains(substring-after(normalize-space($pPersName),', '), ', '))">
                                    <xsl:value-of select="substring-before(substring-after(normalize-space($pPersName),', '),' b. ')" />
                                    <xsl:text />
                                    <xsl:value-of select="substring-before(normalize-space($pPersName),', ')" />
                                </xsl:when>
                                <xsl:when test="contains(substring-after(normalize-space($pPersName),', '), ' b ') and not(contains(substring-after(normalize-space($pPersName),', '), ', '))">
                                    <xsl:value-of select="substring-before(substring-after(normalize-space($pPersName),', '),' b ')" />
                                    <xsl:text />
                                    <xsl:value-of select="substring-before(normalize-space($pPersName),', ')" />
                                </xsl:when>
                                <xsl:when test="contains(substring-after(normalize-space($pPersName),', '), ', b ')">
                                    <xsl:value-of select="substring-before(substring-after(normalize-space($pPersName),', '),', b ')" />
                                    <xsl:text />
                                    <xsl:value-of select="substring-before(normalize-space($pPersName),', ')" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="substring-before(substring-after(normalize-space($pPersName),', '),', ')">
                                            <xsl:value-of select="substring-before(substring-after(normalize-space($pPersName),', '),', ')" />
                                            <xsl:text />
                                            <xsl:value-of select="substring-before(normalize-space($pPersName),', ')" />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <!-- Name order stays as is. -->
                                            <xsl:value-of select="normalize-space(translate($pPersName,concat($vDigits,'-','(',')'),''))" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- If the name does not include dates ... -->
                            <xsl:choose>
                                <xsl:when test="contains($pPersName,', ')">
                                    <xsl:value-of select="substring-after(normalize-space($pPersName),', ')" />
                                    <xsl:text />
                                    <xsl:value-of select="substring-before(normalize-space($pPersName),', ')" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- Name order stays as is. -->
                                    <xsl:value-of select="normalize-space($pPersName)" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <!-- Then parse names for corporate bodies. -->
        <xsl:if test="$pNameType='corporate'">
            <!-- Set variables to strip trailing period. -->
            <xsl:variable name="vCorpNameLength" select="string-length($pCorpName)" />
            <xsl:variable name="vCorpNameVal" select="substring($pCorpName,$vCorpNameLength)" />
            <!-- Name order stays as is. -->
            <xsl:choose>
                <xsl:when test="$vCorpNameVal='.'">
                    <xsl:value-of select="substring(normalize-space($pCorpName),1,$vCorpNameLength -1)" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($pCorpName)" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <!-- Template for parse names in external link to library discovery service. Blank space must be translated to "+" in order for Wikipedia to recognize the link. -->
    <xsl:template name="tParseName3">
        <xsl:param name="pNameType" />
        <xsl:param name="pCorpName" />
        <xsl:param name="pPersName" />
        <xsl:param name="pPersNameFore" />
        <xsl:param name="pPersNameSur" />
        <xsl:if test="$pNameType='person'">
            <xsl:if test="$pPersName!='' or $pPersNameFore!='' or $pPersNameSur!=''">
                <xsl:choose>
                    <xsl:when test="$pPersNameSur or $pPersNameFore">
                        <!-- Output the URL -->
                        <xsl:value-of select="$pDiscServ" />
                        <!-- Output the name. -->
                        <xsl:value-of select="translate(concat(normalize-space($pPersNameFore),' ',normalize-space($pPersNameSur)),',. ','+++')" />
                        <xsl:text />
                        <xsl:call-template name="tParseName2">
                            <xsl:with-param name="pNameType">person</xsl:with-param>
                            <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
                            <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
                        </xsl:call-template>
                        <xsl:text>].</xsl:text>
                    </xsl:when>
                    <!-- If the name contains no dates ... -->
                    <xsl:when test="string-length(translate($pPersName,concat($vAlpha,$vCommaSpace),''))=0">
                        <!-- ... then reverse the order of the name parts accordingly. -->
                        <!-- Output the URL -->
                        <xsl:value-of select="$pDiscServ" />
                        <!-- Output the name. -->
                        <xsl:choose>
                            <xsl:when test="contains($pPersName,',')">
                                <xsl:value-of select="translate(concat(substring-after($pPersName,', '),' ',substring-before($pPersName,', ')),',. ','+++')" />
                                <xsl:text />
                                <xsl:call-template name="tParseName2">
                                    <xsl:with-param name="pNameType">person</xsl:with-param>
                                    <xsl:with-param name="pPersName" select="$pPersName" />
                                    <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
                                    <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
                                </xsl:call-template>
                                <xsl:text>].</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="tParseName2">
                                    <xsl:with-param name="pNameType">person</xsl:with-param>
                                    <xsl:with-param name="pPersName" select="$pPersName" />
                                    <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
                                    <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
                                </xsl:call-template>
                                <xsl:text />
                                <xsl:call-template name="tParseName2">
                                    <xsl:with-param name="pNameType">person</xsl:with-param>
                                    <xsl:with-param name="pPersName" select="$pPersName" />
                                    <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
                                    <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
                                </xsl:call-template>
                                <xsl:text>].</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- If the name includes dates ... -->
                        <xsl:value-of select="$pDiscServ" />
                        <xsl:choose>
                            <xsl:when test="contains($pPersName,',')">
                                <xsl:value-of select="translate(concat(substring-before(substring-after($pPersName,', '),', '),' ',substring-before($pPersName,', ')),',. ','+++')" />
                                <xsl:text />
                                <xsl:call-template name="tParseName2">
                                    <xsl:with-param name="pNameType">person</xsl:with-param>
                                    <xsl:with-param name="pPersName" select="$pPersName" />
                                    <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
                                    <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
                                </xsl:call-template>
                                <xsl:text>].</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="tParseName2">
                                    <xsl:with-param name="pNameType">person</xsl:with-param>
                                    <xsl:with-param name="pPersName" select="$pPersName" />
                                    <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
                                    <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
                                </xsl:call-template>
                                <xsl:text />
                                <xsl:call-template name="tParseName2">
                                    <xsl:with-param name="pNameType">person</xsl:with-param>
                                    <xsl:with-param name="pPersName" select="$pPersName" />
                                    <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
                                    <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
                                </xsl:call-template>
                                <xsl:text>].</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>
        <xsl:if test="$pNameType='corporate'">
            <xsl:if test="$pCorpName!=''">
                <xsl:choose>
                    <xsl:when test="contains($pCorpName,'(')">
                        <xsl:value-of select="concat($pDiscServ,translate(normalize-space(substring-before($pCorpName,' (')),',. ','+++'))" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($pCorpName,',')">
                                <xsl:value-of select="concat($pDiscServ,translate($pCorpName,',. ','+++'))" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat($pDiscServ,translate($pCorpName,' ','+'))" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text />
                <xsl:call-template name="tParseName2">
                    <xsl:with-param name="pNameType">corporate</xsl:with-param>
                    <xsl:with-param name="pCorpName" select="$pCorpName" />
                </xsl:call-template>
                <xsl:text>].</xsl:text>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <!-- Template for parsing names and dates of main entity. -->
    <xsl:template name="tNameDateParser">
        <xsl:param name="pBirthYr" />
        <xsl:param name="pDeathYr" />
        <xsl:param name="pCheckInfo" />
        <xsl:choose>
            <!-- If there are existDates... -->
            <xsl:when test="eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates">
                <xsl:choose>
                    <xsl:when test="$pBirthYr='true' and $pCheckInfo='false'">
                        <!-- Output the birth year, if exists. -->
                        <xsl:choose>
                            <xsl:when test="contains(eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates/eac:dateRange/eac:fromDate,',')">
                                <xsl:value-of select="normalize-space(substring-after(eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates/eac:dateRange/eac:fromDate,','))" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates/eac:dateRange/eac:fromDate)" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$pDeathYr='true' and $pCheckInfo='false'">
                        <xsl:choose>
                            <xsl:when test="contains(eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates/eac:dateRange/eac:toDate,',')">
                                <xsl:value-of select="normalize-space(substring-after(eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates/eac:dateRange/eac:toDate,','))" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates/eac:dateRange/eac:toDate)" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$pBirthYr='true' and $pCheckInfo='true'">
                                <!-- Output the birth year, if exists. -->
                                <xsl:value-of select="normalize-space(eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates/eac:dateRange/eac:fromDate)" />
                            </xsl:when>
                            <xsl:when test="$pDeathYr='true' and $pCheckInfo='true'">
                                <xsl:value-of select="normalize-space(eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates/eac:dateRange/eac:toDate)" />
                            </xsl:when>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <!-- If the first nameEntry does not contain a date... -->
                <!-- ... try the second nameEntry, from VIAF... -->
                <xsl:if test="eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part">
                    <xsl:if test="string-length(translate(normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part),concat($vAlpha,$vCommaSpace),''))&gt;=4">
                        <xsl:if test="$pBirthYr='true'">
                            <!-- Output the birth year, if exists. -->
                            <xsl:choose>
                                <xsl:when test="normalize-space(substring-after(substring-after(substring-before(normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part),'-'),', '),', '))">
                                    <xsl:if test="string-length(translate(substring-before(normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part),'-'),$vDigits,''))&lt;string-length(substring-before(normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part),'-'))">
                                        <xsl:value-of select="normalize-space(substring-after(substring-after(substring-before(normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part),'-'),', '),', '))" />
                                    </xsl:if>
                                </xsl:when>
                                <xsl:when test="normalize-space(substring-after(substring-after(substring-before(normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part),'-'),', '),' '))">
                                    <xsl:if test="string-length(translate(substring-before(normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part),'-'),$vDigits,''))&lt;string-length(substring-before(normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part),'-'))">
                                        <xsl:value-of select="normalize-space(substring-after(substring-after(substring-before(normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part),'-'),', '),' '))" />
                                    </xsl:if>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:if>
                        <xsl:if test="$pDeathYr='true'">
                            <!-- Output the death year, if exists. -->
                            <xsl:if test="substring-after(normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part),'-')">
                                <xsl:value-of select="normalize-space(substring-after(normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part),'-'))" />
                            </xsl:if>
                        </xsl:if>
                    </xsl:if>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>