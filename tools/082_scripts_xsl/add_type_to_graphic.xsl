<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all"
    xmlns="http://www.tei-c.org/ns/1.0"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:teiHeader[not(tei:revisionDesc)]">
        <xsl:variable name="revisionDesc" as="element(tei:revisionDesc)">
            <revisionDesc/>
        </xsl:variable>
        <xsl:copy>
            <xsl:copy-of select="@*|node()"/>
            <xsl:apply-templates select="$revisionDesc"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <xsl:copy-of select="@*|node()"/>
            <change who="#DS" when="2025-04-14" type="minor">adding @type on tei:graphic (add_type_to_graphic.xsl)</change>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:graphic[not(@type)]">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="type">thumbnail</xsl:attribute>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>