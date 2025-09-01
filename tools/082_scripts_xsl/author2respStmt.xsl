<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs math tei"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>This stylesheet converts tei author elements to the more generic respStmt, as </desc>
    </doc>
    
    <xsl:template match="tei:teiHeader[not(tei:revisionDesc)]">
        <xsl:variable name="revisionDesc" as="element(tei:revisionDesc)">
            <revisionDesc/>
        </xsl:variable>
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
            <xsl:apply-templates select="$revisionDesc"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
            <change who="#DS" when="2025-08-28" type="minor">refactoring author and editor elements to respStmt (author2respStmt.xsl)</change>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:titleStmt[not(exists(//@xml:id[.='DS']))]" xml:space="preserve">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
            <respStmt>
                <resp>data management and conversion</resp>
                <name xml:id="DS">Daniel Schopper</name>
            </respStmt>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:author" xml:space="preserve">
        <respStmt>
            <name><xsl:sequence select="@xml:id"></xsl:sequence><xsl:value-of select="."/></name>
            <resp>author</resp>
        </respStmt>
    </xsl:template>
    
    <xsl:template match="tei:editor" xml:space="preserve">
        <respStmt>
            <name><xsl:sequence select="@xml:id"/><xsl:value-of select="."/></name>
            <resp><xsl:value-of select="(@role,'editor')[.!=''][1]"/></resp>
        </respStmt>
    </xsl:template>
</xsl:stylesheet>