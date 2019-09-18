<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0" 
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:output indent="yes" method="xml"/>
    <xsl:strip-space elements="tei:cell tei:div tei:body"/>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:param name="path-to-vt_lex">file:/home/dschopper/data/vicav-content/vocabs/vt_lex.rdf</xsl:param>
    <xsl:template match="tei:div[tei:table]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:table">
        <xsl:for-each-group select="tei:row" group-starting-with="self::tei:row[every $c in tei:cell[position() gt 1] satisfies not($c/node())]">
            <div>
                <head><xsl:value-of select="tei:cell[1]/tei:hi"/></head>
                <xsl:apply-templates select="current-group()[position() gt 1]"/>
            </div>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="tei:row">
        
        <!-- TODO implement check whether the "seme" really exists or not -->
        <xsl:variable name="sem" select="doc($path-to-vt_lex)//skos:prefLabel[. = current()/tei:cell[1]]" as="item()*"/>
        <xsl:variable name="sem-ref" select="$sem/parent::skos:Concept/@rdf:about"/>
        <cit>
            <xsl:if test="exists($sem)">
                <xsl:attribute name="ana" select="concat('vtLex:', substring-after($sem/../@rdf:about,'#'))"/>
            </xsl:if>
            <xsl:if test="tei:cell[1] != ''">
                <lbl><xsl:apply-templates select="tei:cell[1]"/></lbl>
            </xsl:if>
            <xsl:if test="tei:cell[2] != ''">
                <note><xsl:apply-templates select="tei:cell[2]"/></note>
            </xsl:if>
            <quote xml:lang="en"><xsl:apply-templates select="tei:cell[3]"/></quote>
            <cit type="translation">
                <quote xml:lang="ar"><xsl:apply-templates select="tei:cell[4]"/></quote>
            </cit>
            <cit type="translation">
                <quote xml:lang="de"><xsl:apply-templates select="tei:cell[5]"/></quote>
            </cit>
        </cit>
    </xsl:template>
    
    <xsl:template match="@ana">
        <xsl:choose>
            <xsl:when test="starts-with(., '#vt_lex')">
                <xsl:attribute name="ana" select="replace(.,'#vt_lex_','semLib:')"/>
            </xsl:when>
            <xsl:when test="matches(., '#vt_morph')">
                <xsl:attribute name="ana" select="replace(.,'#vt_morph_','fvLib:')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:hi[@rend = 'red']">
       <xsl:apply-templates/> 
    </xsl:template>
    
    <xsl:template match="tei:cell">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:w|tei:pc">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:if test="exists(following-sibling::*) and not(following-sibling::*[1]/self::tei:seg[@type = 'ws'])">
                <xsl:attribute name="join">right</xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:seg[@type = 'ws']"/>
        
    
</xsl:stylesheet>