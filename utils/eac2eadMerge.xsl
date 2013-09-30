<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!--
        Author: Timothy A. Thompson
        University of Miami Libraries
        Copyright 2013 University of Miami. Licensed under the Educational Community License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://opensource.org/licenses/ECL-2.0 http://www.osedu.org/licenses/ECL-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
    -->

    <!--
        eac2eadMerge.xsl merges a set of Archon-exported EAD and EAC-CPF files as part of a separate preprocessing stage prior to import into RAMP.
        To utilize this stylesheet, EAD and EAC-CPF files must first be renamed using the eadRename.sh and eac2eadMatch.sh scripts, respectively.
        As its input XML file, this stylesheet expects a list of EAC-CPF files generated using eacFileListGenerator.xsl. 
    -->

    <!-- Declare the directories for EAC-CPF and EAD files once they have been renamed. -->
    <xsl:param name="eacDir">eac/</xsl:param>
    <xsl:param name="eadDir">ead/</xsl:param>

    <!-- Read in the EAC-CPF files and group and parse the data needed to match them with their related EADs.  -->
    <xsl:variable name="eacGroup">
        <xsl:for-each select="/creators/eac">
            <xsl:variable name="eac" select="document(@filename)"
                xpath-default-namespace="urn:isbn:1-931666-33-4"/>
            <xsl:for-each-group select="$eac/eac-cpf/cpfDescription/identity/nameEntry[1]/part"
                group-by="substring-after(substring-before(document-uri($eac),'_'),$eacDir)"
                xpath-default-namespace="urn:isbn:1-931666-33-4">
                <eac>
                    <name>
                        <xsl:value-of select="normalize-space(current-group())"/>
                    </name>
                    <id>
                        <xsl:value-of select="normalize-space(current-grouping-key())"/>
                    </id>
                    <eac>
                        <xsl:value-of select="substring-after(document-uri($eac),$eacDir)"/>
                    </eac>
                    <ead>
                        <xsl:value-of select="substring-after(document-uri($eac),'_')"/>
                    </ead>
                </eac>
            </xsl:for-each-group>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template match="/">
        <merge>
            <!-- Group the EAC files by entity name. -->
            <xsl:for-each-group select="$eacGroup/eac/id" group-by="preceding-sibling::name">
                <xsl:sort select="translate(current-grouping-key(),'ÁÉÍÓÚáéíóúÜú','AEIUOaeiouUu')"
                    data-type="text"/>
                <xsl:variable name="eacId" select="."/>
                <xsl:variable name="eacName" select="current-grouping-key()"/>
                <!-- Store the EAD references -->
                <xsl:variable name="eadRef">
                    <xsl:for-each select="current-group()/following-sibling::eac">
                        <xsl:choose>
                            <xsl:when test="position()!=last()">
                                <xsl:value-of
                                    select="concat(substring-before(substring-after(.,'_'),'.'),'_')"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-before(substring-after(.,'_'),'.')"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="posCount" select="position()"/>
                
                <!-- Output the merged EAD files. -->
                <xsl:result-document
                    href="{concat('merged/',$eacId,'_',$eadRef,'-',$posCount,'.xml')}" indent="yes">

                    <!-- Output a fake EAD wrapper element for the merged EAD files. -->
                    <ead audience="external" xmlns="urn:isbn:1-931666-22-9"
                        xmlns:xlink="http://www.w3.org/1999/xlink"
                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                        xsi:schemaLocation="http://www.loc.gov/ead/ http://www.loc.gov/ead/ead.xsd">

                        <!-- Build the EAD files. -->
                        <xsl:for-each select="current-group()/following-sibling::ead">

                            <ead audience="external" xmlns="urn:isbn:1-931666-22-9"
                                xmlns:xlink="http://www.w3.org/1999/xlink"
                                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                                xsi:schemaLocation="http://www.loc.gov/ead/ http://www.loc.gov/ead/ead.xsd">
                                <xsl:variable name="eadVal"
                                    select="document(concat($eadDir,normalize-space(.)))"
                                    xpath-default-namespace="urn:isbn:1-931666-22-9"/>
                                <xsl:copy-of select="$eadVal/ead/eadheader"
                                    xpath-default-namespace="urn:isbn:1-931666-22-9"/>
                                <xsl:copy-of select="$eadVal/ead/frontmatter"
                                    xpath-default-namespace="urn:isbn:1-931666-22-9"/>
                                <archdesc level="collection" type="inventory" audience="external"
                                    relatedencoding="MARC21">
                                    <did>
                                        <xsl:copy-of select="$eadVal/ead/archdesc/did/head"
                                            xpath-default-namespace="urn:isbn:1-931666-22-9"/>
                                        <xsl:copy-of select="$eadVal/ead/archdesc/did/unittitle"
                                            xpath-default-namespace="urn:isbn:1-931666-22-9"/>
                                        <xsl:copy-of select="$eadVal/ead/archdesc/did/unitid"
                                            xpath-default-namespace="urn:isbn:1-931666-22-9"/>
                                        <origination label="Creator" encodinganalog="245$c">
                                            <xsl:for-each
                                                select="$eadVal/ead/archdesc/did/origination/child::node()/@normal[.=$eacName]"
                                                xpath-default-namespace="urn:isbn:1-931666-22-9">
                                                <xsl:copy-of select="parent::node()"/>
                                            </xsl:for-each>
                                            <xsl:for-each
                                                select="$eadVal/ead/archdesc/did/origination/child::node()/@normal[.!=$eacName]"
                                                xpath-default-namespace="urn:isbn:1-931666-22-9">
                                                <xsl:copy-of select="parent::node()"/>
                                            </xsl:for-each>
                                        </origination>
                                        <xsl:for-each
                                            select="$eadVal/ead/archdesc/did/origination/following-sibling::node()"
                                            xpath-default-namespace="urn:isbn:1-931666-22-9">
                                            <xsl:copy-of select="."/>
                                        </xsl:for-each>
                                    </did>
                                    <xsl:choose>
                                        <xsl:when
                                            test="not($eadVal/ead/archdesc/bioghist) or $eadVal/ead/archdesc/bioghist = ''"
                                            xpath-default-namespace="urn:isbn:1-931666-22-9">
                                            <bioghist>
                                                <head>Biographical Information:</head>
                                                <p/>
                                            </bioghist>
                                            <xsl:for-each
                                                select="$eadVal/ead/archdesc/did/following-sibling::node()"
                                                xpath-default-namespace="urn:isbn:1-931666-22-9">
                                                <xsl:copy-of select="."/>
                                            </xsl:for-each>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <bioghist>
                                                <xsl:attribute name="altrender"
                                                  select="$eadVal/ead/archdesc/bioghist/@altrender"
                                                  xpath-default-namespace="urn:isbn:1-931666-22-9"/>
                                                <xsl:attribute name="encodinganalog"
                                                  select="$eadVal/ead/archdesc/bioghist/@encodinganalog"
                                                  xpath-default-namespace="urn:isbn:1-931666-22-9"/>
                                                <xsl:for-each
                                                  select="current-group()/following-sibling::eac">
                                                  <xsl:if test="position()=1">
                                                  <xsl:for-each
                                                  select="document(concat($eacDir,normalize-space(.)))/eac-cpf/cpfDescription/description/biogHist/p"
                                                  xpath-default-namespace="urn:isbn:1-931666-33-4">
                                                  <p>
                                                  <xsl:value-of select="normalize-space(.)"/>
                                                  </p>
                                                  </xsl:for-each>
                                                  </xsl:if>
                                                </xsl:for-each>
                                            </bioghist>
                                            <xsl:for-each
                                                select="$eadVal/ead/archdesc/bioghist/following-sibling::node()"
                                                xpath-default-namespace="urn:isbn:1-931666-22-9">
                                                <xsl:copy-of select="."/>
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </archdesc>
                            </ead>
                        </xsl:for-each>
                    </ead>
                </xsl:result-document>
                
                <!-- Report the number of files processed. -->
                <xsl:if test="position()=last()">
                    <xsl:text>Processed </xsl:text>
                    <xsl:value-of select="$posCount"/>
                    <xsl:text> files.</xsl:text>
                </xsl:if>
            </xsl:for-each-group>
        </merge>
    </xsl:template>
</xsl:stylesheet>
