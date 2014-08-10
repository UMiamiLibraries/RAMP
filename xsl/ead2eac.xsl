<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:eac="urn:isbn:1-931666-33-4"
    xmlns:ead="urn:isbn:1-931666-22-9" 
    xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    extension-element-prefixes="exsl str" exclude-result-prefixes="eac ead" version="1.0">
    <!--
        Author: Timothy A. Thompson
        University of Miami Libraries
        Copyright 2013 University of Miami. Licensed under the Educational Community License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://opensource.org/licenses/ECL-2.0 http://www.osedu.org/licenses/ECL-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
    -->
    <!--
        ead2eac.xsl creates EAC-CPF/XML from EAD/XML finding aids. 
    -->

    <!-- Import and include modules. -->
    <xsl:import href="ead2eac_modules/ead2eac_params.xsl"/>
    <xsl:import href="ead2eac_modules/ead2eac_new_records.xsl"/>
    <xsl:import href="ead2eac_modules/ead2eac_control.xsl"/>
    <xsl:import href="ead2eac_modules/ead2eac_IDs.xsl"/>

    <xsl:include href="ead2eac_modules/ead2eac_utils.xsl"/>
    <xsl:include href="ead2eac_modules/ead2eac_names.xsl"/>
    <xsl:include href="ead2eac_modules/ead2eac_citations.xsl"/>
    <xsl:include href="ead2eac_modules/ead2eac_cpf_description.xsl"/>
    <xsl:include href="ead2eac_modules/ead2eac_control_access.xsl"/>

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- Call the top-level templates. -->
    <xsl:template match="/">
        <xsl:choose>
            <!-- If an existing EAC-CPF record, copy it as-is. -->
            <xsl:when test="/eac:eac-cpf">
                <xsl:copy-of select="@*|node()"/>
            </xsl:when>
            <!-- Case to accommodate local merged EADs, which contain faux EAD wrapper elements. -->
            <xsl:when test="/ead:ead/ead:ead">
                <xsl:for-each select="ead:ead">
                    <eac-cpf xmlns="urn:isbn:1-931666-33-4"
                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                        xsi:schemaLocation="urn:isbn:1-931666-33-4 http://eac.staatsbibliothek-berlin.de/schema/cpf.xsd"
                        xmlns:xlink="http://www.w3.org/1999/xlink">
                        <xsl:call-template name="tControl"/>
                        <xsl:call-template name="tCpfDescription"/>
                    </eac-cpf>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <eac-cpf xmlns="urn:isbn:1-931666-33-4"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xsi:schemaLocation="urn:isbn:1-931666-33-4 http://eac.staatsbibliothek-berlin.de/schema/cpf.xsd"
                    xmlns:xlink="http://www.w3.org/1999/xlink">
                    <xsl:call-template name="tControl"/>
                    <xsl:call-template name="tCpfDescription"/>
                </eac-cpf>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Process mixed-content elements. -->    
    <xsl:template match="ead:abstract">
        <abstract xmlns="urn:isbn:1-931666-33-4">
            <xsl:value-of select="normalize-space(.)"/>
        </abstract>
    </xsl:template>

    <xsl:template match="ead:bioghist/text()">
        <p xmlns="urn:isbn:1-931666-33-4">
            <xsl:value-of select="normalize-space(.)"/>
        </p>
    </xsl:template>

    <xsl:template match="ead:emph">
        <span xmlns="urn:isbn:1-931666-33-4">
            <xsl:attribute name="style">font-style:italic</xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </span>
    </xsl:template>

    <xsl:template match="ead:item">
        <item xmlns="urn:isbn:1-931666-33-4">
            <xsl:value-of select="normalize-space(.)"/>
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
            <xsl:value-of select="normalize-space(.)"/>
        </span>
    </xsl:template>

</xsl:stylesheet>
