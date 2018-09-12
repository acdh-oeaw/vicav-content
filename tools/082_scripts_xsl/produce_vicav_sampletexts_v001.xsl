<xsl:stylesheet version="1.0" xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/>

    <!-- <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    -->
    <xsl:template match="/">
        <TEI>
            <xsl:attribute name="xml:id"><xsl:value-of select="//tei:table[2]/tei:row[tei:cell='ID']/tei:cell[2]"/></xsl:attribute>
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>
                            <!-- <xsl:value-of select="//tei:table[2]/tei:row[tei:cell='Title']/tei:cell[2]"/> -->
                            <xsl:value-of select="//tei:body[1]/tei:head[1]/tei:hi[1]"/>                            
                        </title>
                        <author>
                            <!-- <xsl:value-of select="//tei:table[2]/tei:row[tei:cell='Author']/tei:cell[2]"/> -->
                            <xsl:value-of select="//tei:fileDesc[1]/tei:titleStmt[1]/tei:author[1]"/>
                        </author>
                    </titleStmt>
                    <publicationStmt>
                        <publisher>ACDH-OeAW</publisher>
                        <pubPlace>Vienna</pubPlace>
                        <date><xsl:value-of select="//tei:table[2]/tei:row[tei:cell='Date']/tei:cell[2]"/></date>
                        <availability status="restricted">
                            <p><ref type="license" target="http://creativecommons.org/licenses/by-nc-sa/3.0/"/></p>
                        </availability>
                    </publicationStmt>
                    <sourceDesc>
                        <p>This is an original digital text</p>
                    </sourceDesc>
                </fileDesc>
                <xsl:if test="string-length(//tei:table[2]/tei:row[tei:cell='Informants']/tei:cell[2])&gt;0">
                    <profileDesc>
                        <particDesc><p><xsl:value-of select="//tei:table[2]/tei:row[tei:cell='Informants']/tei:cell[2]"/></p></particDesc>
                    </profileDesc>                        
                </xsl:if>
            </teiHeader>
            
            <text>
                <body>
                    <!-- ********************************* -->
                    <!-- ********* TITLE ***************** -->
                    <!-- ********************************* -->
                    <head><xsl:value-of select="//tei:head"/></head>

                    <!-- ********************************* -->
                    <!-- ********* GEO-INFO ************** -->
                    <!-- ********************************* -->
                    <div type="positioning">
                        <p><geo><xsl:value-of select="//tei:table[2]/tei:row[tei:cell='Geolocation']/tei:cell[2]"/></geo></p>
                    </div>
                    
                    <!-- ********************************* -->
                    <!-- ********* TEXT ****************** -->
                    <!-- ********************************* -->
                    <div type="sampleText"><p><xsl:apply-templates/></p></div>

                    <!-- ********************************* -->
                    <!-- ********* TRANSLATIONS ********** -->
                    <!-- ********************************* -->
                    <div type="dvTranslations"><p>
                        <xsl:for-each select="//tei:table[last()]/tei:row">
                            <!-- <xsl:if test="position()&gt;1"> -->
                                <s type="translationSentence"><xsl:attribute name="n"><xsl:value-of select="position()-1"/></xsl:attribute>
                                    <xsl:value-of select="tei:cell"/></s>
                            <!-- </xsl:if> -->
                        </xsl:for-each>
                    </p></div>
                </body>
            </text>            
        </TEI>
    </xsl:template>

    <xsl:template match="tei:cell">
        <cell>
            <xsl:choose>
                <xsl:when test="count(preceding-sibling::tei:cell) = 0">
                    <xsl:attribute name="rend">num1</xsl:attribute>
                </xsl:when>
                <xsl:when test="count(preceding-sibling::tei:cell) = 1">
                    <xsl:attribute name="rend">num2</xsl:attribute>
                </xsl:when>
                <xsl:when test="count(preceding-sibling::tei:cell) = 2">
                    <xsl:attribute name="rend">num3</xsl:attribute>
                </xsl:when>
                <xsl:when test="count(preceding-sibling::tei:cell) = 3">
                    <xsl:attribute name="rend">num4</xsl:attribute>
                </xsl:when>
                <xsl:when test="count(preceding-sibling::tei:cell) = 4">
                    <xsl:attribute name="rend">num5</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </cell>
    </xsl:template>

    <xsl:template match="tei:head"></xsl:template>
    
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


    <xsl:template match="tei:list"></xsl:template>
    
    <xsl:template match="tei:p"></xsl:template>
    
    <xsl:template match="tei:row">
        <xsl:choose>
            <xsl:when test="contains(./tei:cell[2], '-c-')"><c><xsl:value-of select="tei:cell[1]"/></c></xsl:when>
            <xsl:otherwise>
                <w>
                    <fs>
                        <f name="wordform"><xsl:value-of select="tei:cell[1]"/></f>
                        <f name="pos"><xsl:value-of select="tei:cell[2]"/></f>
                        <f name="lemma"><xsl:value-of select="tei:cell[3]"/></f>
                        <f name="translation"><xsl:value-of select="tei:cell[4]"/></f>
                        <f name="other"><xsl:value-of select="tei:cell[5]"/></f>
                    </fs>
                </w>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:table">
        <xsl:choose>
            <!-- <xsl:when test="position()=1 or position()=2 or position()=3  or position()=4 "></xsl:when> -->
            <xsl:when test="count(preceding-sibling::tei:table)=10"></xsl:when>
            <xsl:otherwise>
                <s>
                    <xsl:attribute name="n"><xsl:value-of select="count(preceding-sibling::tei:table)"/></xsl:attribute>
                    <xsl:apply-templates/>
                </s>               
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
       
    <xsl:template match="tei:teiHeader"/>
</xsl:stylesheet>
