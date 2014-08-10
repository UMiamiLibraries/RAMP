<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eac="urn:isbn:1-931666-33-4"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:exsl="http://exslt.org/common"
    xmlns:xlink="http://www.w3.org/1999/xlink" extension-element-prefixes="exsl"
    exclude-result-prefixes="eac" version="1.0">
    
    <!-- Declare variables for basic pattern matching of strings. -->
    <xsl:variable name="vUpper" select="'AÁÀÄBCDEÉÈFGHIÍJKLMNÑOÓPQRSTUÚÜVWXYZ'" />
    <xsl:variable name="vLower" select="'aáàäbcdeéèfghiíjklmnñoópqrstuúüvwxyz'" />
    <xsl:variable name="vAlpha" select="concat($vUpper,$vLower,$vPunct)" />
    <xsl:variable name="vAlpha2" select="concat($vUpper,$vLower,$vPunct2)" />
    <xsl:variable name="vDigits" select="'0123456789'" />
    <xsl:variable name="vPunct" select="'$;:.¿?!()[]-“”’'" />
    <xsl:variable name="vPunct2" select="'$;:.¿?!()[]“”’'" />
    <xsl:variable name="vPunct3" select="',.'" />
    <xsl:variable name="vCommaSpace" select="', '" />
    <xsl:variable name="vQuote">"</xsl:variable>
    <xsl:variable name="vApos">'</xsl:variable>
    
</xsl:stylesheet>