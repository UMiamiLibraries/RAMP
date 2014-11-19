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
    
    <xsl:import href="../common_modules/common_utils.xsl"/>
    
    <!-- Recursive template for trying to change words in titles to title case. -->
	<xsl:template name="tTitleCaps">
		<xsl:param name="pTitles" />		
		<xsl:choose>
			<xsl:when test="contains($pTitles,' ')">			    
			    <xsl:variable name="vTitleWord" select="normalize-space(substring-before($pTitles,' '))"/>
			    <xsl:choose>
       				<xsl:when test="$vTitleWord='a'
       					or $vTitleWord='an'
       					or $vTitleWord='and'
       					or $vTitleWord='as'
       					or $vTitleWord='at'
       					or $vTitleWord='but'
       					or $vTitleWord='by'						
       					or $vTitleWord='for'
       					or $vTitleWord='from'
       					or $vTitleWord='if'
       					or $vTitleWord='in'
       					or $vTitleWord='into'
       					or $vTitleWord='nor'
       					or $vTitleWord='of'
       					or $vTitleWord='off'
       					or $vTitleWord='on'
       					or $vTitleWord='onto'
       					or $vTitleWord='or'						
       					or $vTitleWord='than'
       					or $vTitleWord='the'
       					or $vTitleWord='tis'
       					or $vTitleWord='to'
       					or $vTitleWord='twas'
       					or $vTitleWord='upon'
       					or $vTitleWord='with'						
       					or $vTitleWord='yet'">
       					<xsl:value-of select="normalize-space($vTitleWord)"/>
       				</xsl:when>			        
       				<xsl:otherwise>
       					<xsl:value-of select="normalize-space(concat(translate(substring($vTitleWord,1,1),$vLower,$vUpper),substring($vTitleWord,2)))"/>
       				</xsl:otherwise>
			    </xsl:choose>				
			    <xsl:text> </xsl:text>
    			<xsl:call-template name="tTitleCaps">
    				<xsl:with-param name="pTitles" select="normalize-space(substring-after($pTitles,' '))"/>
    			</xsl:call-template>				        
			</xsl:when>			
			<xsl:otherwise>				
				<xsl:value-of select="normalize-space(concat(translate(substring($pTitles,1,1),$vLower,$vUpper),substring($pTitles,2)))"/>										
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
    
    <!-- Template for parsing Infobox names and related info. -->
    <xsl:template name="tParseName">
        <xsl:param name="pNameType" />
        <xsl:param name="pPersName" select="$pPersName" />
        <xsl:param name="pCorpName" select="$pCorpName" />
        <xsl:param name="pPersNameSur" select="$pPersNameSur" />
        <xsl:param name="pPersNameFore" select="$pPersNameFore" />
        <!-- Parse names for people first. -->
        <xsl:if test="$pNameType='person'">
            <xsl:choose>
                <xsl:when test="$pPersName">
                    <!-- If the name contains no dates ... -->
                    <xsl:if test="string-length(translate($pPersName,concat($vAlpha,$vCommaSpace),''))=0">
                        <!-- ... then reverse the order of the name parts accordingly. -->
                        <xsl:value-of select="substring-after($pPersName,', ')" />
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="substring-before($pPersName,', ')" />
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>| image</xsl:text>
                        <xsl:text>&#09;&#09;&#09;= </xsl:text>
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>| size</xsl:text>
                        <xsl:text>&#09;&#09;&#09;= </xsl:text>
                        <xsl:text> &lt;!-- Default 200px --&gt; </xsl:text>
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>| alt</xsl:text>
                        <xsl:text>&#09;&#09;&#09;&#09;= </xsl:text>
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>| caption</xsl:text>
                        <xsl:text>&#09;&#09;&#09;= </xsl:text>
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>| birth_name</xsl:text>
                        <xsl:text>&#09;&#09;= </xsl:text>
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>| birth_date</xsl:text>
                        <xsl:text>&#09;&#09;= </xsl:text>
                        <!-- Call template to attempt to prepopulate birth date info. -->
                        <xsl:call-template name="tNameDateParser">
                            <xsl:with-param name="pBirthYr" select="'true'" />
                            <xsl:with-param name="pCheckInfo" select="'true'" />
                        </xsl:call-template>
                        <xsl:text> &lt;!-- {{Birth date and age|YYYY|MM|DD}} --&gt; </xsl:text>
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>| birth_place</xsl:text>
                        <xsl:text>&#09;&#09;= </xsl:text>
                        <!-- Call template to attempt to prepopulate birth place info. -->
                        <!-- Under revision ...
                            <xsl:call-template name="tBirthPlaceFinder">
                            <xsl:with-param name="pBiogHist" select="$pBiogHist"/>
                            </xsl:call-template>
                        -->
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>| death_date</xsl:text>
                        <xsl:text>&#09;&#09;= </xsl:text>
                        <!-- Call template to attempt to prepopulate death date info. -->
                        <xsl:call-template name="tNameDateParser">
                            <xsl:with-param name="pDeathYr" select="'true'" />
                            <xsl:with-param name="pCheckInfo" select="'true'" />
                        </xsl:call-template>
                        <xsl:text> &lt;!-- {{Death date and age|YYYY|MM|DD|YYYY|MM|DD}} (death date then birth date) --&gt; </xsl:text>
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>| death_place</xsl:text>
                        <xsl:text>&#09;&#09;= </xsl:text>
                        <!-- Call template to attempt to prepopulate death place info. -->
                        <!-- Under revision ...
                            <xsl:call-template name="tDeathPlaceFinder">
                            <xsl:with-param name="pBiogHist" select="$pBiogHist"/>
                            </xsl:call-template>
                        -->
                        <xsl:text>&#10;</xsl:text>
                    </xsl:if>
                    <!-- If the name does contain dates ... -->
                    <xsl:if test="string-length(translate($pPersName,concat($vAlpha,$vCommaSpace),''))&gt;=4">
                        <!-- ... reverse the order of the name parts accordingly. -->
                        <xsl:value-of select="substring-before(substring-after($pPersName,','),',')" />
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="substring-before($pPersName,',')" />
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>| image</xsl:text>
                        <xsl:text>&#09;&#09;&#09;= </xsl:text>
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>| size</xsl:text>
                        <xsl:text>&#09;&#09;&#09;= </xsl:text>
                        <xsl:text> &lt;!-- Default 200px --&gt; </xsl:text>
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>| alt</xsl:text>
                        <xsl:text>&#09;&#09;&#09;&#09;= </xsl:text>
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>| caption</xsl:text>
                        <xsl:text>&#09;&#09;&#09;= </xsl:text>
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>| birth_name</xsl:text>
                        <xsl:text>&#09;&#09;= </xsl:text>
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>| birth_date</xsl:text>
                        <xsl:text>&#09;&#09;= </xsl:text>
                        <!-- Call template to attempt to prepopulate birth date info. -->
                        <xsl:call-template name="tNameDateParser">
                            <xsl:with-param name="pBirthYr" select="'true'" />
                            <xsl:with-param name="pCheckInfo" select="'true'" />
                        </xsl:call-template>
                        <xsl:text> &lt;!-- {{Birth date and age|YYYY|MM|DD}} --&gt; </xsl:text>
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>| birth_place</xsl:text>
                        <xsl:text>&#09;&#09;= </xsl:text>
                        <!-- Call template to attempt to prepopulate birth place info. -->
                        <!-- Under revision ...
                            <xsl:call-template name="tBirthPlaceFinder">
                            <xsl:with-param name="pBiogHist" select="$pBiogHist"/>
                            </xsl:call-template>
                        -->
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>| death_date</xsl:text>
                        <xsl:text>&#09;&#09;= </xsl:text>
                        <!-- Call template to attempt to prepopulate death date info. -->
                        <xsl:call-template name="tNameDateParser">
                            <xsl:with-param name="pDeathYr" select="'true'" />
                            <xsl:with-param name="pCheckInfo" select="'true'" />
                        </xsl:call-template>
                        <xsl:text> &lt;!-- {{Death date and age|YYYY|MM|DD|YYYY|MM|DD}} (death date then birth date) --&gt; </xsl:text>
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>| death_place</xsl:text>
                        <xsl:text>&#09;&#09;= </xsl:text>
                        <!-- Call template to attempt to prepopulate death place info. -->
                        <!-- Under revision ...
                            <xsl:call-template name="tDeathPlaceFinder">
                            <xsl:with-param name="pBiogHist" select="$pBiogHist"/>
                            </xsl:call-template>
                        -->
                        <xsl:text>&#10;</xsl:text>
                    </xsl:if>
                </xsl:when>
                <!-- If there are name parts... -->
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($pPersNameFore)" />
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="normalize-space($pPersNameSur)" />
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>| image</xsl:text>
                    <xsl:text>&#09;&#09;&#09;= </xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>| size</xsl:text>
                    <xsl:text>&#09;&#09;&#09;= </xsl:text>
                    <xsl:text> &lt;!-- Default 200px --&gt; </xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>| alt</xsl:text>
                    <xsl:text>&#09;&#09;&#09;&#09;= </xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>| caption</xsl:text>
                    <xsl:text>&#09;&#09;&#09;= </xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>| birth_name</xsl:text>
                    <xsl:text>&#09;&#09;= </xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>| birth_date</xsl:text>
                    <xsl:text>&#09;&#09;= </xsl:text>
                    <!-- Call template to attempt to prepopulate birth date info. -->
                    <xsl:call-template name="tNameDateParser">
                        <xsl:with-param name="pBirthYr" select="'true'" />
                        <xsl:with-param name="pCheckInfo" select="'true'" />
                    </xsl:call-template>
                    <xsl:text> &lt;!-- {{Birth date and age|YYYY|MM|DD}} --&gt; </xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>| birth_place</xsl:text>
                    <xsl:text>&#09;&#09;= </xsl:text>
                    <!-- Call template to attempt to prepopulate birth place info. -->
                    <!-- Under revision ...
                        <xsl:call-template name="tBirthPlaceFinder">
                        <xsl:with-param name="pBiogHist" select="$pBiogHist"/>
                        </xsl:call-template>
                    -->
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>| death_date</xsl:text>
                    <xsl:text>&#09;&#09;= </xsl:text>
                    <!-- Call template to attempt to prepopulate death date info. -->
                    <xsl:call-template name="tNameDateParser">
                        <xsl:with-param name="pDeathYr" select="'true'" />
                        <xsl:with-param name="pCheckInfo" select="'true'" />
                    </xsl:call-template>
                    <xsl:text> &lt;!-- {{Death date and age|YYYY|MM|DD|YYYY|MM|DD}} (death date then birth date) --&gt; </xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>| death_place</xsl:text>
                    <xsl:text>&#09;&#09;= </xsl:text>
                    <!-- Call template to attempt to prepopulate death place info. -->
                    <!-- Under revision ...
                        <xsl:call-template name="tDeathPlaceFinder">
                        <xsl:with-param name="pBiogHist" select="$pBiogHist"/>
                        </xsl:call-template>
                    -->
                    <xsl:text>&#10;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <!-- Then parse names for corporate bodies. -->
        <xsl:if test="$pNameType='corporate'">
            <!-- Name order stays as is. -->
            <xsl:value-of select="$pCorpName" />
            <xsl:text>&#10;</xsl:text>
            <xsl:text>| image</xsl:text>
            <xsl:text>&#09;&#09;&#09;&#09;= </xsl:text>
            <xsl:text>&#10;</xsl:text>
            <xsl:text>| size</xsl:text>
            <xsl:text>&#09;&#09;&#09;&#09;= </xsl:text>
            <xsl:text> &lt;!-- Default 200px --&gt; </xsl:text>
            <xsl:text>&#10;</xsl:text>
            <xsl:text>| alt</xsl:text>
            <xsl:text>&#09;&#09;&#09;&#09;&#09;= </xsl:text>
            <xsl:text>&#10;</xsl:text>
            <xsl:text>| caption</xsl:text>
            <xsl:text>&#09;&#09;&#09;&#09;= </xsl:text>
            <xsl:text>&#10;</xsl:text>
            <xsl:text>| abbreviation</xsl:text>
            <xsl:text>&#09;&#09;&#09;= </xsl:text>
            <xsl:text>&#10;</xsl:text>
            <xsl:text>| motto</xsl:text>
            <xsl:text>&#09;&#09;&#09;&#09;= </xsl:text>
            <xsl:text>&#10;</xsl:text>
            <xsl:text>| predecessor</xsl:text>
            <xsl:text>&#09;&#09;&#09;= </xsl:text>
            <xsl:text>&#10;</xsl:text>
            <xsl:text>| successor</xsl:text>
            <xsl:text>&#09;&#09;&#09;= </xsl:text>
            <xsl:text>&#10;</xsl:text>
            <xsl:text>| formation</xsl:text>
            <xsl:text>&#09;&#09;&#09;= </xsl:text>
            <xsl:choose>
                <xsl:when test="/eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates/@standardDate">
                    <xsl:value-of select="normalize-space(/eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates/@standardDate)" />
                    <xsl:text>&#10;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text> &lt;!-- {{Start date and age|YYYY|MM|DD}} --&gt; </xsl:text>
                    <xsl:text>&#10;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <!-- General template for parsing names and dates. -->
    <xsl:template name="tParseName2">
        <xsl:param name="pNameType" />
        <xsl:param name="pPersName" />
        <xsl:param name="pPersNameSur" />
        <xsl:param name="pPersNameFore" />
        <xsl:param name="pCorpName" />
        <!-- Parse names for people first. -->
        <xsl:if test="$pNameType='person'">            
            <xsl:if test="$pPersNameFore or $pPersNameSur">
                <xsl:value-of select="normalize-space($pPersNameFore)" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="normalize-space($pPersNameSur)" />
            </xsl:if>          
            
            <!-- Set variables to strip trailing period. -->
            <xsl:variable name="vPersNameLength" select="string-length($pPersName)" />
            <xsl:variable name="vPersNameVal" select="substring($pPersName,$vPersNameLength)" />
            <xsl:variable name="vPersName">
                <xsl:choose>
                    <xsl:when test="$vPersNameVal='.'">
                        <xsl:value-of select="substring(normalize-space($pPersName),1,$vPersNameLength -1)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space($pPersName)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>                        
            <xsl:choose>
                <!-- If the name contains dates ... -->
                <xsl:when test="string-length(translate($vPersName,$vDigits,''))&lt;string-length($vPersName)">
                    <!-- ... then reverse the order of the name parts accordingly. -->
                    <xsl:choose>                                                                        
                        <xsl:when test="contains(substring-after(normalize-space($vPersName),', '), ' ') and not(contains(substring-after(normalize-space($vPersName),', '), ', ')) and not(contains(substring-after(normalize-space($vPersName),', '), ' b ')) and not(contains(substring-after(normalize-space($vPersName),', '), ' b. '))">
                            <xsl:value-of select="substring-before(substring-after(normalize-space($vPersName),', '),' ')" />
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="substring-before(normalize-space($vPersName),', ')" />
                        </xsl:when>
                        <xsl:when test="contains(substring-after(normalize-space($vPersName),', '), ' b. ') and not(contains(substring-after(normalize-space($vPersName),', '), ', '))">
                            <xsl:value-of select="substring-before(substring-after(normalize-space($vPersName),', '),' b. ')" />
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="substring-before(normalize-space($vPersName),', ')" />
                        </xsl:when>
                        <xsl:when test="contains(substring-after(normalize-space($vPersName),', '), ' b ') and not(contains(substring-after(normalize-space($vPersName),', '), ', '))">
                            <xsl:value-of select="substring-before(substring-after(normalize-space($pPersName),', '),' b ')" />
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="substring-before(normalize-space($vPersName),', ')" />
                        </xsl:when>
                        <xsl:when test="contains(substring-after(normalize-space($vPersName),', '), ', b ')">
                            <xsl:value-of select="substring-before(substring-after(normalize-space($vPersName),', '),', b ')" />
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="substring-before(normalize-space($vPersName),', ')" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="substring-before(substring-after(normalize-space($vPersName),', '),', ')">
                                    <xsl:value-of select="substring-before(substring-after(normalize-space($vPersName),', '),', ')" />
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="substring-before(normalize-space($vPersName),', ')" />
                                </xsl:when>
                                <xsl:when test="contains(substring-after(normalize-space($vPersName),' '),', ')">
                                    <xsl:if test="not(contains(substring-after(substring-after(normalize-space($vPersName),' '),', '),', '))">
                                        <xsl:value-of select="substring-before(normalize-space($vPersName),', ')" />    
                                    </xsl:if>                                                        
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- Name order stays as is. -->
                                    <xsl:value-of select="normalize-space(translate($vPersName,concat($vDigits,'-','(',')'),''))" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <!-- If the name does not include dates ... -->
                    <xsl:choose>
                        <xsl:when test="contains($vPersName,', ')">
                            <xsl:value-of select="substring-after(normalize-space($vPersName),', ')" />
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="substring-before(normalize-space($vPersName),', ')" />
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- Name order stays as is. -->
                            <xsl:value-of select="normalize-space($vPersName)" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>                            
        </xsl:if>
        <!-- Then parse names for corporate bodies. -->
        <xsl:if test="$pNameType='corporate'">
            <!-- Set variables to strip trailing period. -->
            <xsl:variable name="vCorpNameLength" select="string-length($pCorpName)" />
            <xsl:variable name="vCorpNameVal" select="substring($pCorpName,$vCorpNameLength)" />
            <!-- Name order stays as is. -->
            <xsl:choose>
                <xsl:when test="$vCorpNameVal='.'">
                    <xsl:value-of select="substring(normalize-space($pCorpName),1,$vCorpNameLength -1)" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($pCorpName)" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <!-- Template for parse names in external link to library discovery service. Blank space must be translated to "+" in order for Wikipedia to recognize the link. -->
    <xsl:template name="tParseName3">
        <xsl:param name="pNameType" />
        <xsl:param name="pCorpName" />
        <xsl:param name="pPersName" />
        <xsl:param name="pPersNameFore" />
        <xsl:param name="pPersNameSur" />
        <xsl:if test="$pNameType='person'">
            <xsl:if test="$pPersName!='' or $pPersNameFore!='' or $pPersNameSur!=''">
                <xsl:choose>
                    <xsl:when test="$pPersNameSur or $pPersNameFore">
                        <!-- Output the URL -->
                        <xsl:value-of select="$pDiscServ" />
                        <!-- Output the name. -->
                        <xsl:value-of select="translate(concat(normalize-space($pPersNameFore),' ',normalize-space($pPersNameSur)),',. ','+++')" />
                        <xsl:text> </xsl:text>
                        <xsl:call-template name="tParseName2">
                            <xsl:with-param name="pNameType">person</xsl:with-param>
                            <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
                            <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
                        </xsl:call-template>
                        <xsl:text>].</xsl:text>
                    </xsl:when>
                    <!-- If the name contains no dates ... -->
                    <xsl:when test="string-length(translate($pPersName,concat($vAlpha,$vCommaSpace),''))=0">
                        <!-- ... then reverse the order of the name parts accordingly. -->
                        <!-- Output the URL -->
                        <xsl:value-of select="$pDiscServ" />
                        <!-- Output the name. -->
                        <xsl:choose>
                            <xsl:when test="contains($pPersName,',')">
                                <xsl:value-of select="translate(concat(substring-after($pPersName,', '),' ',substring-before($pPersName,', ')),',. ','+++')" />
                                <xsl:text> </xsl:text>
                                <xsl:call-template name="tParseName2">
                                    <xsl:with-param name="pNameType">person</xsl:with-param>
                                    <xsl:with-param name="pPersName" select="$pPersName" />
                                    <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
                                    <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
                                </xsl:call-template>
                                <xsl:text>].</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="tParseName2">
                                    <xsl:with-param name="pNameType">person</xsl:with-param>
                                    <xsl:with-param name="pPersName" select="$pPersName" />
                                    <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
                                    <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
                                </xsl:call-template>
                                <xsl:text> </xsl:text>
                                <xsl:call-template name="tParseName2">
                                    <xsl:with-param name="pNameType">person</xsl:with-param>
                                    <xsl:with-param name="pPersName" select="$pPersName" />
                                    <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
                                    <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
                                </xsl:call-template>
                                <xsl:text>].</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- If the name includes dates ... -->
                        <xsl:value-of select="$pDiscServ" />
                        <xsl:choose>
                            <xsl:when test="contains($pPersName,',')">
                                <xsl:value-of select="translate(concat(substring-before(substring-after($pPersName,', '),', '),' ',substring-before($pPersName,', ')),',. ','+++')" />
                                <xsl:text> </xsl:text>
                                <xsl:call-template name="tParseName2">
                                    <xsl:with-param name="pNameType">person</xsl:with-param>
                                    <xsl:with-param name="pPersName" select="$pPersName" />
                                    <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
                                    <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
                                </xsl:call-template>
                                <xsl:text>].</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="tParseName2">
                                    <xsl:with-param name="pNameType">person</xsl:with-param>
                                    <xsl:with-param name="pPersName" select="$pPersName" />
                                    <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
                                    <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
                                </xsl:call-template>
                                <xsl:text> </xsl:text>
                                <xsl:call-template name="tParseName2">
                                    <xsl:with-param name="pNameType">person</xsl:with-param>
                                    <xsl:with-param name="pPersName" select="$pPersName" />
                                    <xsl:with-param name="pPersNameSur" select="$pPersNameSur" />
                                    <xsl:with-param name="pPersNameFore" select="$pPersNameFore" />
                                </xsl:call-template>
                                <xsl:text>].</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>
        <xsl:if test="$pNameType='corporate'">
            <xsl:if test="$pCorpName!=''">
                <xsl:choose>
                    <xsl:when test="contains($pCorpName,'(')">
                        <xsl:value-of select="concat($pDiscServ,translate(normalize-space(substring-before($pCorpName,' (')),',. ','+++'))" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($pCorpName,',')">
                                <xsl:value-of select="concat($pDiscServ,translate($pCorpName,',. ','+++'))" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat($pDiscServ,translate($pCorpName,' ','+'))" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text> </xsl:text>
                <xsl:call-template name="tParseName2">
                    <xsl:with-param name="pNameType">corporate</xsl:with-param>
                    <xsl:with-param name="pCorpName" select="$pCorpName" />
                </xsl:call-template>
                <xsl:text>].</xsl:text>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- Template for parsing names and dates of main entity. -->
    <xsl:template name="tNameDateParser">
        <xsl:param name="pBirthYr" />
        <xsl:param name="pDeathYr" />
        <xsl:param name="pCheckInfo" />
        <xsl:choose>
            <!-- If there are existDates... -->
            <xsl:when test="eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates">
                <xsl:choose>
                    <xsl:when test="$pBirthYr='true' and $pCheckInfo='false'">
                        <!-- Output the birth year, if exists. -->
                        <xsl:choose>
                            <xsl:when test="contains(eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates/eac:dateRange/eac:fromDate,',')">
                                <xsl:value-of select="normalize-space(substring-after(eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates/eac:dateRange/eac:fromDate,','))" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates/eac:dateRange/eac:fromDate)" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$pDeathYr='true' and $pCheckInfo='false'">
                        <xsl:choose>
                            <xsl:when test="contains(eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates/eac:dateRange/eac:toDate,',')">
                                <xsl:value-of select="normalize-space(substring-after(eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates/eac:dateRange/eac:toDate,','))" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates/eac:dateRange/eac:toDate)" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$pBirthYr='true' and $pCheckInfo='true'">
                                <!-- Output the birth year, if exists. -->
                                <xsl:value-of select="normalize-space(eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates/eac:dateRange/eac:fromDate)" />
                            </xsl:when>
                            <xsl:when test="$pDeathYr='true' and $pCheckInfo='true'">
                                <xsl:value-of select="normalize-space(eac:eac-cpf/eac:cpfDescription/eac:description/eac:existDates/eac:dateRange/eac:toDate)" />
                            </xsl:when>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <!-- If the first nameEntry does not contain a date... -->
                <!-- ... try the second nameEntry, from VIAF... -->
                <xsl:if test="eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part">
                    <xsl:if test="string-length(translate(normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part),concat($vAlpha,$vCommaSpace),''))&gt;=4">
                        <xsl:if test="$pBirthYr='true'">
                            <!-- Output the birth year, if exists. -->
                            <xsl:choose>
                                <xsl:when test="normalize-space(substring-after(substring-after(substring-before(normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part),'-'),', '),', '))">
                                    <xsl:if test="string-length(translate(substring-before(normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part),'-'),$vDigits,''))&lt;string-length(substring-before(normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part),'-'))">
                                        <xsl:value-of select="normalize-space(substring-after(substring-after(substring-before(normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part),'-'),', '),', '))" />
                                    </xsl:if>
                                </xsl:when>
                                <xsl:when test="normalize-space(substring-after(substring-after(substring-before(normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part),'-'),', '),' '))">
                                    <xsl:if test="string-length(translate(substring-before(normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part),'-'),$vDigits,''))&lt;string-length(substring-before(normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part),'-'))">
                                        <xsl:value-of select="normalize-space(substring-after(substring-after(substring-before(normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part),'-'),', '),' '))" />
                                    </xsl:if>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:if>
                        <xsl:if test="$pDeathYr='true'">
                            <!-- Output the death year, if exists. -->
                            <xsl:if test="substring-after(normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part),'-')">
                                <xsl:value-of select="normalize-space(substring-after(normalize-space(eac:eac-cpf/eac:cpfDescription/eac:identity/eac:nameEntry[2][preceding-sibling::eac:entityType='person']/eac:part),'-'))" />
                            </xsl:if>
                        </xsl:if>
                    </xsl:if>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="tAccessDateParser">
        <xsl:param name="pAccessDate"/>
        <!-- Rearrange date to M-D-Y pattern. -->
        <xsl:choose>
            <xsl:when test="substring-before(substring-after($pAccessDate,'-'),'-')='01'">
                <xsl:text>January </xsl:text>
                <xsl:choose>
                    <xsl:when test="substring(substring-after(substring-after($pAccessDate,'-'),'-'),1,1)='0'">
                        <xsl:value-of select="substring(substring-after(substring-after($pAccessDate,'-'),'-'),2,1)"/>        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-after(substring-after($pAccessDate,'-'),'-')"/>
                    </xsl:otherwise>
                </xsl:choose>    			                        			           
                <xsl:text>, </xsl:text>
                <xsl:value-of select="substring-before($pAccessDate,'-')"/>
            </xsl:when>
            <xsl:when test="substring-before(substring-after($pAccessDate,'-'),'-')='02'">
                <xsl:text>February </xsl:text>
                <xsl:choose>
                    <xsl:when test="substring(substring-after(substring-after($pAccessDate,'-'),'-'),1,1)='0'">
                        <xsl:value-of select="substring(substring-after(substring-after($pAccessDate,'-'),'-'),2,1)"/>        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-after(substring-after($pAccessDate,'-'),'-')"/>
                    </xsl:otherwise>
                </xsl:choose>    			                        			           
                <xsl:text>, </xsl:text>
                <xsl:value-of select="substring-before($pAccessDate,'-')"/>
            </xsl:when>
            <xsl:when test="substring-before(substring-after($pAccessDate,'-'),'-')='03'">
                <xsl:text>March </xsl:text>
                <xsl:choose>
                    <xsl:when test="substring(substring-after(substring-after($pAccessDate,'-'),'-'),1,1)='0'">
                        <xsl:value-of select="substring(substring-after(substring-after($pAccessDate,'-'),'-'),2,1)"/>        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-after(substring-after($pAccessDate,'-'),'-')"/>
                    </xsl:otherwise>
                </xsl:choose>    			                        			           
                <xsl:text>, </xsl:text>
                <xsl:value-of select="substring-before($pAccessDate,'-')"/>
            </xsl:when>
            <xsl:when test="substring-before(substring-after($pAccessDate,'-'),'-')='04'">
                <xsl:text>April </xsl:text>
                <xsl:choose>
                    <xsl:when test="substring(substring-after(substring-after($pAccessDate,'-'),'-'),1,1)='0'">
                        <xsl:value-of select="substring(substring-after(substring-after($pAccessDate,'-'),'-'),2,1)"/>        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-after(substring-after($pAccessDate,'-'),'-')"/>
                    </xsl:otherwise>
                </xsl:choose>    			                        			           
                <xsl:text>, </xsl:text>
                <xsl:value-of select="substring-before($pAccessDate,'-')"/>
            </xsl:when>
            <xsl:when test="substring-before(substring-after($pAccessDate,'-'),'-')='05'">
                <xsl:text>May </xsl:text>
                <xsl:choose>
                    <xsl:when test="substring(substring-after(substring-after($pAccessDate,'-'),'-'),1,1)='0'">
                        <xsl:value-of select="substring(substring-after(substring-after($pAccessDate,'-'),'-'),2,1)"/>        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-after(substring-after($pAccessDate,'-'),'-')"/>
                    </xsl:otherwise>
                </xsl:choose>    			                        			           
                <xsl:text>, </xsl:text>
                <xsl:value-of select="substring-before($pAccessDate,'-')"/>
            </xsl:when>
            <xsl:when test="substring-before(substring-after($pAccessDate,'-'),'-')='06'">
                <xsl:text>June </xsl:text>
                <xsl:choose>
                    <xsl:when test="substring(substring-after(substring-after($pAccessDate,'-'),'-'),1,1)='0'">
                        <xsl:value-of select="substring(substring-after(substring-after($pAccessDate,'-'),'-'),2,1)"/>        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-after(substring-after($pAccessDate,'-'),'-')"/>
                    </xsl:otherwise>
                </xsl:choose>    			                        			           
                <xsl:text>, </xsl:text>
                <xsl:value-of select="substring-before($pAccessDate,'-')"/>
            </xsl:when>
            <xsl:when test="substring-before(substring-after($pAccessDate,'-'),'-')='07'">
                <xsl:text>July </xsl:text>
                <xsl:choose>
                    <xsl:when test="substring(substring-after(substring-after($pAccessDate,'-'),'-'),1,1)='0'">
                        <xsl:value-of select="substring(substring-after(substring-after($pAccessDate,'-'),'-'),2,1)"/>        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-after(substring-after($pAccessDate,'-'),'-')"/>
                    </xsl:otherwise>
                </xsl:choose>    			                        			           
                <xsl:text>, </xsl:text>
                <xsl:value-of select="substring-before($pAccessDate,'-')"/>
            </xsl:when>
            <xsl:when test="substring-before(substring-after($pAccessDate,'-'),'-')='08'">
                <xsl:text>August </xsl:text>
                <xsl:choose>
                    <xsl:when test="substring(substring-after(substring-after($pAccessDate,'-'),'-'),1,1)='0'">
                        <xsl:value-of select="substring(substring-after(substring-after($pAccessDate,'-'),'-'),2,1)"/>        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-after(substring-after($pAccessDate,'-'),'-')"/>
                    </xsl:otherwise>
                </xsl:choose>    			                        			           
                <xsl:text>, </xsl:text>
                <xsl:value-of select="substring-before($pAccessDate,'-')"/>
            </xsl:when>
            <xsl:when test="substring-before(substring-after($pAccessDate,'-'),'-')='09'">
                <xsl:text>September </xsl:text>
                <xsl:choose>
                    <xsl:when test="substring(substring-after(substring-after($pAccessDate,'-'),'-'),1,1)='0'">
                        <xsl:value-of select="substring(substring-after(substring-after($pAccessDate,'-'),'-'),2,1)"/>        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-after(substring-after($pAccessDate,'-'),'-')"/>
                    </xsl:otherwise>
                </xsl:choose>    			                        			           
                <xsl:text>, </xsl:text>
                <xsl:value-of select="substring-before($pAccessDate,'-')"/>
            </xsl:when>
            <xsl:when test="substring-before(substring-after($pAccessDate,'-'),'-')='10'">
                <xsl:text>October </xsl:text>
                <xsl:choose>
                    <xsl:when test="substring(substring-after(substring-after($pAccessDate,'-'),'-'),1,1)='0'">
                        <xsl:value-of select="substring(substring-after(substring-after($pAccessDate,'-'),'-'),2,1)"/>        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-after(substring-after($pAccessDate,'-'),'-')"/>
                    </xsl:otherwise>
                </xsl:choose>    			                        			           
                <xsl:text>, </xsl:text>
                <xsl:value-of select="substring-before($pAccessDate,'-')"/>
            </xsl:when>
            <xsl:when test="substring-before(substring-after($pAccessDate,'-'),'-')='11'">
                <xsl:text>November </xsl:text>
                <xsl:choose>
                    <xsl:when test="substring(substring-after(substring-after($pAccessDate,'-'),'-'),1,1)='0'">
                        <xsl:value-of select="substring(substring-after(substring-after($pAccessDate,'-'),'-'),2,1)"/>        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-after(substring-after($pAccessDate,'-'),'-')"/>
                    </xsl:otherwise>
                </xsl:choose>    			                        			           
                <xsl:text>, </xsl:text>
                <xsl:value-of select="substring-before($pAccessDate,'-')"/>
            </xsl:when>
            <xsl:when test="substring-before(substring-after($pAccessDate,'-'),'-')='12'">
                <xsl:text>December </xsl:text>
                <xsl:choose>
                    <xsl:when test="substring(substring-after(substring-after($pAccessDate,'-'),'-'),1,1)='0'">
                        <xsl:value-of select="substring(substring-after(substring-after($pAccessDate,'-'),'-'),2,1)"/>        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-after(substring-after($pAccessDate,'-'),'-')"/>
                    </xsl:otherwise>
                </xsl:choose>    			                        			           
                <xsl:text>, </xsl:text>
                <xsl:value-of select="substring-before($pAccessDate,'-')"/>
            </xsl:when>    			        
        </xsl:choose>    			    	    
    </xsl:template>
    
</xsl:stylesheet>