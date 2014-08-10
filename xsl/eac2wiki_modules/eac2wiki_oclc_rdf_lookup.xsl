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
    
    <!-- Key for processing external XML lookups. -->
    <xsl:key name="kLookupAbout" match="rdf:RDF/rdf:Description" use="attribute::*" />   
    
    <xsl:template name="tFetchXml">
        <xsl:param name="pWorldCatUrl"/>
        <xsl:param name="pWorksBy"/>       
        <xsl:param name="pWorksAbout"/> 
        <xsl:param name="oclc"/>
        <xsl:param name="isbn"/>
        <xsl:for-each select="document(concat($pWorldCatUrl,'.rdf'))/rdf:RDF/rdf:Description[@rdf:about=$pWorldCatUrl]">
            <xsl:variable name="vAuthCount" select="count(schema:author)"/>
            <xsl:variable name="vContribCount" select="count(schema:contributor)"/>
            <xsl:choose>                
                <xsl:when test="$pWorksBy='true'">
                    <xsl:if test="$vAuthCount&gt;1 or schema:contributor">
                        <xsl:for-each select="schema:author">                       
                            <xsl:variable name="vPosCount" select="position()"/>
                            <xsl:text>| author</xsl:text>     
                            <xsl:if test="$vAuthCount+$vContribCount&gt;1">
                                <xsl:value-of select="$vPosCount"/>
                            </xsl:if>
                            <xsl:text> = </xsl:text>
                            <xsl:variable name="vAuthName" select="key('kLookupAbout',@rdf:resource|@rdf:nodeID)/rdfs:label|key('kLookupAbout',@rdf:resource|@rdf:nodeID)/schema:name"/>
                            <xsl:choose>
                                <xsl:when test="substring($vAuthName,string-length($vAuthName))=','">                                    
                                    <xsl:value-of select="substring($vAuthName,1,string-length($vAuthName)-1)"/>                                        
                                </xsl:when>
                                <xsl:when test="substring(normalize-space($vAuthName),string-length(normalize-space($vAuthName)))='.'">
                                    <xsl:choose>
                                        <xsl:when test="contains(substring($vAuthName,string-length($vAuthName)-2),' ')">                                                
                                            <xsl:value-of select="$vAuthName"/>                                                
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="substring($vAuthName,1,string-length($vAuthName)-1)"/>        
                                        </xsl:otherwise>
                                    </xsl:choose>                                        
                                </xsl:when>                                                                                                                                              
                                <xsl:otherwise>
                                    <xsl:value-of select="$vAuthName"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:text>&#10;</xsl:text>                   
                        </xsl:for-each>       
                        <xsl:if test="$vAuthCount&gt;=1 or $vContribCount&gt;=1">
                            <xsl:for-each select="schema:contributor">  
                                <xsl:variable name="vPosCount" select="position()+$vAuthCount"/>
                                <xsl:text>| author</xsl:text>
                                <xsl:if test="$vAuthCount+$vContribCount&gt;1">
                                    <xsl:value-of select="$vPosCount"/>
                                </xsl:if>
                                <xsl:text> = </xsl:text>
                                <xsl:variable name="vAuthName" select="key('kLookupAbout',@rdf:resource|@rdf:nodeID)/rdfs:label|key('kLookupAbout',@rdf:resource|@rdf:nodeID)/schema:name"/>
                                <xsl:choose>
                                    <xsl:when test="substring($vAuthName,string-length($vAuthName))=','">                                    
                                        <xsl:value-of select="substring($vAuthName,1,string-length($vAuthName)-1)"/>                                        
                                    </xsl:when>
                                    <xsl:when test="substring(normalize-space($vAuthName),string-length(normalize-space($vAuthName)))='.'">
                                        <xsl:choose>
                                            <xsl:when test="contains(substring($vAuthName,string-length($vAuthName)-2),' ')">                                                
                                                <xsl:value-of select="$vAuthName"/>                                                
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="substring($vAuthName,1,string-length($vAuthName)-1)"/>        
                                            </xsl:otherwise>
                                        </xsl:choose>                                        
                                    </xsl:when>                                                                                                                                              
                                    <xsl:otherwise>
                                        <xsl:value-of select="$vAuthName"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:text>&#10;</xsl:text>    
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="$pWorksAbout='true'">
                    <xsl:if test="$vAuthCount&gt;=1 or schema:contributor">
                        <xsl:for-each select="schema:author">                       
                            <xsl:variable name="vPosCount" select="position()"/>
                            <xsl:text>| author</xsl:text>
                            <xsl:if test="$vAuthCount+$vContribCount&gt;1">
                                <xsl:value-of select="$vPosCount"/>
                            </xsl:if>
                            <xsl:text> = </xsl:text>
                            <xsl:variable name="vAuthName" select="key('kLookupAbout',@rdf:resource|@rdf:nodeID)/rdfs:label|key('kLookupAbout',@rdf:resource|@rdf:nodeID)/schema:name"/>
                            <xsl:choose>
                                <xsl:when test="substring($vAuthName,string-length($vAuthName))=','">                                    
                                    <xsl:value-of select="substring($vAuthName,1,string-length($vAuthName)-1)"/>                                        
                                </xsl:when>
                                <xsl:when test="substring(normalize-space($vAuthName),string-length(normalize-space($vAuthName)))='.'">
                                    <xsl:choose>
                                        <xsl:when test="contains(substring($vAuthName,string-length($vAuthName)-2),' ')">                                                
                                            <xsl:value-of select="$vAuthName"/>                                                
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="substring($vAuthName,1,string-length($vAuthName)-1)"/>        
                                        </xsl:otherwise>
                                    </xsl:choose>                                        
                                </xsl:when>                                                                                                                                              
                                <xsl:otherwise>
                                    <xsl:value-of select="$vAuthName"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:text>&#10;</xsl:text>                   
                        </xsl:for-each>       
                        <xsl:if test="$vAuthCount&gt;=1 or $vContribCount&gt;=1">
                            <xsl:for-each select="schema:contributor">  
                                <xsl:variable name="vPosCount" select="position()+$vAuthCount"/>
                                <xsl:text>| author</xsl:text>
                                <xsl:if test="$vAuthCount+$vContribCount&gt;1">
                                    <xsl:value-of select="$vPosCount"/>
                                </xsl:if>
                                <xsl:text> = </xsl:text>
                                <xsl:variable name="vAuthName" select="key('kLookupAbout',@rdf:resource|@rdf:nodeID)/rdfs:label|key('kLookupAbout',@rdf:resource|@rdf:nodeID)/schema:name"/>
                                <xsl:choose>
                                    <xsl:when test="substring($vAuthName,string-length($vAuthName))=','">                                    
                                        <xsl:value-of select="substring($vAuthName,1,string-length($vAuthName)-1)"/>                                        
                                    </xsl:when>
                                    <xsl:when test="substring(normalize-space($vAuthName),string-length(normalize-space($vAuthName)))='.'">
                                        <xsl:choose>
                                            <xsl:when test="contains(substring($vAuthName,string-length($vAuthName)-2),' ')">                                                
                                                <xsl:value-of select="$vAuthName"/>                                                
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="substring($vAuthName,1,string-length($vAuthName)-1)"/>        
                                            </xsl:otherwise>
                                        </xsl:choose>                                        
                                    </xsl:when>                                                                                                                                              
                                    <xsl:otherwise>
                                        <xsl:value-of select="$vAuthName"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:text>&#10;</xsl:text>    
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>
            <xsl:text>| title = </xsl:text>                		                	                	
            <xsl:choose>
                <!-- Rough matching to filter for Spanish and Portuguese titles. Needs work for internationalization and smarter switching between title and sentence case. -->
                <xsl:when test="schema:inLanguage!='en'">
                    <xsl:value-of select="normalize-space(schema:name)"/>
                </xsl:when>
                <xsl:otherwise>                                
                    <xsl:call-template name="tTitleCaps">
                        <xsl:with-param name="pTitles">
                            <xsl:choose>
                                <xsl:when test="substring(normalize-space(schema:name),string-length(normalize-space(schema:name)))=',' or substring(normalize-space(schema:name),string-length(normalize-space(schema:name)))='.'">
                                    <xsl:value-of select="substring(normalize-space(schema:name),1,string-length(normalize-space(schema:name))-1)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(schema:name)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>                                                                                            
                </xsl:otherwise>                                                                        
            </xsl:choose>                             	
            <xsl:text>&#10;</xsl:text>                                                       
            <xsl:if test="schema:publisher">
                <xsl:text>| publisher = </xsl:text>
                <xsl:value-of select="key('kLookupAbout',schema:publisher/@rdf:nodeID)/schema:name"/>
                <xsl:text>&#10;</xsl:text>
            </xsl:if>  
            <xsl:if test="library:placeOfPublication/@rdf:nodeID">
                <xsl:text>| location = </xsl:text>
                <xsl:value-of select="key('kLookupAbout',library:placeOfPublication/@rdf:nodeID)/schema:name"/>
                <xsl:text>&#10;</xsl:text>
            </xsl:if>   
            <xsl:if test="schema:datePublished">
                <xsl:text>| publication-date = </xsl:text>
                <xsl:value-of select="schema:datePublished"/>
                <xsl:text>&#10;</xsl:text>
            </xsl:if>             
            <xsl:choose>
                <xsl:when test="$oclc and $isbn">                                
                    <xsl:text>| oclc = </xsl:text>
                    <xsl:value-of select="$oclc" />
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>| isbn = </xsl:text>                                
                    <xsl:value-of select="$isbn" />
                    <xsl:text>&#10;</xsl:text>
                </xsl:when>
                <xsl:when test="$oclc and not($isbn)">                                
                    <xsl:text>| oclc = </xsl:text>
                    <xsl:value-of select="$oclc" />
                    <xsl:text>&#10;</xsl:text>
                </xsl:when>
                <xsl:when test="$isbn and not($oclc)">                                
                    <xsl:text>| isbn = </xsl:text> 
                    <xsl:value-of select="$isbn" />
                    <xsl:text>&#10;</xsl:text>
                </xsl:when>
                <xsl:otherwise />
            </xsl:choose>              
            <xsl:text>| separator = .</xsl:text>
            <xsl:text>&#10;</xsl:text>
        </xsl:for-each>       
    </xsl:template>
    
</xsl:stylesheet>