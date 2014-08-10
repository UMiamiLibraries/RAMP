<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eac="urn:isbn:1-931666-33-4"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings" xmlns:xlink="http://www.w3.org/1999/xlink"
    extension-element-prefixes="exsl str" exclude-result-prefixes="eac ead" version="1.0"> 

    <!-- Process description element. -->
    <xsl:template name="tDescription">
        <description xmlns="urn:isbn:1-931666-33-4">
            <!-- Call template for parsing dates. -->
            <xsl:call-template name="tExistDates">
                <xsl:with-param name="pName" select="normalize-space(ead:ead/ead:archdesc/ead:did/ead:origination/child::node()[1]
                    | ead:ead/ead:archdesc/ead:controlaccess/child::node()[1][contains(@role,'Collector')])" />
            </xsl:call-template>
            <!-- De-dupe language elements, if needed. -->
            <xsl:if test="//ead:ead/ead:archdesc/ead:did/ead:langmaterial/ead:language  !=  '' or $vLangName  !=  ''">
                <xsl:choose>
                    <xsl:when test="//ead:ead[2]/ead:archdesc/ead:did/ead:langmaterial/ead:language">
                        <languagesUsed>
                            <languageUsed>
                                <language languageCode="{$vLangCheck/@langcode}">
                                    <xsl:value-of select="normalize-space($vLangCheck)" />
                                </language>
                                <!-- The majority of cases will be Latin, but will otherwise need to be modified. -->
                                <script scriptCode="Latn">Latin</script>
                            </languageUsed>
                            <xsl:for-each select="ead:ead/ead:archdesc/ead:did/ead:langmaterial/ead:language[.  !=  $vLangCheck]">
                                <languageUsed>
                                    <language languageCode="{./@langcode}">
                                        <xsl:value-of select="normalize-space(.)" />
                                    </language>
                                    <script scriptCode="Latn">Latin</script>
                                </languageUsed>
                            </xsl:for-each>
                        </languagesUsed>
                    </xsl:when>
                    <xsl:otherwise>
                        <languagesUsed>
                            <xsl:for-each select="ead:ead/ead:archdesc/ead:did/ead:langmaterial/ead:language">
                                <languageUsed>
                                    <language languageCode="{./@langcode}">
                                        <xsl:value-of select="normalize-space(.)" />
                                    </language>
                                    <script scriptCode="Latn">Latin</script>
                                </languageUsed>
                            </xsl:for-each>
                            <xsl:call-template name="tLangs" />
                        </languagesUsed>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <!-- Call templates for subjects and gender. -->
            <xsl:call-template name="tControlAccess" />
            <xsl:call-template name="tGenders" />
            <!-- Process biogHist element. -->
            <xsl:if test="ead:ead/ead:archdesc/ead:bioghist">
                <biogHist>
                    <xsl:if test="ead:ead/ead:archdesc/ead:did/ead:abstract[.  !=  '' and .  !=  ' ']">
                        <xsl:apply-templates select="ead:ead/ead:archdesc/ead:did/ead:abstract" />
                    </xsl:if>
                    <!-- Match properly formatted chronologies -->
                    <xsl:choose>
                        <xsl:when test="ead:ead/ead:archdesc/ead:bioghist/ead:list">
                            <list>
                                <xsl:for-each select="ead:item">
                                    <xsl:apply-templates select="." />
                                </xsl:for-each>
                            </list>
                        </xsl:when>
                        <xsl:when test="ead:ead/ead:archdesc/ead:bioghist/ead:chronlist">
                            <chronList>
                                <xsl:for-each select="ead:ead/ead:archdesc/ead:bioghist/ead:chronlist/ead:chronitem">
                                    <xsl:variable name="vDateVal" select="normalize-space(ead:date)" />
                                    <chronItem>
                                        <xsl:choose>
                                            <xsl:when test="contains($vDateVal,'-')">
                                                <dateRange>
                                                    <fromDate standardDate="{substring-before($vDateVal,'-')}">
                                                        <xsl:value-of select="substring-before($vDateVal,'-')" />
                                                    </fromDate>
                                                    <toDate standardDate="{substring-after($vDateVal,'-')}">
                                                        <xsl:value-of select="substring-after($vDateVal,'-')" />
                                                    </toDate>
                                                </dateRange>
                                            </xsl:when>
                                            <xsl:when test="string-length(translate($vDateVal,concat($vDigits,'-'),''))=1">
                                                <dateRange>
                                                    <fromDate standardDate="{substring-before($vDateVal,'s')}">
                                                        <xsl:value-of select="substring-before($vDateVal,'s')" />
                                                    </fromDate>
                                                    <toDate standardDate="{concat(substring($vDateVal,1,3),'9')}">
                                                        <xsl:value-of select="concat(substring($vDateVal,1,3),'9')" />
                                                    </toDate>
                                                </dateRange>
                                            </xsl:when>                                                                                       
                                        	<!-- Handle LOC formatted dates. -->
                                        	<xsl:when test="contains($vDateVal,'Jan.')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', Jan.')"/>                                        				
                                        				<xsl:text>-01-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'Jan. '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'Jan. ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>
                                        	</xsl:when>
                                            <xsl:when test="contains($vDateVal,'January')">
                                                <date>
                                                    <xsl:attribute name="standardDate">
                                                        <xsl:value-of select="substring-before($vDateVal,', January')"/>                                        				
                                                        <xsl:text>-01-</xsl:text>
                                                        <xsl:if test="string-length(substring-after($vDateVal,'January '))=1">
                                                            <xsl:text>0</xsl:text>
                                                        </xsl:if>
                                                        <xsl:value-of select="substring-after($vDateVal,'January ')"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="$vDateVal" />
                                                </date>
                                            </xsl:when>
                                        	<xsl:when test="contains($vDateVal,'Feb.')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', Feb.')"/>                                        				
                                        				<xsl:text>-02-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'Feb. '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'Feb. ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>
                                        	</xsl:when>
                                            <xsl:when test="contains($vDateVal,'February')">
                                                <date>
                                                    <xsl:attribute name="standardDate">
                                                        <xsl:value-of select="substring-before($vDateVal,', February')"/>                                        				
                                                        <xsl:text>-02-</xsl:text>
                                                        <xsl:if test="string-length(substring-after($vDateVal,'February '))=1">
                                                            <xsl:text>0</xsl:text>
                                                        </xsl:if>
                                                        <xsl:value-of select="substring-after($vDateVal,'February ')"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="$vDateVal" />
                                                </date>
                                            </xsl:when>
                                        	<xsl:when test="contains($vDateVal,'Mar.')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', Mar.')"/>                                        				
                                        				<xsl:text>-03-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'Mar. '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'Mar. ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>                                        		
                                        	</xsl:when>
                                            <xsl:when test="contains($vDateVal,'March')">
                                                <date>
                                                    <xsl:attribute name="standardDate">
                                                        <xsl:value-of select="substring-before($vDateVal,', March')"/>                                        				
                                                        <xsl:text>-03-</xsl:text>
                                                        <xsl:if test="string-length(substring-after($vDateVal,'March '))=1">
                                                            <xsl:text>0</xsl:text>
                                                        </xsl:if>
                                                        <xsl:value-of select="substring-after($vDateVal,'March ')"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="$vDateVal" />
                                                </date>                                        		
                                            </xsl:when>
                                        	<xsl:when test="contains($vDateVal,'Apr.')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', Apr.')"/>                                        				
                                        				<xsl:text>-04-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'Apr. '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'Apr. ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>
                                        	</xsl:when>
                                            <xsl:when test="contains($vDateVal,'April')">
                                                <date>
                                                    <xsl:attribute name="standardDate">
                                                        <xsl:value-of select="substring-before($vDateVal,', April')"/>                                        				
                                                        <xsl:text>-04-</xsl:text>
                                                        <xsl:if test="string-length(substring-after($vDateVal,'April '))=1">
                                                            <xsl:text>0</xsl:text>
                                                        </xsl:if>
                                                        <xsl:value-of select="substring-after($vDateVal,'April ')"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="$vDateVal" />
                                                </date>
                                            </xsl:when>
                                        	<xsl:when test="contains($vDateVal,'May')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', May')"/>                                        				
                                        				<xsl:text>-05-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'May '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'May ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>
                                        	</xsl:when>                                            
                                        	<xsl:when test="contains($vDateVal,'Jun.')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', Jun.')"/>                                        				
                                        				<xsl:text>-06-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'Jun. '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'Jun. ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>
                                        	</xsl:when>
                                            <xsl:when test="contains($vDateVal,'June')">
                                                <date>
                                                    <xsl:attribute name="standardDate">
                                                        <xsl:value-of select="substring-before($vDateVal,', June')"/>                                        				
                                                        <xsl:text>-06-</xsl:text>
                                                        <xsl:if test="string-length(substring-after($vDateVal,'June '))=1">
                                                            <xsl:text>0</xsl:text>
                                                        </xsl:if>
                                                        <xsl:value-of select="substring-after($vDateVal,'June ')"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="$vDateVal" />
                                                </date>
                                            </xsl:when>
                                        	<xsl:when test="contains($vDateVal,'Jul.')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', Jul.')"/>                                        				
                                        				<xsl:text>-07-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'Jul. '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'Jul. ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>
                                        	</xsl:when>
                                            <xsl:when test="contains($vDateVal,'July')">
                                                <date>
                                                    <xsl:attribute name="standardDate">
                                                        <xsl:value-of select="substring-before($vDateVal,', July')"/>                                        				
                                                        <xsl:text>-07-</xsl:text>
                                                        <xsl:if test="string-length(substring-after($vDateVal,'July '))=1">
                                                            <xsl:text>0</xsl:text>
                                                        </xsl:if>
                                                        <xsl:value-of select="substring-after($vDateVal,'July ')"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="$vDateVal" />
                                                </date>
                                            </xsl:when>
                                        	<xsl:when test="contains($vDateVal,'Aug.')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', Aug.')"/>                                        				
                                        				<xsl:text>-08-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'Aug. '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'Aug. ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>
                                        	</xsl:when>
                                            <xsl:when test="contains($vDateVal,'August')">
                                                <date>
                                                    <xsl:attribute name="standardDate">
                                                        <xsl:value-of select="substring-before($vDateVal,', August')"/>                                        				
                                                        <xsl:text>-08-</xsl:text>
                                                        <xsl:if test="string-length(substring-after($vDateVal,'August '))=1">
                                                            <xsl:text>0</xsl:text>
                                                        </xsl:if>
                                                        <xsl:value-of select="substring-after($vDateVal,'August ')"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="$vDateVal" />
                                                </date>
                                            </xsl:when>
                                        	<xsl:when test="contains($vDateVal,'Sept.')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', Sept.')"/>                                        				
                                        				<xsl:text>-09-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'Sept. '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'Sept. ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>
                                        	</xsl:when>
                                            <xsl:when test="contains($vDateVal,'September')">
                                                <date>
                                                    <xsl:attribute name="standardDate">
                                                        <xsl:value-of select="substring-before($vDateVal,', September')"/>                                        				
                                                        <xsl:text>-09-</xsl:text>
                                                        <xsl:if test="string-length(substring-after($vDateVal,'September '))=1">
                                                            <xsl:text>0</xsl:text>
                                                        </xsl:if>
                                                        <xsl:value-of select="substring-after($vDateVal,'September ')"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="$vDateVal" />
                                                </date>
                                            </xsl:when>
                                        	<xsl:when test="contains($vDateVal,'Oct.')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', Oct.')"/>                                        				
                                        				<xsl:text>-10-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'Oct. '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'Oct. ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>
                                        	</xsl:when>
                                            <xsl:when test="contains($vDateVal,'October')">
                                                <date>
                                                    <xsl:attribute name="standardDate">
                                                        <xsl:value-of select="substring-before($vDateVal,', October')"/>                                        				
                                                        <xsl:text>-10-</xsl:text>
                                                        <xsl:if test="string-length(substring-after($vDateVal,'October '))=1">
                                                            <xsl:text>0</xsl:text>
                                                        </xsl:if>
                                                        <xsl:value-of select="substring-after($vDateVal,'October ')"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="$vDateVal" />
                                                </date>
                                            </xsl:when>
                                        	<xsl:when test="contains($vDateVal,'Nov.')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', Nov.')"/>                                        				
                                        				<xsl:text>-11-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'Nov. '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'Nov. ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>
                                        	</xsl:when>
                                            <xsl:when test="contains($vDateVal,'November')">
                                                <date>
                                                    <xsl:attribute name="standardDate">
                                                        <xsl:value-of select="substring-before($vDateVal,', November')"/>                                        				
                                                        <xsl:text>-11-</xsl:text>
                                                        <xsl:if test="string-length(substring-after($vDateVal,'November '))=1">
                                                            <xsl:text>0</xsl:text>
                                                        </xsl:if>
                                                        <xsl:value-of select="substring-after($vDateVal,'November ')"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="$vDateVal" />
                                                </date>
                                            </xsl:when>
                                        	<xsl:when test="contains($vDateVal,'Dec.')">
                                        		<date>
                                        			<xsl:attribute name="standardDate">
                                        				<xsl:value-of select="substring-before($vDateVal,', Dec.')"/>                                        				
                                        				<xsl:text>-12-</xsl:text>
                                        				<xsl:if test="string-length(substring-after($vDateVal,'Dec. '))=1">
                                        					<xsl:text>0</xsl:text>
                                        				</xsl:if>
                                        				<xsl:value-of select="substring-after($vDateVal,'Dec. ')"/>
                                        			</xsl:attribute>
                                        			<xsl:value-of select="$vDateVal" />
                                        		</date>
                                        	</xsl:when>
                                            <xsl:when test="contains($vDateVal,'December')">
                                                <date>
                                                    <xsl:attribute name="standardDate">
                                                        <xsl:value-of select="substring-before($vDateVal,', December')"/>                                        				
                                                        <xsl:text>-12-</xsl:text>
                                                        <xsl:if test="string-length(substring-after($vDateVal,'December '))=1">
                                                            <xsl:text>0</xsl:text>
                                                        </xsl:if>
                                                        <xsl:value-of select="substring-after($vDateVal,'December ')"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="$vDateVal" />
                                                </date>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <date standardDate="{$vDateVal}">
                                                    <xsl:value-of select="$vDateVal" />
                                                </date>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <event>
                                            <xsl:choose>
                                                <xsl:when test="ead:eventgrp">
                                                    <xsl:for-each select="ead:eventgrp/ead:event">
                                                        <xsl:variable name="vStrLen" select="string-length(.)" />
                                                        <xsl:choose>
                                                            <xsl:when test="substring(.,$vStrLen)=' '">
                                                                <xsl:value-of select="normalize-space(.)" />
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="normalize-space(.)" />
                                                            	<xsl:if test="position() != last()">
                                                                	<xsl:text> </xsl:text>
                                                            	</xsl:if>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="normalize-space(ead:event)" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </event>
                                    </chronItem>
                                </xsl:for-each>
                            </chronList>
                        </xsl:when>
                    </xsl:choose>                                                                                                    
                    <!-- Attempt to match local formatting for chronologies in Archon -->                                        
                    <xsl:for-each select="ead:ead[1]/ead:archdesc/ead:bioghist/ead:p">
                        <xsl:choose>
                            <xsl:when test="contains(.,'Chronolog') or contains(.,'Timeline')">
                                <chronList>
                                    <xsl:for-each select="following-sibling::ead:p[string-length()&lt;=10]">
                                        <xsl:variable name="vDateVal" select="normalize-space(.)" />
                                        <chronItem>
                                            <xsl:choose>
                                                <xsl:when test="contains($vDateVal,'-')">
                                                    <dateRange>
                                                        <fromDate standardDate="{substring-before($vDateVal,'-')}">
                                                            <xsl:value-of select="substring-before($vDateVal,'-')" />
                                                        </fromDate>
                                                        <toDate standardDate="{substring-after($vDateVal,'-')}">
                                                            <xsl:value-of select="substring-after($vDateVal,'-')" />
                                                        </toDate>
                                                    </dateRange>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <date standardDate="{$vDateVal}">
                                                        <xsl:value-of select="$vDateVal" />
                                                    </date>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <event>
                                                <xsl:for-each select="following-sibling::ead:p[string-length()&gt;10]">
                                                    <xsl:if test="preceding-sibling::ead:p[string-length()&lt;=10][1]=$vDateVal">
                                                        <xsl:value-of select="normalize-space(.)" />
                                                        <xsl:text />
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </event>
                                        </chronItem>
                                    </xsl:for-each>
                                </chronList>
                            </xsl:when>
                            <xsl:when test="contains(.,'Employment History')">
                                <p>
                                    <xsl:value-of select="normalize-space(.)" />
                                </p>
                                <chronList>
                                    <xsl:for-each select="following-sibling::ead:p[string-length(substring(.,1,4)) != string-length(translate(substring(.,1,4),$vDigits,''))]">
                                        <xsl:variable name="vDateVal" select="substring-before(normalize-space(.),':')" />
                                        <chronItem>
                                            <xsl:choose>
                                                <xsl:when test="contains($vDateVal,'-')">
                                                    <dateRange>
                                                        <fromDate standardDate="{substring-before($vDateVal,'-')}">
                                                            <xsl:value-of select="substring-before($vDateVal,'-')" />
                                                        </fromDate>
                                                        <toDate standardDate="{substring-after($vDateVal,'-')}">
                                                            <xsl:value-of select="substring-after($vDateVal,'-')" />
                                                        </toDate>
                                                    </dateRange>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <date standardDate="{$vDateVal}">
                                                        <xsl:value-of select="$vDateVal" />
                                                    </date>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <event>
                                                <xsl:value-of select="substring-after(.,': ')" />
                                            </event>
                                        </chronItem>
                                    </xsl:for-each>
                                </chronList>
                            </xsl:when>                            
                            <xsl:otherwise>                                
                                <xsl:if test="not(contains(.,'Chronolog'))                                      
                                    and not(contains(.,'Timeline'))                                      
                                    and not(contains(.,'Employment History'))">
                                    <xsl:if test="not(preceding-sibling::ead:p[contains(.,'Chronolog')])">
                                        <xsl:if test=". != ' ' and . != ''">
                                            <xsl:apply-templates select="."/>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:if>                                
                            </xsl:otherwise>                            
                        </xsl:choose>                        
                    </xsl:for-each>                                                                                                  
                    <xsl:call-template name="tCitations" />
                </biogHist>
            </xsl:if>
        </description>
    </xsl:template>

</xsl:stylesheet>
