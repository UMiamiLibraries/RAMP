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
	
    <!-- Output "Notes and references" section. Right now, only default reference is to the finding aid we've used, if any. -->
    <xsl:template name="tReferences">
        <xsl:text>&#10;</xsl:text>
        <xsl:text>==Notes and references==</xsl:text>
        <xsl:text>&#10;</xsl:text>    	
    	<xsl:choose>    		    	
    		<xsl:when test="eac:eac-cpf/eac:control/eac:sources/eac:source/eac:objectXMLWrap">    			    			    		    
    		    <xsl:choose>    		        
    		        <!-- For LOC finding aids... -->
          		    <xsl:when test="contains(eac:eac-cpf/eac:control/eac:sources/eac:source/@xlink:href,'loc.')">          		        
          		        <!-- Reflist template. -->
          		        <xsl:choose>
          		            <xsl:when test="$pBiogHist/eac:chronList/eac:chronItem">          		                              		        
                  		        <xsl:text>{{Reflist|refs=</xsl:text>
                  		        <xsl:text>&#10;</xsl:text>
                  		        <!-- Include a reference to the {{Cite LOC finding aid}} template... -->
              	    			<xsl:text>&lt;ref name="LOCMD"&gt;{{Cite LOC finding aid</xsl:text>
              	    			<xsl:text>&#10;</xsl:text>
              	    			<xsl:text>| url = </xsl:text>    			    
              	    			<xsl:value-of select="normalize-space(eac:eac-cpf/eac:control/eac:sources/eac:source/eac:objectXMLWrap/ead:ead/ead:eadheader/ead:eadid)"/>
                  			    <xsl:text>&#10;</xsl:text>
              	    			<xsl:text>| title = </xsl:text>
              	    			<xsl:value-of select="eac:eac-cpf/eac:control/eac:sources/eac:source/eac:sourceEntry[1]"/>    				    			
              	    			<xsl:text>&#10;</xsl:text>
              	    			<xsl:text>| author = </xsl:text>          		                
          		                <xsl:value-of select="normalize-space(//ead:author)" />
              	    			<xsl:text>&#10;</xsl:text>
                  			    <xsl:text>| date = </xsl:text>
          		                <xsl:for-each select="//eac:objectXMLWrap/ead:ead/ead:archdesc/ead:descgrp/ead:processinfo/ead:p">
          		                    <xsl:variable name="vLOCDate">
          		                        <xsl:value-of select="normalize-space(translate(.,concat($vAlpha,$vPunct2),''))"/>
          		                    </xsl:variable>
          		                    <xsl:choose>
          		                        <xsl:when test="contains($vLOCDate,' ')">
          		                            <xsl:value-of select="substring-before($vLOCDate,' ')"/>
          		                            <xsl:text>, </xsl:text>
          		                            <xsl:value-of select="substring-after($vLOCDate,' ')"/>
          		                        </xsl:when>
          		                        <xsl:otherwise>
          		                            <xsl:value-of select="$vLOCDate"/>    
          		                        </xsl:otherwise>
          		                    </xsl:choose>          		                              		                             
          		                </xsl:for-each> 
          		                <!--
                  			    <xsl:value-of select="eac:eac-cpf/eac:control/eac:sources/eac:source/eac:objectXMLWrap/ead:ead/ead:eadheader/ead:filedesc/ead:publicationstmt/ead:date/@normal"/>
                  			    -->
                  			    <xsl:text>&#10;</xsl:text>
              	    			<xsl:text>| accessdate = </xsl:text>
                  			    <xsl:call-template name="tAccessDateParser">
                  			        <xsl:with-param name="pAccessDate" select="eac:eac-cpf/eac:control/eac:maintenanceHistory/eac:maintenanceEvent/eac:eventDateTime/@standardDateTime"/>
                  			    </xsl:call-template>		
                  			    <xsl:text>&#10;</xsl:text>
              	    			<xsl:text>}}&lt;/ref&gt;</xsl:text>    				
              	    			<xsl:text>&#10;</xsl:text>   
                  		        <xsl:text>}}</xsl:text>
                  		        <xsl:text>&#10;</xsl:text>
          		                <xsl:text>&#10;</xsl:text>
          		            </xsl:when>
          		            <xsl:otherwise>
          		                <xsl:text>{{Reflist|refs=</xsl:text>
          		                <xsl:text>&#10;</xsl:text>
          		                <xsl:text>}}</xsl:text>
          		                <xsl:text>&#10;</xsl:text>
          		                <xsl:text>&#10;</xsl:text>
          		                <!-- Include a reference to the {{Cite LOC finding aid}} template... -->
          		                <xsl:text>{{Cite LOC finding aid</xsl:text>
          		                <xsl:text>&#10;</xsl:text>
          		                <xsl:text>| url = </xsl:text>    			    
          		                <xsl:value-of select="eac:eac-cpf/eac:control/eac:sources/eac:source/@xlink:href"/>
          		                <xsl:text>&#10;</xsl:text>
          		                <xsl:text>| title = </xsl:text>
          		                <xsl:value-of select="eac:eac-cpf/eac:control/eac:sources/eac:source/eac:sourceEntry[1]"/>    				    			
          		                <xsl:text>&#10;</xsl:text>
          		                <xsl:text>| author = </xsl:text>          		                
          		                <xsl:value-of select="normalize-space(//ead:author)" />
          		                <xsl:text>&#10;</xsl:text>
          		                <xsl:text>| date = </xsl:text>
          		                <xsl:for-each select="//eac:objectXMLWrap/ead:ead/ead:archdesc/ead:descgrp/ead:processinfo/ead:p">
          		                    <xsl:variable name="vLOCDate">
          		                        <xsl:value-of select="normalize-space(translate(.,concat($vAlpha,$vPunct2),''))"/>
          		                    </xsl:variable>
          		                    <xsl:choose>
          		                        <xsl:when test="contains($vLOCDate,' ')">
          		                            <xsl:value-of select="substring-before($vLOCDate,' ')"/>
          		                            <xsl:text>, </xsl:text>
          		                            <xsl:value-of select="substring-after($vLOCDate,' ')"/>
          		                        </xsl:when>
          		                        <xsl:otherwise>
          		                            <xsl:value-of select="$vLOCDate"/>    
          		                        </xsl:otherwise>
          		                    </xsl:choose>          		                              		                             
          		                </xsl:for-each> 
          		                <!--
                  			    <xsl:value-of select="eac:eac-cpf/eac:control/eac:sources/eac:source/eac:objectXMLWrap/ead:ead/ead:eadheader/ead:filedesc/ead:publicationstmt/ead:date/@normal"/>
                  			    -->
          		                <xsl:text>&#10;</xsl:text>
          		                <xsl:text>| accessdate = </xsl:text>
          		                <xsl:call-template name="tAccessDateParser">
          		                    <xsl:with-param name="pAccessDate" select="eac:eac-cpf/eac:control/eac:maintenanceHistory/eac:maintenanceEvent/eac:eventDateTime/@standardDateTime"/>
          		                </xsl:call-template>		
          		                <xsl:text>&#10;</xsl:text>
          		                <xsl:text>}}</xsl:text>    				
          		                <xsl:text>&#10;</xsl:text>
          		                <xsl:text>&#10;</xsl:text>
          		            </xsl:otherwise>
          		        </xsl:choose>
          			</xsl:when>
    		    	<!-- For local finding aids... -->
                    <xsl:otherwise>                        
                        <!-- Include {{Reflist}} template. -->                        
                        <xsl:text>&lt;!-- Insert references/citations inside the following {{Reflist}} template. --&gt;</xsl:text>                        
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>&lt;!-- Data supplied in the {{Cite open archival metadata}} template(s) may need to be edited (updated based on revision info, etc.). Separate multiple authors with a semicolon and a single space. --&gt;</xsl:text>
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>{{Reflist|refs=</xsl:text>
                        <!-- Insert a default reference to the archival metadata source. -->                           
                        <xsl:for-each select="eac:eac-cpf/eac:control/eac:sources/eac:source[eac:sourceEntry]">
                            <xsl:variable name="vFindingAidPos" select="position()"/>
                            <xsl:text>&#10;</xsl:text>
                            <xsl:text>&lt;ref name=RAMP_</xsl:text>
                            <xsl:value-of select="$vFindingAidPos"/>
                            <xsl:text>&gt;</xsl:text>
                            <xsl:text>{{Cite open archival metadata</xsl:text>
                            <xsl:text>&#10;</xsl:text>    		                            
                            <xsl:choose>
                                <xsl:when test="//ead:author">
                                    <xsl:variable name="vAuthStr" select="string-length(normalize-space(//ead:author))"/>
                                    <xsl:text>| author = </xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="contains(//ead:author,'Finding Aid Authors: ')">
                                            <xsl:choose>
                                                <xsl:when test="contains(substring-after(//ead:author,'Finding Aid Authors: '),' and ')">
                                                    <xsl:choose>
                                                    	<xsl:when test="substring(normalize-space(//ead:author),$vAuthStr)='.'">
                                                            <xsl:value-of select="concat('Finding aid authors: ',substring-after(substring(normalize-space(//ead:author),1,$vAuthStr -1),'Finding Aid Authors: '))" />
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="concat('Finding aid authors: ',substring-after(normalize-space(//ead:author),'Finding Aid Authors: '))"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:choose>
                                                        <xsl:when test="substring(normalize-space(//ead:author),$vAuthStr)='.'">
                                                            <xsl:value-of select="concat('Finding aid author: ',substring-after(substring(normalize-space(//ead:author),1,$vAuthStr -1),'Finding Aid Authors: '))" />
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="concat('Finding aid author: ',substring-after(normalize-space(//ead:author),'Finding Aid Authors: '))"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="substring(//ead:author,$vAuthStr)='.'">
                                                    <xsl:value-of select="substring(normalize-space(//ead:author),1,$vAuthStr -1)" />        
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="normalize-space(//ead:author)" />
                                                </xsl:otherwise>
                                            </xsl:choose>          
                                        </xsl:otherwise>
                                    </xsl:choose>           
                                    <xsl:text>&#10;</xsl:text>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:text>| title = </xsl:text>
                            <xsl:choose>
                                <!-- Rough matching to filter for Spanish and Portuguese titles. Needs work for internationalization and smarter switching between title and sentence case. -->
                                <xsl:when test="contains(eac:sourceEntry,' ao ')
                                    or contains(eac:sourceEntry,' com ')
                                    or contains(eac:sourceEntry,' con ')
                                    or contains(eac:sourceEntry,' da ')
                                    or contains(eac:sourceEntry,' das ')
                                    or contains(eac:sourceEntry,' de ')
                                    or contains(eac:sourceEntry,' dos ')
                                    or contains(eac:sourceEntry,' e ')
                                    or contains(eac:sourceEntry,' en ')
                                    or contains(eac:sourceEntry,' em ')
                                    or contains(eac:sourceEntry,' para ')
                                    or contains(eac:sourceEntry,' pela ')
                                    or contains(eac:sourceEntry,' pelo ')
                                    or contains(eac:sourceEntry,' por ')
                                    or contains(eac:sourceEntry,' y ')">
                                    <xsl:value-of select="normalize-space(eac:sourceEntry)"/>
                                </xsl:when>
                                <xsl:otherwise>                                
                                    <xsl:call-template name="tTitleCaps">
                                        <xsl:with-param name="pTitles" select="normalize-space(eac:sourceEntry)"/>
                                    </xsl:call-template>                                                                                            
                                </xsl:otherwise>                                                                        
                            </xsl:choose>                                         
                            <xsl:text>&#10;</xsl:text>
                            <xsl:text>| url = </xsl:text>
                            <xsl:value-of select="normalize-space(@xlink:href)" />
                            <xsl:text>&#10;</xsl:text>                            
                            <xsl:text>| date = </xsl:text>                                                            
                                <xsl:for-each select="eac:objectXMLWrap/ead:ead/ead:archdesc/ead:descgrp/ead:processinfo/ead:p">
                                    <xsl:value-of select="normalize-space(translate(.,concat($vAlpha,$vPunct2),''))"/>
                                    <xsl:if test="position() != last()">
                                        <xsl:text>, </xsl:text>    
                                    </xsl:if>                                        
                                </xsl:for-each>                                                            
                            <xsl:text>&#10;</xsl:text>
                            <xsl:value-of select="$pFindingAidInfo" />                            
                            <xsl:text>| accessdate = </xsl:text>
                            <xsl:call-template name="tAccessDateParser">
                                <xsl:with-param name="pAccessDate" select="../../eac:maintenanceHistory/eac:maintenanceEvent/eac:eventDateTime/@standardDateTime"/>
                            </xsl:call-template>
                            <xsl:text>&#10;</xsl:text>    	
                            <xsl:text>}}</xsl:text>
                            <xsl:text>&lt;/ref&gt;</xsl:text>
                            <xsl:text>&#10;</xsl:text>                                                                                                               
                        </xsl:for-each>                                                
                        <xsl:text>}}</xsl:text>
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>&#10;</xsl:text>                                                                                  
                    </xsl:otherwise>    		        
    		    </xsl:choose>    			    			
    		</xsl:when>    				    	
    	    <xsl:when test="//eac:citation[not(parent::eac:conventionDeclaration)]">    	            	      
    	        <!-- Include empty {{Reflist}} template. -->                        
    	        <xsl:text>&lt;!-- Insert references/citations inside the following template: --&gt;</xsl:text>
    	        <xsl:text>&#10;</xsl:text>    	        
    	        <xsl:text>{{Reflist|refs=</xsl:text>
    			<!-- Add any citation elements (not in <conventionDeclaration>. -->
    			<xsl:for-each select="//eac:citation[not(parent::eac:conventionDeclaration)]">    				
    				<xsl:text>&lt;ref&gt;</xsl:text>
    				<xsl:value-of select="normalize-space(.)" />
    				<xsl:text>&lt;/ref&gt;</xsl:text>
    				<xsl:text>&#10;</xsl:text>   
    			    <xsl:text>}}</xsl:text>
    			    <xsl:text>&#10;</xsl:text>    			    
    			</xsl:for-each>
    		</xsl:when>
    	    <xsl:otherwise>    	            	       
    	        <!-- Include empty {{Reflist}} template. -->                        
    	        <xsl:text>&lt;!-- Insert references/citations inside the following template: --&gt;</xsl:text>    	
    	        <xsl:text>&#10;</xsl:text>
    	        <xsl:text>{{Reflist|refs=</xsl:text>
    	        <xsl:text>&#10;</xsl:text>
    	        <xsl:text>}}</xsl:text>
    	        <xsl:text>&#10;</xsl:text>    	        
    	    </xsl:otherwise>
    	</xsl:choose>
    </xsl:template>
	
</xsl:stylesheet>