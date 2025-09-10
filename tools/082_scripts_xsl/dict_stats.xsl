<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="files" as="element()+">
        <file>dc_acm_baghdad_eng_001.xml</file>
        <file>dc_apc_eng_publ.xml</file>
        <file>dc_ar_en_publ.xml</file>
        <file>dc_arz_eng_publ.xml</file>
        <file>dc_tunico.xml</file>
    </xsl:param>
    <xsl:template match="/" xml:base="file:/home/danielschopper/data/vicav-content/vicav_dicts/">
        <stats>
            <xsl:for-each select="$files">
                <xsl:variable name="fn" select="."/>
                <xsl:variable name="doc" select="doc($fn)"/>
                <xsl:variable name="title" select="$doc//tei:teiHeader//tei:titleStmt/tei:title"/>
                <xsl:variable name="lemmas" select="$doc//tei:form[@type='lemma']"/>
                <xsl:variable name="wordforms" select="$doc//tei:form[@type][@type!='lemma']"/>
                <xsl:variable name="translations" select="$doc//tei:cit[@type='translation']"/>
                <xsl:variable name="languages" select="distinct-values($doc//tei:cit[@type='translation']/@xml:lang)"/>
                <dict fn="{$fn}">
                    <xsl:sequence select="$title"/>
                    <lemmas><xsl:value-of select="count($lemmas)"/></lemmas>
                    <wordforms><xsl:value-of select="count($wordforms)"/></wordforms>
                    <translations><xsl:value-of select="count($translations)"/></translations>
                    <languages><xsl:value-of select="$languages"/></languages>
                </dict>
                <lemmas>
                    
                </lemmas>
            </xsl:for-each>
        </stats>
    </xsl:template>
</xsl:stylesheet>