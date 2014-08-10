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
    
    <!-- Output "External links" section. -->
    <xsl:template name="tExternalLinks">
        <xsl:text>&#10;</xsl:text>
        <xsl:text>==External links==</xsl:text>        
        <xsl:text>&#10;</xsl:text>
    	<xsl:choose>
    		<xsl:when test="contains(eac:eac-cpf/eac:control/eac:sources/eac:source/@xlink:href,'.edu')">    		    
    		    <xsl:choose>
    		        <!-- Forward to Libraries template. -->	
    		        <xsl:when test="eac:eac-cpf/eac:control/eac:sources/eac:source[contains(@xlink:href,'viaf')]">
    		            <xsl:text>{{Library resources box</xsl:text>
    		            <xsl:text>&#10;</xsl:text>
    		            <xsl:text>|onlinebooks=yes</xsl:text>
    		            <xsl:text>&#10;</xsl:text>
    		            <xsl:text>|by=yes</xsl:text>
    		            <xsl:text>&#10;</xsl:text>
    		            <xsl:text>|about=yes</xsl:text>
    		            <xsl:text>&#10;</xsl:text>
    		            <xsl:text>|viaf=</xsl:text>
    		            <xsl:value-of select="substring-after(eac:eac-cpf/eac:control/eac:sources/eac:source[contains(@xlink:href,'viaf')]/@xlink:href,'viaf/')"/>
    		            <xsl:text>&#10;</xsl:text>
    		            <xsl:text>|label=</xsl:text>
    		            <xsl:call-template name="tParseName2">
    		                <xsl:with-param name="pNameType" select="'person' or 'corporate'" />
    		                <xsl:with-param name="pPersName" select="$pPersName" />
    		                <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
    		                <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
    		                <xsl:with-param name="pCorpName" select="$pCorpName" />
    		            </xsl:call-template>
    		            <xsl:text>}}</xsl:text>        
    		            <xsl:text>&#10;</xsl:text>
    		        </xsl:when>
    		        <xsl:otherwise>
    		            <!-- If no VIAF ID, include link to UM Summon. 
    		            <xsl:text>Library and archival resources by or about [</xsl:text>
    		            <xsl:call-template name="tParseName3">
    		                <xsl:with-param name="pNameType" select="'person' or 'corporate'" />
    		                <xsl:with-param name="pPersName" select="$pPersName" />
    		                <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
    		                <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
    		                <xsl:with-param name="pCorpName" select="$pCorpName" />
    		            </xsl:call-template>        
    		            -->
    		        </xsl:otherwise>
    		    </xsl:choose>    		        			    		        			
    		</xsl:when>    		    		    		
    		<!-- Forward to Libraries template. -->	
    		<xsl:when test="contains(eac:eac-cpf/eac:control/eac:sources/eac:source/@xlink:href,'loc.mss')">
	    		<xsl:text>{{Library resources box</xsl:text>
	    		<xsl:text>&#10;</xsl:text>
	    		<xsl:text>|onlinebooks=yes</xsl:text>
	    		<xsl:text>&#10;</xsl:text>
	    		<xsl:text>|by=yes</xsl:text>
	    		<xsl:text>&#10;</xsl:text>
	    		<xsl:text>|about=yes</xsl:text>
	    		<xsl:text>&#10;</xsl:text>
	    		<xsl:text>|viaf=</xsl:text>
	    		<xsl:value-of select="substring-after(eac:eac-cpf/eac:control/eac:sources/eac:source[contains(@xlink:href,'viaf')]/@xlink:href,'viaf/')"/>
	    		<xsl:text>&#10;</xsl:text>
	    		<xsl:text>|label=</xsl:text>
	    		<xsl:call-template name="tParseName2">
	    			<xsl:with-param name="pNameType" select="'person' or 'corporate'" />
	    			<xsl:with-param name="pPersName" select="$pPersName" />
	    			<xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
	    			<xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
	    			<xsl:with-param name="pCorpName" select="$pCorpName" />
	    		</xsl:call-template>
	    		<xsl:text>}}</xsl:text>
	    		<xsl:text>&#10;</xsl:text>
    		    <!--
    			<xsl:text>* [</xsl:text>
    			<xsl:value-of select="eac:eac-cpf/eac:control/eac:sources/eac:source/@xlink:href"/>
    			<xsl:text> </xsl:text>
    			<xsl:value-of select="eac:eac-cpf/eac:control/eac:sources/eac:source/eac:sourceEntry"/>
    			<xsl:text>] at the [http://www.loc.gov/rr/mss/ Library of Congress Manuscripts Division].</xsl:text>
    			<xsl:text>&#10;</xsl:text>
                -->    			
    		</xsl:when>    		
    	</xsl:choose>    	    	        
        <xsl:if test="eac:eac-cpf/eac:control/eac:otherRecordId[@localType='WCI']">
            <!-- Add ID nonstandard WorldCat IDs -->
            <xsl:text>* {{worldcat|description="WorldCat Identities page for </xsl:text>
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
            <xsl:text>&#10;</xsl:text>            
        </xsl:if>        	        	        	
        <xsl:if test="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation[@xlink:role='archivalRecords']">
            <!-- Check for archival/digital collections created by or associated with the person or corporate body. -->                       
            <xsl:for-each select="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation[@xlink:role='archivalRecords'][eac:objectXMLWrap]">
                <xsl:sort select="translate(eac:relationEntry,'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />                
                <xsl:text>* The [</xsl:text>
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
                <xsl:text> </xsl:text>
                <xsl:choose>
                    <!-- Rough matching to filter for Spanish and Portuguese titles. Needs work for internationalization and smarter switching between title and sentence case. -->
                    <xsl:when test="contains(eac:relationEntry,' ao ')
                        or contains(eac:relationEntry,' com ')
                        or contains(eac:relationEntry,' con ')
                        or contains(eac:relationEntry,' da ')
                        or contains(eac:relationEntry,' das ')
                        or contains(eac:relationEntry,' de ')
                        or contains(eac:relationEntry,' dos ')
                        or contains(eac:relationEntry,' e ')
                        or contains(eac:relationEntry,' en ')
                        or contains(eac:relationEntry,' em ')
                        or contains(eac:relationEntry,' para ')
                        or contains(eac:relationEntry,' pela ')
                        or contains(eac:relationEntry,' pelo ')
                        or contains(eac:relationEntry,' por ')
                        or contains(eac:relationEntry,' y ')">
                        <xsl:value-of select="normalize-space(eac:relationEntry)"/>
                        <xsl:text>] </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>                                
                            <xsl:when test="contains(normalize-space(eac:relationEntry),' . ')">
                                <xsl:call-template name="tTitleCaps">
                                    <xsl:with-param name="pTitles" select="normalize-space(substring-before(eac:relationEntry,' . '))"/>
                                </xsl:call-template>                             
                                <xsl:text>] </xsl:text>
                                <xsl:value-of select="normalize-space(substring-after(eac:relationEntry,' . '))" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(eac:relationEntry)"/>                                                            
                                <xsl:text>] </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>                                                                        
                </xsl:choose>            
                <!-- Modify the following to refer to local collections... -->
                <xsl:if
                    test="contains(eac:objectXMLWrap/ead:archdesc/ead:did/ead:repository/ead:corpname
                    | /eac:eac-cpf/eac:control/eac:sources/eac:source/eac:objectXMLWrap//ead:publisher,'University of Miami Cuban Heritage')">
                    <xsl:text>is/are available at the [http://library.miami.edu/chc/ Cuban Heritage Collection], University of Miami Libraries.</xsl:text>
                </xsl:if>
                <xsl:if
                    test="contains(eac:objectXMLWrap/ead:archdesc/ead:did/ead:repository/ead:corpname
                    | /eac:eac-cpf/eac:control/eac:sources/eac:source/eac:objectXMLWrap//ead:publisher,'University of Miami Special Collections')">
                    <xsl:text>is/are available at the [http://library.miami.edu/specialcollections/ Special Collections Division], University of Miami Libraries.</xsl:text>
                </xsl:if>                 
                <xsl:if test="eac:objectXMLWrap/ead:archdesc/ead:scopecontent">                    
                    <xsl:text> &lt;!-- </xsl:text>
                    <xsl:for-each select="eac:objectXMLWrap/ead:archdesc/ead:scopecontent/ead:p">
                        <xsl:apply-templates select="."/>
                        <xsl:choose>
                            <xsl:when test="position() != last()">
                                <xsl:text>&#10;</xsl:text>
                                <xsl:text>&#10;</xsl:text>
                            </xsl:when>
                            <xsl:otherwise />
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:text> --&gt;</xsl:text>
                    <xsl:text>&#10;</xsl:text>                    
                </xsl:if>                                            
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation[@xlink:role='archivalRecords' and not(eac:objectXMLWrap)]|eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation[not(@xlink:role='archivalRecords')]/eac:relationEntry[1][@localType='mix']|eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation[@resourceRelationType='other' and @xlink:role='resource']|eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation[not(@resourceRelationType) and @xlink:role='resource']">            
            <xsl:for-each select="eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation[@xlink:role='archivalRecords' and not(eac:objectXMLWrap)]|eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation[not(@xlink:role='archivalRecords')]/eac:relationEntry[1][@localType='mix']|eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation[@resourceRelationType='other' and @xlink:role='resource']|eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation[not(@resourceRelationType) and @xlink:role='resource']">
                <xsl:sort select="translate(eac:relationEntry,'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
                <xsl:text>* The [</xsl:text>
                <xsl:choose>
                    <xsl:when test="contains(@xlink:href,' ')">
                        <xsl:value-of select="normalize-space(translate(@xlink:href,' ','+'))" />
                    </xsl:when>
                    <xsl:otherwise>                        
                        <xsl:value-of select="normalize-space(@xlink:href)" />
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text> </xsl:text>
                <xsl:choose>
                    <!-- Rough matching to filter for Spanish and Portuguese titles. Needs work for internationalization and smarter switching between title and sentence case. -->
                    <xsl:when test="contains(eac:relationEntry,' ao ')
                        or contains(eac:relationEntry,' com ')
                        or contains(eac:relationEntry,' con ')
                        or contains(eac:relationEntry,' da ')
                        or contains(eac:relationEntry,' das ')
                        or contains(eac:relationEntry,' de ')
                        or contains(eac:relationEntry,' dos ')
                        or contains(eac:relationEntry,' e ')
                        or contains(eac:relationEntry,' en ')
                        or contains(eac:relationEntry,' em ')
                        or contains(eac:relationEntry,' para ')
                        or contains(eac:relationEntry,' pela ')
                        or contains(eac:relationEntry,' pelo ')
                        or contains(eac:relationEntry,' por ')
                        or contains(eac:relationEntry,' y ')">
                        <xsl:value-of select="normalize-space(eac:relationEntry)"/>
                        <xsl:text>] </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>                                
                            <xsl:when test="contains(normalize-space(eac:relationEntry),' . ')">
                                <xsl:call-template name="tTitleCaps">
                                    <xsl:with-param name="pTitles" select="normalize-space(substring-before(eac:relationEntry,' . '))"/>
                                </xsl:call-template>                             
                                <xsl:text>] </xsl:text>
                                <xsl:value-of select="normalize-space(substring-after(eac:relationEntry,' . '))" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="tTitleCaps">
                                    <xsl:with-param name="pTitles" select="normalize-space(eac:relationEntry)"/>
                                </xsl:call-template>                            
                                <xsl:text>] </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>                                                                        
                </xsl:choose>                
                <xsl:if test="eac:descriptiveNote/eac:p">                    
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
                </xsl:if>         
                <xsl:text>&#10;</xsl:text>   
            </xsl:for-each>            
        </xsl:if>        
    </xsl:template>
    
</xsl:stylesheet>