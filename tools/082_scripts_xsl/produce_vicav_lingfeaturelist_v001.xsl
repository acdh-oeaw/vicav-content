<xsl:stylesheet version="1.0" xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/>

    <!-- <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    -->
    <xsl:strip-space elements="tei:cell"/>
    
    <xsl:variable name="id"     select="//tei:row[normalize-space(tei:cell[1]) = 'ID']/tei:cell[2]/normalize-space(.)"/>
    <xsl:variable name="author" select="//tei:row[normalize-space(tei:cell[1]) = 'Author']/tei:cell[2]/normalize-space(.)"/>
    <xsl:variable name="date" select="//tei:row[normalize-space(tei:cell[1]) = 'Date']/tei:cell[2]/normalize-space(.)"/>
    <xsl:variable name="title" select="//tei:row[normalize-space(tei:cell[1]) = 'Title']/tei:cell[2]/normalize-space(.)"/>
    
    
    <xsl:template match="/">
        <TEI>
            <xsl:attribute name="xml:id"><xsl:value-of select="$id"/></xsl:attribute>
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title><xsl:value-of select="$title"/></title>
                        <author><xsl:value-of select="$author"/></author>
                    </titleStmt>
                    <publicationStmt>
                        <publisher>ACDH-OeAW</publisher>
                        <pubPlace>Vienna</pubPlace>
                        <date><xsl:value-of select="$date"/></date>
                        <availability status="restricted">
                            <p><ref type="license" target="http://creativecommons.org/licenses/by-nc-sa/3.0/"/></p>
                        </availability>
                    </publicationStmt>
                    <sourceDesc>
                        <p>This is an original digital text</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            
            <text><body><xsl:apply-templates/></body></text>            
        </TEI>
    </xsl:template>
    
    
    
    <xsl:template match="tei:cell">
        <cell>
            <xsl:choose>
                <xsl:when test="count(preceding-sibling::tei:cell) = 0">
                    <xsl:attribute name="rend">tdLeft</xsl:attribute>
                </xsl:when>
                <xsl:when test="count(preceding-sibling::tei:cell) = 1">
                    <xsl:attribute name="rend">tdCom</xsl:attribute>
                </xsl:when>
                <xsl:when test="count(preceding-sibling::tei:cell) = 2">
                    <xsl:attribute name="rend">tdCentre</xsl:attribute>
                </xsl:when>
                <xsl:when test="count(preceding-sibling::tei:cell) = 3">
                    <xsl:attribute name="rend">tdRight</xsl:attribute>
                </xsl:when>
                <xsl:when test="count(preceding-sibling::tei:cell) = 4">
                    <xsl:attribute name="rend">tdID</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </cell>
    </xsl:template>
    
    <xsl:template match="tei:cell[normalize-space(.) = 'METADATA']"/>
        
    
    
    <xsl:template match="tei:hi">
        <hi>
            <xsl:attribute name="rend">
                <xsl:choose>
                    <xsl:when test="@rend='color(FF0000)'">red</xsl:when>
                    <xsl:otherwise><xsl:value-of select="@rend"/></xsl:otherwise>
                </xsl:choose>                
            </xsl:attribute>
            <xsl:apply-templates/>
        </hi>
    </xsl:template>

    <xsl:template match="tei:row">
        <row><xsl:apply-templates/></row>
    </xsl:template>

    <xsl:template match="tei:table">
        <table><xsl:apply-templates/></table>
    </xsl:template>

    <xsl:template match="tei:teiHeader"/>
</xsl:stylesheet>
