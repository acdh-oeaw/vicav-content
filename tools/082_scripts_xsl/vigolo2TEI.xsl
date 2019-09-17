<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/list">
        <xsl:comment>AUTOMATICALLY GENERATED FILE – do not edit! </xsl:comment>
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>VICAV place list</title>
                        <respStmt>
                            <resp>Technical editor</resp>
                            <name>Karlheinz Moerth</name>
                        </respStmt>
                    </titleStmt>
                    <publicationStmt>
                        <publisher>ACDH-OeAW</publisher>
                        <pubPlace>Vienna</pubPlace>
                        <date>2018</date>
                        <availability status="restricted">
                            <licence target="http://creativecommons.org/licenses/by-nc-sa/3.0/">CC BY NC SA 3.0</licence>
                        </availability>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Born digital.</p>
                    </sourceDesc>
                </fileDesc>
                <profileDesc>
                    <creation>This file was initially aggregated from tags in the <ref target="https://www.zotero.org/groups/2165756/vicav">VICAV bibliography</ref>, enhanced by <name>vigolo</name> and converted to TEI-XML by <name>tools/082_scripts_xsl/vigolo2TEI.xsl</name> <xsl:value-of select="current-dateTime()"/></creation>
                </profileDesc>
            </teiHeader>
            <text>
                <body>
                    <listPlace>
                        <xsl:for-each select="tokenize(.,'\n')[not(matches(., '^\s*$'))]">
                            <xsl:choose>
                                <xsl:when test="starts-with(., '????')">
                                    <xsl:comment select="."/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:analyze-string select="." regex="^(\p{{Ll}}+):(.+)\[(.+)\]\s+\{{(.+)\}}">
                                        <xsl:matching-substring>
                                            <place type="{regex-group(1)}" xml:id="{lower-case(replace(regex-group(2),'\P{L}',''))}">
                                                <placeName xml:lang="en"><xsl:value-of select="normalize-space(regex-group(2))"/></placeName>
                                                <xsl:if test="regex-group(3) != ''">
                                                    <location>
                                                        <geo><xsl:value-of select="regex-group(3)"/></geo>
                                                    </location>
                                                </xsl:if>
                                                <idno type="geonames"><xsl:value-of select="normalize-space(regex-group(4))"/></idno>
                                            </place>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </listPlace>
                </body>
            </text>
        </TEI>
        
    </xsl:template>
</xsl:stylesheet>