<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
    xmlns:rl="http://schemas.openxmlformats.org/package/2006/relationships"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all"
    version="2.0">

    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="p w:p w:r w:t"/>
    
    <xsl:template match="/">
        
        <xsl:variable name="author">
            <xsl:for-each select="//tei:p[@rend = 'author']|//w:p[w:pPr/w:pStyle/@w:val = 'author']/w:r/w:t"><xsl:value-of select="."/></xsl:for-each>
        </xsl:variable>                
        
        
        <xsl:variable name="xmlID">
            <xsl:for-each select="//tei:p[@rend = 'xmlID']|//w:p[w:pPr/w:pStyle/@w:val='xmlID']/w:r/w:t"><xsl:value-of select="."/></xsl:for-each>
        </xsl:variable>                
        
        <xsl:variable name="locNameEng">
            <xsl:for-each select="//tei:p[@rend = 'locNameEng']|//w:p[w:pPr/w:pStyle/@w:val='locNameEng']/w:r/w:t"><xsl:value-of select="."/></xsl:for-each>
        </xsl:variable>

        <xsl:variable name="imageCopyright">
            <xsl:for-each select="//tei:p[@rend = 'imageCopyright']|//w:p[w:pPr/w:pStyle/@w:val='imageCopyright']/w:r/w:t"><xsl:value-of select="."/></xsl:for-each>
        </xsl:variable>
        
        <xsl:variable name="image">
            <xsl:for-each select="//tei:p[@rend = 'image']|//w:p[w:pPr/w:pStyle/@w:val='image']/w:r/w:t"><xsl:value-of select="."/></xsl:for-each>
        </xsl:variable>

        <xsl:variable name="locNameFusha">
            <xsl:for-each select="//tei:p[@rend = 'locNameFusha'] | //w:p[w:pPr/w:pStyle/@w:val='locNameFusha']/w:r/w:t"><xsl:value-of select="."/></xsl:for-each>
        </xsl:variable>
        
        <xsl:variable name="locNameLoc">
            <xsl:for-each select="//tei:p[@rend = 'locNameLoc'] | //w:p[w:pPr/w:pStyle/@w:val='locNameLoc']/w:r/w:t"><xsl:value-of select="."/></xsl:for-each>
        </xsl:variable>
        
        <xsl:variable name="locNameFushaAr">
            <xsl:for-each select="//tei:p[@rend = 'locNameFushaAr'] | //w:p[w:pPr/w:pStyle/@w:val='locNameFushaAr']/w:r/w:t"><xsl:value-of select="."/></xsl:for-each>
        </xsl:variable>
        
        <xsl:variable name="geo">
            <xsl:for-each select="//tei:p[@rend = 'geo'] | //w:p[w:pPr/w:pStyle/@w:val='geo']/w:r/w:t"><xsl:value-of select="."/></xsl:for-each>
        </xsl:variable>
        
        <xsl:variable name="typology">
            <xsl:for-each select="//tei:p[@rend = 'typology'] | //w:p[w:pPr/w:pStyle/@w:val='typology']/w:r/w:t"><xsl:value-of select="."/></xsl:for-each>
        </xsl:variable>
        
        <xsl:variable name="typologyGen">
            <xsl:for-each select="//tei:p[@rend = 'typologyGen'] | //w:p[w:pPr/w:pStyle/@w:val='typologyGen']/w:r/w:t"><xsl:value-of select="."/></xsl:for-each>
        </xsl:variable>
        
        <xsl:variable name="general" select="//tei:p[@rend = 'gen'] | //w:p[w:pPr/w:pStyle/@w:val='gen']" as="item()*"/>
        <xsl:variable name="researchHistory" select="//tei:p[@rend = 'researchHistory'] | //w:p[w:pPr/w:pStyle/@w:val='researchHistory']" as="item()*"/>
        <xsl:variable name="dicts" select="//tei:p[@rend = 'dicts'] | //w:p[w:pPr/w:pStyle/@w:val='dicts']" as="item()*"/>
        <xsl:variable name="textbooks" select="//tei:p[@rend = 'textbooks'] | //w:p[w:pPr/w:pStyle/@w:val='textbooks']" as="item()*"/>
        <xsl:variable name="audio" select="//tei:p[@rend = 'audio'] | //w:p[w:pPr/w:pStyle/@w:val='audio']" as="item()*"/>
        <xsl:variable name="biblio" select="//tei:p[@rend = 'biblio'] | //w:p[w:pPr/w:pStyle/@w:val='biblio']" as="item()*"/>
        <xsl:variable name="sample" select="//tei:p[@rend = 'sample'] | //w:p[w:pPr/w:pStyle/@w:val='sample']" as="item()*"/>
        <xsl:variable name="lingfeatures" select="//tei:p[@rend = 'lingfeatures'] | //w:p[w:pPr/w:pStyle/@w:val='lingfeatures']" as="item()*"/>
        <TEI>
            <xsl:attribute name="xml:id"><xsl:value-of select="$xmlID"/></xsl:attribute>
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>A machine-readable profile of <xsl:value-of select="$locNameEng"/> Arabic</title>
                        <author><xsl:value-of select="$author"/></author>
                    </titleStmt>
                    <publicationStmt>
                        <publisher>ACDH-OeAW</publisher>
                        <pubPlace>Vienna</pubPlace>
                        <date>2018</date>
                        <availability status="restricted">
                            <p>
                                <ref type="license" target="http://creativecommons.org/licenses/by-nc-sa/3.0/"/>
                            </p>
                        </availability>
                    </publicationStmt>
                    <sourceDesc>
                        <p>This is an original digital text</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <div>
                        <p>PPP:<xsl:value-of select="base-uri()"/>
                            <xsl:value-of select="document('document.xml.rels')/node()[2]"/></p>
                        <head>
                            <xsl:if test="string-length($image)&gt;0">
                                <ref target="damaskus-moschee-hof-1985.jpg"><xsl:value-of select="$imageCopyright"/></ref>
                            </xsl:if>
                            <name xml:lang="eng"><xsl:value-of select="$locNameEng"/></name>

                            <xsl:if test="string-length($locNameFusha)&gt;0">
                                <name xml:lang="ara"><xsl:value-of select="$locNameFusha"/></name>
                            </xsl:if>
                            <xsl:if test="string-length($locNameLoc)&gt;0">
                                <name xml:lang="ara-x-DMG"><xsl:value-of select="$locNameLoc"/></name>
                            </xsl:if>
                            <xsl:if test="string-length($locNameFushaAr)&gt;0">
                                <name xml:lang="ajp" ><xsl:value-of select="$locNameFushaAr"/></name>
                            </xsl:if>                                                        
                        </head>
                        
                        <div type="positioning">
                            <p><geo><xsl:value-of select="$geo"/></geo></p>
                        </div>
                        
                        <div type="typology">
                            <p><xsl:value-of select="$typology"/></p>
                            <p><xsl:value-of select="$typologyGen"/></p>
                        </div>
                        
                        <div type="general">
                            <xsl:apply-templates select="$general"/>
                        </div>
                        
                        <div type="researchHistory">
                            <xsl:apply-templates select="$researchHistory"/>
                        </div>
                        
                        <div type="dictionaries">
                            <xsl:apply-templates select="$dicts"/>
                        </div>
                        
                        <div type="textBooks">
                            <xsl:apply-templates select="$textbooks"/>
                        </div>
                        
                        <div type="audioData">
                            <xsl:apply-templates select="$audio"/>
                        </div>
                        
                        <div type="bibliography">
                            <xsl:apply-templates select="$biblio"/>
                        </div>
                        
                        <div type="sampleText">
                            <xsl:apply-templates select="$sample"/>
                        </div>
                        
                        <div type="lingFeatures">
                            <xsl:apply-templates select="$lingfeatures"/>
                        </div>
                    </div>
                </body>
            </text>
        </TEI>
    </xsl:template>
    
     
    <xsl:template match="w:proofErr"/>
    
    <xsl:template match="tei:p | w:p">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="w:r">
        <xsl:choose>
            <xsl:when test="w:rPr/w:i"><hi rend="italic"><xsl:apply-templates/></hi></xsl:when>
            <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    

    <xsl:template match="tei:*" priority="-1">
            <xsl:copy>
                <xsl:apply-templates select="node() | @*"/>
            </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:*/@*">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <xsl:template match="w:hyperlink"><ref><xsl:attribute name="target"><xsl:value-of select="@r:id"/></xsl:attribute><xsl:apply-templates/></ref></xsl:template>
    
    <xsl:template match="text()">
        <xsl:choose>
            <xsl:when test="parent::w:t"><xsl:value-of select="."/></xsl:when>
            <xsl:otherwise><xsl:value-of select="normalize-space(.)"/></xsl:otherwise>
        </xsl:choose>        
    </xsl:template>            
    
</xsl:stylesheet>