<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    exclude-result-prefixes="#all"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
        <rdf:RDF>
            <skos:ConceptScheme rdf:about="https://vocabs.acdh.oeaw.ac.at/vicav/features">
                <dct:created rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">2019-09-13T14:10:54.518574+00:00</dct:created>
                <dc:description xml:lang="en">This concept scheme provides lists for grammatical and semantic features tagged in the various VICAV resources.</dc:description>
                <rdfs:label xml:lang="en">VICAV Features Scheme</rdfs:label>
                <dc:creator>Charly Mörth</dc:creator>
                <dc:contributor>Stephan Procházka</dc:contributor>
                <dc:publisher>Austrian Centre for Digital Humanities</dc:publisher>
                <dc:title xml:lang="en">VICAV Features Scheme</dc:title>
                <skos:hasTopConcept rdf:resource="https://vocabs.acdh.oeaw.ac.at/vicav/features#vt_lex"/>
                <xsl:for-each select="//tei:fLib">
                    <skos:hasTopConcept rdf:resource="https://vocabs.acdh.oeaw.ac.at/vicav/features#vt_{@n}"/>
                </xsl:for-each>
                <dc:language>en</dc:language>
            </skos:ConceptScheme>
            <xsl:apply-templates select="//tei:fLib"/>
        </rdf:RDF>
    </xsl:template>
    
    <xsl:template match="tei:fLib">
        <Concept rdf:about="https://vocabs.acdh.oeaw.ac.at/vicav/features#vt_{replace(@n,'\s','_')}" xmlns="http://www.w3.org/2004/02/skos/core#">
            <inScheme rdf:resource="https://vocabs.acdh.oeaw.ac.at/vicav/features"/>
            <topConceptOf rdf:resource="https://vocabs.acdh.oeaw.ac.at/vicav/features"/>
            <prefLabel xml:lang="en"><xsl:value-of select="@n"/></prefLabel>
            <xsl:for-each select="tei:f">
                <narrower rdf:resource="https://vocabs.acdh.oeaw.ac.at/vicav/features#vt_{@xml:id}"/>
            </xsl:for-each>
        </Concept>
        <xsl:apply-templates select="tei:f"/>
    </xsl:template>
    <xsl:template match="tei:fLib/tei:f">
        <Concept rdf:about="https://vocabs.acdh.oeaw.ac.at/vicav/features#vt_{@xml:id}" xmlns="http://www.w3.org/2004/02/skos/core#">
            <inScheme rdf:resource="https://vocabs.acdh.oeaw.ac.at/vicav/features"/>
            <broader rdf:resource="https://vocabs.acdh.oeaw.ac.at/vicav/features#vt_{replace(../@n,'\s','_')}"/>
            <prefLabel xml:lang="en"><xsl:value-of select="tei:symbol/@value"/></prefLabel>
        </Concept>
    </xsl:template>
</xsl:stylesheet>