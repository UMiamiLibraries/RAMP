<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:eac="urn:isbn:1-931666-33-4" 
    xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns:library="http://purl.org/library/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:schema="http://schema.org/"
    xmlns:exsl="http://exslt.org/common" 
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    extension-element-prefixes="exsl" exclude-result-prefixes="eac" version="1.0">
    
    <!-- Output "Works or publications" ("works by") section. -->
    <xsl:template name="tPub">
        <xsl:text>&#10;</xsl:text>
        <xsl:text>==Works or publications==</xsl:text>
        <xsl:text>&#10;</xsl:text>    
        <!-- Check for works by the person or corporate body. -->
        <xsl:for-each select="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation[@resourceRelationType='creatorOf' and @xlink:role='resource' and not(eac:relationEntry[@localType='mix'])]">
            <xsl:sort select="translate(eac:relationEntry[1],'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
            <xsl:variable name="vStrLen" select="string-length(eac:relationEntry[1])" />
            <xsl:text>* </xsl:text>
            <!-- Most things will be books... -->
            <!--
            <xsl:choose>
                <xsl:when test="eac:relationEntry[1]/@localType='book'">
                	<xsl:text>{{cite book</xsl:text>
                	<xsl:text>&#10;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                	<xsl:text>{{Citation</xsl:text>
                	<xsl:text>&#10;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            -->                        
            <xsl:text>{{Citation</xsl:text>
            <xsl:text>&#10;</xsl:text>            
            <xsl:choose>
                <xsl:when test="contains(@xlink:href,'q=kw') or not(document(concat(@xlink:href,'.rdf'))/rdf:RDF)">
                    <xsl:for-each select="following-sibling::eac:relationEntry[@localType='creator']">                    	
                        <xsl:choose>
                            <xsl:when test="contains(.,', ')">
                                <xsl:if test="not(contains(.,substring-before(//eac:nameEntry/eac:part[1],', ')))">
                                    <xsl:text>| last = </xsl:text>
                                    <xsl:value-of select="normalize-space(substring-before(.,', '))"/>
                                    <xsl:text>&#10;</xsl:text>
                                    <xsl:text>| first = </xsl:text>
                                    <xsl:value-of select="normalize-space(substring-after(.,', '))"/>
                                    <xsl:text>&#10;</xsl:text>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="not(contains(.,//eac:nameEntry/eac:part[1]))">                						                					
                                    <xsl:text>| author = </xsl:text>
                                    <xsl:value-of select="normalize-space(.)"/>
                                    <xsl:text>&#10;</xsl:text>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>                					
                    </xsl:for-each>
                    <xsl:text>| title = </xsl:text>
                    <xsl:choose>
                        <!-- Rough matching to filter for Spanish and Portuguese titles. Needs work for internationalization and smarter switching between title and sentence case. -->
                        <xsl:when test="contains(eac:relationEntry[1],' ao ')
                            or contains(eac:relationEntry[1],' com ')
                            or contains(eac:relationEntry[1],' con ')
                            or contains(eac:relationEntry[1],' da ')
                            or contains(eac:relationEntry[1],' das ')
                            or contains(eac:relationEntry[1],' de ')
                            or contains(eac:relationEntry[1],' dos ')
                            or contains(eac:relationEntry[1],' e ')
                            or contains(eac:relationEntry[1],' en ')
                            or contains(eac:relationEntry[1],' em ')
                            or contains(eac:relationEntry[1],' para ')
                            or contains(eac:relationEntry[1],' pela ')
                            or contains(eac:relationEntry[1],' pelo ')
                            or contains(eac:relationEntry[1],' por ')
                            or contains(eac:relationEntry[1],' y ')">
                            <xsl:value-of select="normalize-space(eac:relationEntry[1])"/>
                        </xsl:when>
                        <xsl:otherwise>                                
                            <xsl:call-template name="tTitleCaps">
                                <xsl:with-param name="pTitles" select="normalize-space(.)"/>
                            </xsl:call-template>                                                                                            
                        </xsl:otherwise>                                                                        
                    </xsl:choose>                    	                    	
                    <xsl:text>&#10;</xsl:text>                             
                    <xsl:if test="eac:relationEntry[@localType='pubPlace']">
                        <xsl:text>| publication-place = </xsl:text>
                        <xsl:value-of select="normalize-space(eac:relationEntry[@localType='pubPlace'])"/>
                        <xsl:text>&#10;</xsl:text>
                    </xsl:if>                        
                    <xsl:if test="eac:relationEntry[@localType='publisher']">
                        <xsl:text>| publisher = </xsl:text>
                        <xsl:value-of select="normalize-space(eac:relationEntry[@localType='publisher'])"/>
                        <xsl:text>&#10;</xsl:text>    
                    </xsl:if>                        
                    <xsl:if test="eac:relationEntry[@localType='pubDate']">
                        <xsl:text>| publication-date = </xsl:text>
                        <xsl:value-of select="normalize-space(eac:relationEntry[@localType='pubDate'])"/>
                        <xsl:text>&#10;</xsl:text>
                    </xsl:if>                                                                        
                    <xsl:if test="contains(@xlink:href,'q=kw')">
                        <xsl:text>| url = </xsl:text>
                        <xsl:value-of select="normalize-space(@xlink:href)"/>
                        <xsl:text>&#10;</xsl:text>
                    </xsl:if>                    
                    <xsl:choose>
                        <xsl:when test="contains(@xlink:href,'oclc/') and eac:relationEntry[@localType='isbn']">
                            <xsl:text>| oclc = </xsl:text>
                            <xsl:value-of select="substring-after(@xlink:href,'oclc/')" />
                            <xsl:text>&#10;</xsl:text>
                            <xsl:text>| isbn = </xsl:text>
                            <xsl:value-of select="eac:relationEntry[@localType='isbn']" />
                            <xsl:text>&#10;</xsl:text>
                        </xsl:when>
                        <xsl:when test="contains(@xlink:href,'oclc/') and not(eac:relationEntry[@localType='isbn'])">
                            <xsl:text>| oclc = </xsl:text>
                            <xsl:value-of select="substring-after(@xlink:href,'oclc/')" />
                            <xsl:text>&#10;</xsl:text>                            
                        </xsl:when>
                        <xsl:when test="eac:relationEntry[@localType='isbn'] and not(contains(@xlink:href,'oclc/'))">
                            <xsl:text>| isbn </xsl:text>
                            <xsl:value-of select="eac:relationEntry[@localType='isbn']" />
                            <xsl:text>&#10;</xsl:text>
                        </xsl:when>
                        <xsl:otherwise />
                    </xsl:choose>                    
                    <xsl:text>| separator = .</xsl:text>
                    <xsl:text>&#10;</xsl:text>                                
                </xsl:when>
                <xsl:otherwise>                                
                    <xsl:call-template name="tFetchXml">
                        <xsl:with-param name="oclc" select="substring-after(@xlink:href,'oclc/')"/>
                        <xsl:with-param name="isbn" select="following-sibling::eac:relationEntry[@localType='isbn']"/>
                        <xsl:with-param name="pWorldCatUrl" select="@xlink:href"/>     
                        <xsl:with-param name="pWorksBy">true</xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
                                                          
            <!-- Work on parsing references from Archon...
            <xsl:choose>
                <xsl:when test="substring(eac:relationEntry[1],$vStrLen)='.'">
                    <xsl:variable name="vTitleVal" select="substring(eac:relationEntry[1],1,$vStrLen -1)" />
                    <xsl:text>| title = </xsl:text>
                    <xsl:value-of select="substring-before($vTitleVal,' . ')" />
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="substring-after($vTitleVal,' . ')" />
                    <xsl:text>&#10;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>| title = </xsl:text>
                    <xsl:value-of select="normalize-space(eac:relationEntry[1])" />
                    <xsl:text>&#10;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            -->
            <xsl:text>}} </xsl:text>            
            <xsl:choose>
                <xsl:when test="eac:descriptiveNote/eac:p">                    
                    <xsl:text> &lt;!-- </xsl:text>
                    <xsl:for-each select="eac:descriptiveNote/eac:p">
                        <xsl:apply-templates select="."/>
                        <xsl:choose>
                            <xsl:when test="position() != last()">
                                <xsl:text>&#10;</xsl:text>
                                <xsl:text>&#10;</xsl:text>
                            </xsl:when>
                            <xsl:otherwise />
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:text>. --&gt;</xsl:text>
                    <xsl:choose>
                        <xsl:when test="position() != last()">
                            <xsl:text>&#10;</xsl:text>
                            <xsl:text>&#10;</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>&#10;</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>                  
                </xsl:when>   
                <xsl:otherwise>
                    <xsl:text>&#10;</xsl:text>        
                </xsl:otherwise>
            </xsl:choose> 
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>