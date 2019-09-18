<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:vicav="https://vicav.acdh.oeaw.ac.at"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:s="http://purl.oclc.org/dsdl/schematron"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:param name="path-to-vicav_dialects">../../vocabs/vicav_dialects.rdf</xsl:param>
    <xsl:function name="vicav:getParentConcepts">
        <xsl:param name="c" as="element(skos:Concept)"/>
        <xsl:variable name="parent" as="element(skos:Concept)?">
            <xsl:choose>
                <xsl:when test="$c/skos:broader/skos:Concept">
                    <xsl:sequence select="$c/skos:broader/skos:Concept"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="root($c)//skos:Concept[@rdf:about = $c/skos:broader/@rdf:resource]"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="$parent, if (exists($parent)) then vicav:getParentConcepts($parent) else ()"/>
    </xsl:function>
    
    <xsl:function name="vicav:expandParentConcepts">
        <xsl:param name="c" as="element(skos:Concept)"/>
        <xsl:variable name="parents" select="vicav:getParentConcepts($c)"/>
        <xsl:value-of select="string-join((reverse($parents/skos:prefLabel/text()), $c/skos:prevLabel),' › ')"/>
    </xsl:function>
    
    <xsl:template match="s:rule[@context = 'tei:div[@type = ''typology'']/tei:p[1]']">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:comment>inserted by injectSKOS.xsl</xsl:comment>
           <xsl:variable name="paths" as="xs:string+">
               <xsl:for-each select="doc($path-to-vicav_dialects)//skos:Concept[not(skos:narrower)]">
                   <xsl:value-of select="concat('''',vicav:expandParentConcepts(.),'''')"/>
               </xsl:for-each>
           </xsl:variable>
            <s:assert test=". = ({string-join($paths,', ')})">typology must match one path of the SKOS Taxonomy of dialects</s:assert>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>