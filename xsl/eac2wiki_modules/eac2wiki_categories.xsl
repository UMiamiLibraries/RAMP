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
    
    <!-- Include some basic categories. -->
    <xsl:template name="tCategories">
        <xsl:param name="pNameType" />
        <xsl:param name="pBiogHist" />
        <xsl:text>&#10;</xsl:text>
        <xsl:if test="$pNameType='person'">
        	<!-- Output birth and death categories, if applicable. -->
        	<xsl:variable name="vBirthTest">
        		<xsl:call-template name="tNameDateParser">
        			<xsl:with-param name="pBirthYr" select="'true'" />
        			<xsl:with-param name="pCheckInfo" select="'false'" />
        		</xsl:call-template>	
        	</xsl:variable>
        	<xsl:variable name="vDeathTest">
        		<xsl:call-template name="tNameDateParser">
        			<xsl:with-param name="pDeathYr" select="'true'" />
        			<xsl:with-param name="pCheckInfo" select="'false'" />
        		</xsl:call-template>	
        	</xsl:variable>
            <xsl:if test="$vBirthTest != '' or $vDeathTest != ''">
                <xsl:text>&lt;!-- Note: The following categories have been generated from birth/death dates in the EAC record. These categories should be uncommented when the article is ready to go live.</xsl:text>
                <xsl:text>&#10;</xsl:text>  
                <xsl:text>&#10;</xsl:text>                  
                <xsl:if test="$vBirthTest != ''">
            		<xsl:text>[[Category:</xsl:text>
            		<xsl:value-of select="$vBirthTest"/>
            		<xsl:text> births]]</xsl:text>
            		<xsl:text>&#10;</xsl:text>        
            	</xsl:if>
            	<xsl:if test="$vDeathTest != ''">
            		<xsl:text>[[Category:</xsl:text>
            		<xsl:value-of select="$vDeathTest"/>
            		<xsl:text> deaths]]</xsl:text>
            		<xsl:text>&#10;</xsl:text>            	          	   
            	</xsl:if>                
                <xsl:text>&#10;</xsl:text>    
                <xsl:text>--&gt;</xsl:text>
                <xsl:text>&#10;</xsl:text>
            </xsl:if>            
            <xsl:if test="eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType[contains(.,'6')]]|eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType='subject']">                
                <xsl:text>&lt;!-- Note: The following categories have been generated from the EAC input form, the original EAD finding aid, or else using FAST headings added from WorldCat Identities. These categories should be replaced with appropriate Wikipedia categories (for example, using the HotCat tool).</xsl:text>                
                <xsl:text>&#10;</xsl:text>
                <xsl:for-each select="eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType[contains(.,'6')]]|eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType='subject']">
                    <xsl:sort select="translate(eac:term,'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
                    <xsl:text>[[Category:</xsl:text>
                    <xsl:value-of select="normalize-space(eac:term)" />
                    <xsl:text>]]</xsl:text>
                    <xsl:text>&#10;</xsl:text>                    
                </xsl:for-each>                
                <xsl:text>--&gt;</xsl:text>
                <xsl:text>&#10;</xsl:text>
            </xsl:if>
            <!-- Output some sample thematic categories, along with stub template, if appropriate. NB: This is an area to developed. -->
            <xsl:choose>
                <xsl:when test="contains($pBiogHist,'Cuban')">
                    <xsl:if test="contains($pBiogHist,'exiled') or contains(eac:eac-cpf/eac:cpfDescription/eac:relations/eac:resourceRelation/eac:objectXMLWrap/ead:scopecontent, 'exiled')">
                        <xsl:text>[[Category:Cuban exiles]]</xsl:text>
                    </xsl:if>
                    <xsl:if test="contains($pBiogHist,'novelist')">
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>[[Category:Cuban novelists]]</xsl:text>
                    </xsl:if>
                    <xsl:if test="contains($pBiogHist,'anthropologist') or contains($pBiogHist,'anthropology')">
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>[[Category:Cuban anthropologists]]</xsl:text>
                    </xsl:if>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>&lt;!-- </xsl:text>
                    <xsl:text>The following category will not be displayed; it will add the present article to a tracking page for all articles that have been worked on using the RAMP editor. See https://en.wikipedia.org/wiki/Category:Articles_with_information_extracted_by_the_RAMP_editor</xsl:text>
                    <xsl:text> --&gt;</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>[[Category:Articles with information extracted by the RAMP editor]]</xsl:text>
                    <!-- If the person bio is less than 5000 characters, consider it a stub. -->
                    <xsl:if test="string-length($pBiogHist) &lt; 5000">
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>{{Cuba-bio-stub}}</xsl:text>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="string-length($pBiogHist) &lt; 5000">
                        <xsl:text>&#10;</xsl:text>                        
                        <xsl:text>&#10;</xsl:text>
                        <xsl:text>{{Bio-stub}}</xsl:text>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$pNameType='corporate'">            
            <xsl:if test="eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType[contains(.,'6')]|@localType='subject']">
                <xsl:text>&lt;!-- Note: The following categories have been generated from the the EAC input form, the original EAD finding aid, or else using FAST headings added from WorldCat Identities. These categories should be replaced with appropriate Wikipedia categories (for example, using the HotCat tool).</xsl:text>
                <xsl:text>&#10;</xsl:text>                    
                <xsl:for-each select="eac:eac-cpf/eac:cpfDescription/eac:description/eac:localDescription[@localType[contains(.,'6')]|@localType='subject']">
                    <xsl:sort select="translate(eac:term,'ÁÀÉÈÍÓÚÜÑáàéèíóúúüñ','AAEEIOUUNaaeeiouuun')" data-type="text" />
                    <xsl:text>[[Category:</xsl:text>
                    <xsl:value-of select="normalize-space(.)" />
                    <xsl:text>]]</xsl:text>     
                    <xsl:text>&#10;</xsl:text>
                </xsl:for-each>                    
                <xsl:text> --&gt;</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>&lt;!-- </xsl:text>
                <xsl:text>The following category will not be displayed; it will add the present article to a tracking page for all articles that have been worked on using the RAMP editor. See https://en.wikipedia.org/wiki/Category:Articles_with_information_extracted_by_the_RAMP_editor</xsl:text>
                <xsl:text> --&gt;</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>[[Category:Articles with information extracted by the RAMP editor]]</xsl:text>
                <xsl:if test="string-length($pBiogHist) &lt; 5000">
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>&#10;</xsl:text>                        
                </xsl:if>
            </xsl:if>
            <!-- If the corporate body bio is less than 5000 characters, consider it a stub. -->
            <xsl:if test="string-length($pBiogHist) &lt; 5000">
                <xsl:text>{{Org-stub}}</xsl:text>
            </xsl:if>            
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>