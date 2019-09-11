<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:egXML="http://www.tei-c.org/ns/Examples" version="2.0" exclude-result-prefixes="xsl egXML tei">
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="tei:body tei:TEI tei:teiHeader tei:text tei:ref tei:p tei:fileDesc tei:titleStmt tei:publicationStmt tei:editionStmt tei:revisionDesc tei:sourceDesc tei:availability tei:div tei:div1 tei:div2 tei:div3 tei:div4 tei:div5"/>
    <xsl:variable name="title">
        <xsl:value-of select="//tei:titleStmt/tei:title"/>
    </xsl:variable>
  
    <xsl:template match="/">
        <html>
            <xsl:comment>This is a generated page, do not edit!</xsl:comment>
            <xsl:comment>Generated: <xsl:value-of select="current-dateTime()"/>
            </xsl:comment>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
                <link rel="stylesheet" type="text/css" href="guidelines.css"/>
                <link rel="stylesheet" type="text/css" href="docu.css"/>               
            </head>
            <body>
                <!-- <xsl:call-template name="continue-root"/> -->
                <xsl:apply-templates select="*"/>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="//tei:TEI">
        <div class="content guidelines">
            <div class="dvLeft" id="contents">                
                
                <h2 class="aH1Contents">Contents</h2>
                <xsl:for-each select="//tei:div">
                    <p class="tocEntry">
                        <xsl:choose>
                            <xsl:when test="count(ancestor::tei:div) = 1">
                                <a class="aH2Contents">
                                    <xsl:attribute name="href">#<xsl:value-of select="@xml:id"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="count(preceding::tei:div[count(ancestor::tei:div) = 1])+1"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="./tei:head"/>
                                </a>
                            </xsl:when>
                            <xsl:when test="count(ancestor::tei:div) = 2">
                                <a class="aH3Contents">
                                    <xsl:attribute name="href">#<xsl:value-of select="@xml:id"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="count(parent::tei:div/preceding-sibling::tei:div)+1"/>.<xsl:value-of select="count(preceding-sibling::tei:div)+1"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="./tei:head"/>
                                </a>
                            </xsl:when>
                            <xsl:when test="count(ancestor::tei:div) = 3">
                                <a class="aH4Contents">
                                    <xsl:attribute name="href">#<xsl:value-of select="@xml:id"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="count(parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/>.<xsl:value-of select="count(parent::tei:div/preceding-sibling::tei:div)+1"/>.<xsl:value-of select="count(preceding-sibling::tei:div)+1"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="./tei:head"/>
                                </a>
                            </xsl:when>
                        </xsl:choose>
                    </p>
                </xsl:for-each>
                <br/>
                <br/>
                    
            </div>
            
            <div class="dvRight">
                <!-- <xsl:apply-templates select="@* | node()"/> -->
                <xsl:apply-templates select="node()"/>
                <br/>
                <br/>
            </div>
        </div>
    </xsl:template>   
    
    
    <xsl:template match="tei:body | tei:teiHeader | tei:text">
        <div>
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="@type">
                        <xsl:value-of select="concat('tei-',name(), ' tei-type-', @type)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('tei-',name())"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:author | tei:bibl | tei:biblScope | tei:cit | tei:date | tei:def | tei:entry | tei:etym | tei:form | tei:gram | tei:gramGrp | tei:lang | tei:mentioned | tei:orth | tei:p | tei:quote | tei:sense | tei:usg">
        <p>
            <xsl:if test="@xml:id"><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute></xsl:if>
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="@type">
                        <xsl:value-of select="concat('tei-',name(), ' tei-type-', @type)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('tei-',name())"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="*" mode="egXML">
        <span>
            <xsl:if test="preceding-sibling::node()[1]/self::*">
                <xsl:text>
 </xsl:text>
            </xsl:if>
            <span class="spRed">
                <xsl:value-of select="concat('&lt;',local-name())"/>
            </span>
            <xsl:apply-templates select="@*" mode="egXML"/>
            <xsl:choose>
                <xsl:when test="node()">
                    <span class="spRed">
                        <xsl:text>&gt;</xsl:text>
                    </span>
                    <xsl:apply-templates mode="egXML"/>
                    <span class="spRed">
                        <xsl:text>&lt;/</xsl:text>
                        <xsl:value-of select="local-name()"/>
                        <xsl:text>&gt;</xsl:text>
                    </span>
                </xsl:when>
                <xsl:otherwise>
                    <span class="spRed">
                        <xsl:text>/&gt;</xsl:text>
                    </span>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>
    <xsl:template match="@*" mode="egXML">
        <span>
            <xsl:text> </xsl:text>
            <span class="spAttrName">
                <xsl:value-of select="local-name()"/>
            </span>
            <span class="spEquals">=</span>
            <span class="spQuotes">"</span>
            <span class="spValue">
                <xsl:value-of select="."/>
            </span>
            <span class="spQuotes">"</span>
        </span>
    </xsl:template>
    <xsl:template match="@xml:*" mode="egXML">
        <span>
            <xsl:text> </xsl:text>
            <span class="spAttrName">
                <xsl:value-of select="concat('xml:',local-name())"/>
            </span>
            <span class="spEquals">=</span>
            <span class="spQuotes">"</span>
            <span class="spValue">
                <xsl:value-of select="."/>
            </span>
            <span class="spQuotes">"</span>
        </span>
    </xsl:template>
    <xsl:template match="egXML:egXML">
        <pre class="preBox">
            <xsl:apply-templates select="node()" mode="egXML"/>
        </pre>
        <xsl:variable name="biblID" select="substring-after(@source, '#')"/>
        <div class="dictSource">
            <xsl:value-of select="//node()[@xml:id=$biblID]"/>
        </div>
    </xsl:template>
    <xsl:template match="*">
        <xsl:apply-templates/>
    </xsl:template> 
    <xsl:template match="tei:graphic">
        <img src="{@url}" alt="{@url}"/>
    </xsl:template>
    <xsl:template match="tei:hi[@rend='bold']">
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>
    <xsl:template match="tei:hi[@rend='italics']">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>
    <xsl:template match="tei:item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <xsl:template match="tei:list[@type='ul']">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:ptr">
        <xsl:choose>
            <xsl:when test="ancestor::egXML">
                <span class="spRed">&lt;ptr</span>
                <xsl:text> </xsl:text>
                <xsl:for-each select="@*">
                    <span class="spAttrName">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="name()"/>
                        <span class="spEquals">=</span>
                        <span class="spQuotes">"</span>
                        <span class="spValue">
                            <xsl:value-of select="."/>
                        </span>
                        <span class="spQuotes">"</span>
                    </span>
                </xsl:for-each>
                <span class="spRed">/&gt;</span>
            </xsl:when>
            <xsl:otherwise>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:cell">
        <xsl:choose>
            <xsl:when test="@xml:lang='ar-x-DMG'">
                <td style="font-style:italic">
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
            <xsl:when test="@xml:lang='ar'">
                <td style="direction:rtl">
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
            <xsl:otherwise>
                <td>
                    <xsl:apply-templates/>
                </td>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:row">
        <tr>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>
    <xsl:template match="tei:span[@type='step']">
        <span class="spStep">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:span[@type='filename']">
        <i><b><xsl:apply-templates/></b></i>
    </xsl:template>
    
    <xsl:template match="tei:table">
        <xsl:choose>
            <xsl:when test="parent::tei:div[@type='verbParadigm']">
                <table>
                    <tr>
                        <td class="tdLabel"/>
                        <td class="tdLabel">Sg.</td>
                        <td class="tdLabel">Pl.</td>
                    </tr>
                    <tr>
                        <td class="tdLabel">1.</td>
                        <td>
                            <i>
                                <xsl:value-of select="tei:row/tei:cell[@role='1s']"/>
                            </i>
                        </td>
                        <td>
                            <i>
                                <xsl:value-of select="tei:row/tei:cell[@role='1p']"/>
                            </i>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdLabel">2. m.</td>
                        <td>
                            <i>
                                <xsl:value-of select="tei:row/tei:cell[@role='2sm']"/>
                            </i>
                        </td>
                        <td rowspan="2">
                            <i>
                                <xsl:value-of select="tei:row/tei:cell[@role='2p']"/>
                            </i>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdLabel">2. f.</td>
                        <td>
                            <i>
                                <xsl:value-of select="tei:row/tei:cell[@role='2sf']"/>
                            </i>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdLabel">3. m.</td>
                        <td>
                            <i>
                                <xsl:value-of select="tei:row/tei:cell[@role='3sm']"/>
                            </i>
                        </td>
                        <td rowspan="2">
                            <i>
                                <xsl:value-of select="tei:row/tei:cell[@role='3p']"/>
                            </i>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdLabel">3. f.</td>
                        <td>
                            <i>
                                <xsl:value-of select="tei:row/tei:cell[@role='3sf']"/>
                            </i>
                        </td>
                    </tr>
                </table>
            </xsl:when>
            <xsl:otherwise>
                <table>
                    <xsl:apply-templates/>
                </table>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:graphic">
        <img>
            <xsl:attribute name="src">
                <xsl:value-of select="@url"/>
            </xsl:attribute>
        </img>
    </xsl:template>
    <xsl:template match="tei:list[@type='ol']">
        <ol>
            <xsl:apply-templates/>
        </ol>
    </xsl:template>
    <xsl:template match="tei:item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="matches(@target,('^(http|mailto)'))">
                <!--                 <a href="{if (matches(@target,('^(http|#|mailto)'))) then () else (root()//@xml:base)[1]}{@target}">
                    <xsl:apply-templates/>
                </a> -->
                <a target="_blank" href="{@target}"><xsl:apply-templates/></a>
            </xsl:when>
            <xsl:otherwise><a href="{(root()//@xml:base)[1]}{@target}"><xsl:apply-templates/></a></xsl:otherwise>
        </xsl:choose>
    </xsl:template>            
    <xsl:template match="tei:ref[@type='license']">
        <a href="{@target}" class="tei-type-license">Copyright notice</a>
    </xsl:template>
    <xsl:template match="tei:egXML">
        <pre class="preBox">
            <xsl:apply-templates/>
        </pre>
    </xsl:template>
    <xsl:template match="tei:head[parent::tei:div[count(ancestor::tei:div) = 0]]">
        <h1><xsl:apply-templates/></h1>
        <p>
            <span class="spAuthor">
                <xsl:for-each select="//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author">
                    <xsl:if test="position()&gt;1">, </xsl:if>
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </span>
            <xsl:value-of select="//tei:publicationStmt/tei:pubPlace"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="//tei:publicationStmt/tei:date"/>
        </p>
        
    </xsl:template>
    <xsl:template match="tei:head[parent::tei:div[count(ancestor::tei:div) = 1]]">
        <h2>
            <xsl:if test="parent::*[@xml:id]">
                <xsl:attribute name="id">
                    <xsl:value-of select="parent::*/@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="count(preceding::tei:div[count(ancestor::tei:div) = 1])+1"/>
            <xsl:text> </xsl:text>
            <xsl:choose>
                <xsl:when test="@xml:lang='ar-x-DMG'">
                    <span style="font-style:italic">
                        <xsl:apply-templates/>
                    </span>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text> </xsl:text>
            
        </h2>
    </xsl:template>
    <xsl:template match="tei:head[parent::tei:div[count(ancestor::tei:div) = 2]]">
        <h3>
            <xsl:if test="parent::tei:*[@xml:id]">
                <xsl:attribute name="id">
                    <xsl:value-of select="parent::tei:*/@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="count(preceding::tei:div[count(ancestor::tei:div) = 1])+1"/>.<xsl:value-of select="count(parent::tei:div/preceding-sibling::tei:div)+1"/>
            <xsl:text> </xsl:text>
            <xsl:choose>
                <xsl:when test="@xml:lang='ar-x-DMG'">
                    <span style="font-style:italic">
                        <xsl:apply-templates/>
                    </span>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </h3>
    </xsl:template>
    <xsl:template match="tei:head[parent::tei:div[count(ancestor::tei:div) = 3]]">
        <h4>
            <xsl:if test="parent::tei:*[@xml:id]">
                <xsl:attribute name="id">
                    <xsl:value-of select="parent::tei:*/@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="count(preceding::tei:div[count(ancestor::tei:div) = 1])+1"/>.<xsl:value-of select="count(parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/>.<xsl:value-of select="count(parent::tei:div/preceding-sibling::tei:div)+1"/>
            <xsl:text> </xsl:text>
            <xsl:choose>
                <xsl:when test="@xml:lang='ar-x-DMG'">
                    <span style="font-style:italic">
                        <xsl:apply-templates/>
                    </span>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </h4>
    </xsl:template>
    <xsl:template match="tei:head"/>
    <xsl:template match="tei:div">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:code | tei:hi[@rend='italic']">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>
    <xsl:template match="tei:hi[@rend='bold']">
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>
    <xsl:template match="tei:hi[@rend='red']">
        <b style="color:red">
            <xsl:apply-templates/>
        </b>
    </xsl:template>
    <xsl:template match="tei:span">
        <xsl:choose>
            <xsl:when test="@type='control'"><span class="spControl"><xsl:apply-templates/></span></xsl:when>
            <xsl:when test="@type='shortcut'"><span class="spShortcut"><xsl:apply-templates/></span></xsl:when>
            <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:author"/>
    <xsl:template match="tei:header"/>
    <xsl:template match="tei:titleStmt"/>
    <xsl:template match="tei:fileDesc"/>
    <xsl:template match="tei:sourceDesc"/>
    <xsl:template match="tei:sourceDesc/tei:bibl"/>
    <xsl:template match="tei:teiHeader/tei:fileDesc/tei:author"/>
    <xsl:template match="tei:titleStmt/tei:title"/>
    <xsl:template match="tei:publicationStmt/tei:pubPlace"/>
    <xsl:template match="tei:publicationStmt/tei:date"/>
    <xsl:template match="tei:editionStmt/tei:edition"/>
    <xsl:template match="tei:*">
        <xsl:value-of select="name()"/>
        <xsl:apply-templates/>
    </xsl:template>
</xsl:stylesheet>