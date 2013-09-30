<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    
    <!--
        Author: Timothy A. Thompson
        University of Miami Libraries
        Copyright 2013 University of Miami. Licensed under the Educational Community License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://opensource.org/licenses/ECL-2.0 http://www.osedu.org/licenses/ECL-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
    -->
    
    <!--
        eacFileListGenerator.xsl outputs a list of EAC-CPF files in a directory. 
        It is intended to be run on a directory of EAC-CPF files that have first been renamed using the eac2eadMatch.sh script.        
    -->

    <xsl:template match="/">
        <creators>
            <xsl:for-each
                select="for $x in collection('eac?select=*.xml;recurse=yes;on-error=ignore') return $x">
                <xsl:if test="not(contains(document-uri(.),'-') or contains(document-uri(.),'other'))">
                    <eac filename="{document-uri(.)}">
                        <xsl:value-of select="document-uri(.)"/>
                    </eac>
                </xsl:if>
            </xsl:for-each>
        </creators>
    </xsl:template>

</xsl:stylesheet>
