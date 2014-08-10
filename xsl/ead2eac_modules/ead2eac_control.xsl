<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eac="urn:isbn:1-931666-33-4"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings" xmlns:xlink="http://www.w3.org/1999/xlink"
    extension-element-prefixes="exsl str" exclude-result-prefixes="eac ead" version="1.0"> 

    <xsl:import href="ead2eac_sources.xsl"/>    
    
    <!-- Process top-level control element. -->   
    <xsl:template name="tControl">        
        <control xmlns="urn:isbn:1-931666-33-4">            
            <xsl:call-template name="tRecId"/>               
            <xsl:call-template name="tOtherRecId"/>            
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
            <!-- Include any convention declarations deemed necessary. -->            
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
                    <!-- If it's an ingested record (not created from within RAMP). -->                    
                    <xsl:choose>                        
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
                    <!-- Declare the transformation engine. -->                    
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
            <!-- Call template from sources.xsl to include source EAD reference and snippet. -->            
            <xsl:call-template name="tSources" />            
        </control>        
    </xsl:template>   
    
    <!-- Generic eac:recordId template; overridden by IDs.xsl. -->    
    <xsl:template name="tRecId">        
        <recordId xmlns="urn:isbn:1-931666-33-4">
            <xsl:apply-templates select="ead:ead/ead:eadheader/ead:eadid"/>
            <xsl:apply-templates select="ead:ead/ead:eadheader/ead:eadid/@identifier"/>                
        </recordId>        
    </xsl:template>

</xsl:stylesheet>
