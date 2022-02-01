<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:template match="/tei:TEI">
        <html>
            <h1><xsl:value-of select="//tei:titleStmt/tei:title"/></h1>
            <p><xsl:for-each select="//tei:titleStmt/(tei:author,tei:respStmt)">
                <xsl:value-of select="(tei:resp,'author')[.!=''][1]"/>
                <xsl:text>: </xsl:text>
                <xsl:value-of select="(tei:persName, .)[.!=''][1]"/>
                <br/>
            </xsl:for-each></p>
            <h2>Features</h2>
            <xsl:apply-templates select="tei:text//tei:fLib"/>
            <h2>Feature Values</h2>
            <xsl:apply-templates select="tei:text//tei:fvLib"/>
        </html>
    </xsl:template>
    
    
    <xsl:template match="tei:head">
        <h2><xsl:value-of select="."/></h2>
    </xsl:template>
    
    <xsl:template match="tei:fvLib">
        <h4><xsl:value-of select="@n"/> (Feature values)</h4>
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:fvLib/tei:fs">
        <li id="{@xml:id}"><code><xsl:value-of select="@xml:id"/></code> – composed of: <xsl:for-each select="tokenize(@feats,' ')"><a href="{.}"><xsl:value-of select="substring-after(.,'#')"/></a><xsl:text> </xsl:text></xsl:for-each></li>
    </xsl:template>

    <xsl:template match="tei:fLib">
        <h4><xsl:value-of select="@n"/> (Feature)</h4>
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:fLib/tei:f">
        <li id="{@xml:id}"><code><xsl:value-of select="@xml:id"/></code> – feature name: <xsl:value-of select="@name"/></li>
    </xsl:template>
</xsl:stylesheet>