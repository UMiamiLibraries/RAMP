<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eac="urn:isbn:1-931666-33-4"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings" xmlns:xlink="http://www.w3.org/1999/xlink"
    extension-element-prefixes="exsl str" exclude-result-prefixes="eac ead" version="1.0"> 

    <!-- Process relation elements. -->
    <xsl:template name="tRelations">
        <relations xmlns="urn:isbn:1-931666-33-4">
            <!-- Turn associated creators into cpfRelation elements. -->
            <xsl:variable name="vFirstNode" select="ead:ead/ead:archdesc/ead:did/ead:origination[not(contains(@id,'RAMP'))]/child::node()[1]
                | ead:ead/ead:archdesc/ead:controlaccess/child::node()[1][contains(@role,'Collector')]" />
            <xsl:for-each select="$vFirstNode">
                <xsl:if test="following-sibling::node()[not(@encodinganalog='100_0') and not(@encodinganalog='100_1')]">
                    <xsl:for-each select="following-sibling::node()[. != $vFirstNode]">
                        <xsl:variable name="vEntType" select="local-name(.)" />
                        <xsl:variable name="vCpfRel" select="@normal" />
                        <xsl:if test="$vEntType = 'persname'">
                            <cpfRelation cpfRelationType="associative" xlink:role="http://rdvocab.info/uri/schema/FRBRentitiesRDA/Person" xlink:type="simple">                                
                                <relationEntry>
                                    <xsl:value-of select="normalize-space(.)" />
                                </relationEntry>
                                <!-- Assign record IDs based on ID from EAD. -->
                                <descriptiveNote>
                                    <p>
                                        <xsl:text>recordId:</xsl:text>
                                        <xsl:choose>
                                            <xsl:when test="contains(../../../../ead:eadheader/ead:eadid,'/')">
                                                <xsl:value-of select="substring-after(../../../../ead:eadheader/ead:eadid,'/')" />                                                
                                                <xsl:value-of select="concat('.',substring-after(../../../../ead:eadheader/ead:eadid/@identifier,':'))" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="../../../../ead:eadheader/ead:eadid" />                                                
                                                <xsl:value-of select="concat('.',substring-after(../../../../ead:eadheader/ead:eadid/@identifier,':'))" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:for-each select="following-sibling::ead:name">
                                            <xsl:variable name="vCpfId" select="@id" />
                                            <xsl:if test=". = $vCpfRel">
                                                <xsl:value-of select="concat('.',@id)" />
                                            </xsl:if>
                                        </xsl:for-each>
                                    </p>
                                </descriptiveNote>
                            </cpfRelation>
                        </xsl:if>
                        <xsl:if test="$vEntType = 'corpname'">
                            <cpfRelation cpfRelationType="associative" xlink:role="http://rdvocab.info/uri/schema/FRBRentitiesRDA/CorporateBody" xlink:type="simple">
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
                                            <xsl:if test=". = $vCpfRel">
                                                <xsl:value-of select="concat('.',@id)" />
                                            </xsl:if>
                                        </xsl:for-each>
                                    </p>
                                </descriptiveNote>
                            </cpfRelation>
                        </xsl:if>
                        <xsl:if test="$vEntType = 'famname'">
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
                                            <xsl:if test=". = $vCpfRel">
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
            <!-- De-dupe name elements. -->
            <xsl:for-each select="exsl:node-set($vCpfName)/persName[not(.=preceding-sibling::persName)][not(starts-with(substring-before(.,','),substring-before($vFirstNode,',')))]">                
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
            
            <!-- Call template for RAMP-created records. -->
            <xsl:call-template name="tCpfs" />
            
            <!-- For local archival collections, output EAD snippet in objectXMLWrap. -->
            <xsl:for-each select="ead:ead/ead:archdesc/ead:did/ead:unittitle[. != '']">
                <resourceRelation resourceRelationType="creatorOf">
                    <xsl:attribute name="xlink:href">
                        <xsl:choose>
                            <xsl:when test="contains(../../../ead:eadheader/ead:eadid/@identifier,'Archon')">
                                <xsl:value-of select="concat($pLocalURL,substring-after(../../../ead:eadheader/ead:eadid/@identifier,':'))"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(../../../ead:eadheader/ead:eadid)"/>
                            </xsl:otherwise>                        	            
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="xlink:role">
                        <xsl:value-of select="'archivalRecords'"/>
                    </xsl:attribute>
                    <xsl:attribute name="xlink:type">
                        <xsl:value-of select="'simple'"/>
                    </xsl:attribute>
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
                                <xsl:if test=".  !=  ' ' ">
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
            
            <!-- Call template for RAMP-created records. -->
            <xsl:call-template name="tResources" />
            
            <!-- The following represents different attempts to account for variations in local formatting/data entry for ead:relatedmaterial elements. -->
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
    
    <!-- Template for RAMP-created records. -->
    <xsl:template name="tCpfs">
        <xsl:if test="$vCpf != ''">
            <xsl:for-each select="$vCpf[. != '']">
                <xsl:variable name="vCpfLabel" select="../@label" />            	
                <cpfRelation xmlns="urn:isbn:1-931666-33-4">            		
                    <xsl:if test="../following-sibling::ead:note[@type='cpfType'][@label=$vCpfLabel]/ead:p != ''">
                        <xsl:attribute name="cpfRelationType">
                            <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='cpfType'][@label=$vCpfLabel]/ead:p)"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="../following-sibling::ead:note[@type='cpfID'][@label=$vCpfLabel]/ead:p != ''">
                        <xsl:attribute name="xml:id">
                            <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='cpfID'][@label=$vCpfLabel]/ead:p)"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="../following-sibling::ead:note[@type='cpfURI'][@label=$vCpfLabel]/ead:p != ''">
                        <xsl:attribute name="xlink:href">
                            <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='cpfURI'][@label=$vCpfLabel]/ead:p)"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="../following-sibling::ead:note[@type='cpfRole'][@label=$vCpfLabel]/ead:p != ''">
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
                    <xsl:if test="../following-sibling::ead:note[@type='cpfNote'][@label=$vCpfLabel]/ead:p != ''">
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
    
    <!-- Template for RAMP-created records. -->
    <xsl:template name="tResources">
        <xsl:if test="$vResource != ''">
            <xsl:for-each select="$vResource[. != '']">
                <xsl:variable name="vResourceLabel" select="../@label" />            	
                <xsl:choose>
                    <xsl:when test="normalize-space(../following-sibling::ead:note[@type='resourceCreator'][@label=$vResourceLabel]/ead:p) != ''">
                        <resourceRelation xmlns="urn:isbn:1-931666-33-4">            				
                            <xsl:if test="../following-sibling::ead:note[@type='resourceType'][@label=$vResourceLabel]/ead:p != ''">
                                <xsl:attribute name="resourceRelationType">
                                    <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='resourceType'][@label=$vResourceLabel]/ead:p)"/>
                                </xsl:attribute>		
                            </xsl:if>
                            <xsl:if test="../following-sibling::ead:note[@type='resourceID'][@label=$vResourceLabel]/ead:p != ''">
                                <xsl:attribute name="xml:id">
                                    <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='resourceID'][@label=$vResourceLabel]/ead:p)"/>
                                </xsl:attribute>		
                            </xsl:if>
                            <xsl:if test="../following-sibling::ead:note[@type='resourceURI'][@label=$vResourceLabel]/ead:p != ''">
                                <xsl:attribute name="xlink:href">
                                    <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='resourceURI'][@label=$vResourceLabel]/ead:p)"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="../following-sibling::ead:note[@type='resourceRole'][@label=$vResourceLabel]/ead:p != ''">
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
                            <xsl:if test="../following-sibling::ead:note[@type='resourceNote'][@label=$vResourceLabel]/ead:p != ''">
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
                            <xsl:if test="../following-sibling::ead:note[@type='resourceType'][@label=$vResourceLabel]/ead:p != ''">
                                <xsl:attribute name="resourceRelationType">
                                    <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='resourceType'][@label=$vResourceLabel]/ead:p)"/>
                                </xsl:attribute>		
                            </xsl:if>
                            <xsl:if test="../following-sibling::ead:note[@type='resourceID'][@label=$vResourceLabel]/ead:p != ''">
                                <xsl:attribute name="xml:id">
                                    <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='resourceID'][@label=$vResourceLabel]/ead:p)"/>
                                </xsl:attribute>		
                            </xsl:if>
                            <xsl:if test="../following-sibling::ead:note[@type='resourceURI'][@label=$vResourceLabel]/ead:p != ''">
                                <xsl:attribute name="xlink:href">
                                    <xsl:value-of select="normalize-space(../following-sibling::ead:note[@type='resourceURI'][@label=$vResourceLabel]/ead:p)"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="../following-sibling::ead:note[@type='resourceRole'][@label=$vResourceLabel]/ead:p != ''">
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
                                    <xsl:when test="//ead:origination/child::node()[2][@encodinganalog='100_1'] != ''">
                                        <relationEntry localType="creator">
                                            <xsl:value-of select="normalize-space(//ead:origination/child::node()[2][@encodinganalog='100_1'])" />
                                            <xsl:if test="//ead:origination/child::node()[3][@encodinganalog='100_0'] != ''">
                                                <xsl:text>, </xsl:text>
                                                <xsl:value-of select="normalize-space(//ead:origination/child::node()[3][@encodinganalog='100_0'])" />
                                            </xsl:if>
                                        </relationEntry>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:choose>
                                            <xsl:when test="//ead:origination/child::node()[3][@encodinganalog='100_0'] != ''">
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
                            <xsl:if test="../following-sibling::ead:note[@type='resourceNote'][@label=$vResourceLabel]/ead:p != ''">
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

</xsl:stylesheet>
