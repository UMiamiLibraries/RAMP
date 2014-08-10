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
    
    <!-- Output timeline, if available. -->
    <xsl:template name="tTimeline">        
        <xsl:text>==Timeline==</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>{{timeline-start}}</xsl:text>
    	<xsl:text>&#10;</xsl:text>
        <xsl:for-each select="$pBiogHist/eac:chronList/eac:chronItem">
            <xsl:text>&#10;</xsl:text>
            <xsl:text>{{timeline-item|</xsl:text>
            <xsl:text>{{start date|</xsl:text>
            <xsl:choose>
                <xsl:when test="eac:date/@standardDate">
                    <xsl:value-of select="translate(eac:date/@standardDate,'-','|')" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="eac:dateRange/eac:fromDate" />
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="eac:dateRange/eac:toDate" />
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>}}|</xsl:text>
            <xsl:for-each select="eac:event">
                <xsl:value-of select="normalize-space(.)" />                
            </xsl:for-each>
        	<xsl:if test="position() = last()">        		        	
	        	<!-- For LOC finding aids, include a reference to the {{Cite LOC finding aid}} template. -->
	        	<xsl:if test="contains(../../../../../eac:control/eac:sources/eac:source/@xlink:href,'loc.')">            				            				        		
	        		<xsl:text>&lt;ref name="LOCMD"/&gt;</xsl:text>	        			        	
	        	</xsl:if>
        	</xsl:if>
            <xsl:text>}}</xsl:text>
            <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>{{timeline-end}}</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <!-- Alternative timeline formatting
        <xsl:choose>
            <xsl:when
                test="/eac:eac-cpf/eac:cpfDescription/eac:description/eac:biogHist/eac:chronList/eac:chronItem">
                <xsl:text>&#10;</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>==Chronology==</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>{{timeline-start}}</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>&#10;</xsl:text>
                <xsl:for-each
                    select="/eac:eac-cpf/eac:cpfDescription/eac:description/eac:biogHist/eac:chronList/eac:chronItem">
                    <xsl:text>{{Timeline-event|date=</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:choose>
                        <xsl:when test="eac:date">
                            <xsl:value-of select="eac:date"/>
                        </xsl:when>
                        <xsl:when test="eac:dateRange">
                            <xsl:value-of select="eac:fromDate"/>
                            <xsl:text>-</xsl:text>
                            <xsl:value-of select="eac:toDate"/>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>|event=</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:value-of select="eac:event"/>
                    <xsl:text> }}</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                </xsl:for-each>
                <xsl:text>&#10;</xsl:text>
                <xsl:text>{{timeline-end}}</xsl:text>
                <xsl:text>&#10;</xsl:text>
            </xsl:when>
        </xsl:choose> -->
    </xsl:template>
</xsl:stylesheet>