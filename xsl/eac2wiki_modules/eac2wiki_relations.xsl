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
        
    <!-- Define a key for Muenchian grouping of "See also" relations. -->
    <xsl:key name="kSeeAlsoCheck" match="//eac:term[contains(@localType,'7')]|//eac:term[contains(@localType,'610')]|eac:eac-cpf/eac:cpfDescription/eac:relations/eac:cpfRelation/eac:relationEntry[1]" use="." />
    
    <!-- Variable for grouping "See also" relations. -->    
    <xsl:variable name="vSeeAlso">                           
        <xsl:for-each select="eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription">
            <xsl:sort select="translate(eac:term,'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
            <xsl:if test="contains(@localType,'7')">
                <persName>                     
                    <xsl:choose>
                        <xsl:when test="contains(eac:term,'--')">
                            <xsl:call-template name="tParseName2">
                                <xsl:with-param name="pNameType">person</xsl:with-param>
                                <xsl:with-param name="pPersName" select="substring-before(eac:term,'--')" />
                            </xsl:call-template>        
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="tParseName2">
                                <xsl:with-param name="pNameType">person</xsl:with-param>
                                <xsl:with-param name="pPersName" select="eac:term" />
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>                    
                </persName>
            </xsl:if>
            <xsl:if test="contains(@localType,'610')">
                <corpName>       
                    <xsl:choose>
                        <xsl:when test="contains(eac:term,'--')">
                            <xsl:call-template name="tParseName2">
                                <xsl:with-param name="pNameType">corporate</xsl:with-param>
                                <xsl:with-param name="pCorpName" select="substring-before(eac:term,'--')" />                            
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="tParseName2">
                                <xsl:with-param name="pNameType">corporate</xsl:with-param>
                                <xsl:with-param name="pCorpName" select="eac:term" />                            
                            </xsl:call-template>        
                        </xsl:otherwise>
                    </xsl:choose>                                            
                </corpName>
            </xsl:if>
        </xsl:for-each>                                
        <xsl:for-each select="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:cpfRelation">
            <xsl:sort select="translate(eac:relationEntry[1],'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
            <xsl:choose>
                <xsl:when test="contains(@xlink:role,'Person')">  
                    <persName>
                        <xsl:choose>
                            <xsl:when test="contains(eac:relationEntry[1],'--')">
                                <xsl:call-template name="tParseName2">
                                    <xsl:with-param name="pNameType">person</xsl:with-param>
                                    <xsl:with-param name="pPersName" select="substring-before(eac:relationEntry[1],'--')" />
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="tParseName2">
                                    <xsl:with-param name="pNameType">person</xsl:with-param>
                                    <xsl:with-param name="pPersName" select="eac:relationEntry[1]" />
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>                                              
                    </persName>
                </xsl:when>
                <xsl:otherwise>   
                    <xsl:choose>
                        <xsl:when test="contains(eac:relationEntry[1],'--')">
                            <corpName>
                                <xsl:call-template name="tParseName2">
                                    <xsl:with-param name="pNameType">corporate</xsl:with-param>
                                    <xsl:with-param name="pCorpName" select="substring-before(eac:relationEntry[1],'--')" />
                                </xsl:call-template>
                            </corpName>
                        </xsl:when>
                        <xsl:otherwise>
                            <corpName>
                                <xsl:call-template name="tParseName2">
                                    <xsl:with-param name="pNameType">corporate</xsl:with-param>
                                    <xsl:with-param name="pCorpName" select="eac:relationEntry[1]" />
                                </xsl:call-template>
                            </corpName>
                        </xsl:otherwise>
                    </xsl:choose>                    
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>                                                            
    </xsl:variable>
    
    <!-- Temporarily, provide a list of related enties from subject headings or cpfRelations so that users can explore possibilities for links from other pages. NB: This is an area to developed. -->
    <xsl:template name="tRelations">
        <xsl:param name="pNameType" />
        <xsl:text>&#10;</xsl:text>
        <xsl:text>==See also==</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:choose>
            <xsl:when test="$pNameType='person'">
                <xsl:text>&lt;!-- </xsl:text>
                <xsl:call-template name="tParseName2">
                    <xsl:with-param name="pNameType">person</xsl:with-param>
                    <xsl:with-param name="pPersName" select="$pPersName" />
                    <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
                    <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
                </xsl:call-template>
                <xsl:text> may be associated with the following entities. These names were extracted from appropriate subject headings or from the &lt;cpfRelation&gt; elements in the EAC-CPF record. They may be useful for creating links to this page from other Wikipedia pages. Some names may be duplicates; however, different name forms can be useful for testing whether an entity has an existing page on Wikipedia.</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>The 'See also' section should not link to pages that do not exist (red links) or to disambiguation pages (unless used for further disambiguation in a disambiguation page).</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>Editors should provide a brief annotation when a link's relevance is not immediately apparent, when the meaning of the term may not be generally known, or when the term is ambiguous. For example:</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>[[Related person]]--made a similar achievement on April 4, 2005</xsl:text>
                <xsl:text>&#10;</xsl:text>                
                <xsl:text>--&gt;</xsl:text>                
                <xsl:text>&#10;</xsl:text>
                <!-- Group related names. -->
                <xsl:for-each select="exsl:node-set($vSeeAlso)/persName[count(. | key('kSeeAlsoCheck', .)[1]) = 1][not(.=preceding-sibling::persName)]|exsl:node-set($vSeeAlso)/corpName[count(. | key('kSeeAlsoCheck', .)[1]) = 1][not(.=preceding-sibling::corpName)]">
                    <xsl:sort select="translate(.,'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
                    <xsl:text>* [[</xsl:text>                    
                        <xsl:value-of select="normalize-space(.)" />
                    <xsl:text>]]</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                </xsl:for-each>                
            </xsl:when>
            <xsl:when test="$pNameType='corporate'">
                <xsl:text>&lt;!-- </xsl:text>
                <xsl:call-template name="tParseName2">
                    <xsl:with-param name="pNameType">corporate</xsl:with-param>
                    <xsl:with-param name="pCorpName" select="$pCorpName" />
                </xsl:call-template>
                <xsl:text> may be associated with the following entities. These names were extracted from the &lt;cpfRelation&gt; elements in the EAC-CPF record and may be useful for creating links to this page from other Wikipedia pages. Some names may be duplicates; however, different name forms can useful for testing whether an entity has an existing page on Wikipedia.</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>The 'See also' section should not link to pages that do not exist (red links) or to disambiguation pages (unless used for further disambiguation in a disambiguation page).</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>Editors should provide a brief annotation when a link's relevance is not immediately apparent, when the meaning of the term may not be generally known, or when the term is ambiguous. For example:</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>[[Related organization]]--made a similar achievement on April 4, 2005</xsl:text>
                <xsl:text>&#10;</xsl:text>                
                <xsl:text> --&gt;</xsl:text>                
                <xsl:text>&#10;</xsl:text>
                <!-- Group related names. -->
                <xsl:for-each select="exsl:node-set($vSeeAlso)/persName[count(. | key('kSeeAlsoCheck', .)[1]) = 1][not(.=preceding-sibling::persName)]|exsl:node-set($vSeeAlso)/corpName[count(. | key('kSeeAlsoCheck', .)[1]) = 1][not(.=preceding-sibling::corpName)]">
                    <xsl:sort select="translate(.,'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
                    <xsl:text>* [[</xsl:text>                    
                        <xsl:value-of select="normalize-space(.)" />
                    <xsl:text>]]</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>&#10;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>