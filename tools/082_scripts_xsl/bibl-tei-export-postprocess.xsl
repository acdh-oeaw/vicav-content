<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    <xsl:template match="tei:listBibl">
        <xsl:variable name="bibls" as="item()*">
            <xsl:apply-templates select="tei:biblStruct"/>
        </xsl:variable>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:for-each select="$bibls">
                <xsl:sort select="normalize-space(@n)" order="ascending"/>
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:biblStruct">
       <xsl:copy>
           <xsl:choose>
               <xsl:when test="starts-with(@corresp,'http')">
                   <xsl:attribute name="corresp" select="substring-after(@corresp,'items/')"/>
               </xsl:when>
               <xsl:otherwise>
                   <xsl:copy-of select="@corresp"/>
               </xsl:otherwise>
           </xsl:choose>
           <xsl:attribute name="n">
               <xsl:variable name="authors" select="(descendant::tei:author|descendant::tei:editor)" as="item()*"/>
               <xsl:choose>
                   <xsl:when test="count($authors) gt 2">
                       <xsl:value-of select="concat($authors[1]/(tei:surname, tei:name)[1], ' et al.')"/>
                   </xsl:when>
                   <xsl:otherwise>
                       <xsl:value-of select="string-join($authors/(tei:surname, tei:name)[1],', ')"/>
                   </xsl:otherwise>
               </xsl:choose>
               <xsl:text>: „</xsl:text>
               <xsl:value-of select="descendant::tei:title/substring(., 1, 25)"/>
               <xsl:text>...“ (</xsl:text>
               <xsl:value-of select="descendant::tei:date"/>
               <xsl:text>)</xsl:text>
           </xsl:attribute>
           <xsl:copy-of select="@* except (@corresp|@n)|node()"/>
           <xsl:apply-templates/>
       </xsl:copy>
    </xsl:template>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>




