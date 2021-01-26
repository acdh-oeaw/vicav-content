<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="tei:entry[not(.//tei:f['status']/tei:symbol[@value = 'released'])]"/>
    <xsl:template match="tei:cit[not(.//tei:f['status']/tei:symbol[@value = 'released'])]"/>
    
    <xsl:template match="text()[normalize-space(.) = '']"/>
    
    <xsl:template match="tei:fs">
        <xsl:copy>
            <xsl:attribute name="xml:space" namespace="http://www.w3.org/XML/1998/namespace">preserve</xsl:attribute>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>