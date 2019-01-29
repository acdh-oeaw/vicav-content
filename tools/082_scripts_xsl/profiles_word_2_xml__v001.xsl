<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rl="http://schemas.openxmlformats.org/package/2006/relationships"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:functx="http://www.functx.com"  
    xmlns:acdh="http://acdh.oeaw.ac.at/ns"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:bib="http://purl.org/net/biblio#"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all"
    version="2.0">

    <xsl:include href="http://www.xsltfunctions.com/xsl/functx-1.0-nodoc-2007-01.xsl"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="p w:p w:r w:t"/>
    <xsl:preserve-space elements="tei:p"/>
    
    <xsl:variable name="table" select="root()//tei:table[1]"/>
    
    <xsl:param name="debug" as="xs:boolean" select="false()"/>
    <xsl:param name="path-to-zotero-rdf"/>
    <xsl:variable name="zotero-rdf" select="doc($path-to-zotero-rdf)"/>
    
    <xsl:variable name="bibl-entry-keys" as="element()*">
        <bibl-keys xmlns="">
            <xsl:for-each select="$zotero-rdf/rdf:RDF/*">
                <xsl:variable name="key" select="acdh:bibl-key(.)"/>
                <xsl:if test="normalize-space($key) != ''">
                    <key about="{@rdf:about}"><xsl:value-of select="$key"/></key>
                </xsl:if>
            </xsl:for-each>
        </bibl-keys>
    </xsl:variable>
    
    <xsl:variable name="bibl-entry-keys-regex" select="concat('(',string-join($bibl-entry-keys//key/functx:escape-for-regex(.),'|'),')')"/>
    
    <xsl:function name="acdh:bibl-key">
        <xsl:param name="entry" as="element()"/>
        <xsl:variable name="authors" as="xs:string">
            <xsl:choose>
                <xsl:when test="count($entry/bib:authors//foaf:Person) gt 2">
                    <xsl:value-of select="concat(subsequence($entry/bib:authors//foaf:Person,1,1)/foaf:surname,' et al.')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="string-join($entry/bib:authors//foaf:surname,', ')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$authors != ''">
            <xsl:value-of select="$entry/concat($authors,' ', dc:date)"/>
        </xsl:if>
    </xsl:function>
    
    <!-- returns the content of the cell -->
    <xsl:function name="acdh:field-value" as="element()*">
        <xsl:param name="key" as="xs:string"/>
        <xsl:if test="$debug">
            <xsl:message>getting field value for key '<xsl:value-of select="$key"/>'</xsl:message>
        </xsl:if>
        <xsl:variable name="label" select="acdh:label-by-key($key)" as="element(field)"/>
        <xsl:sequence select="acdh:cell-by-label($table, $label, 2)/*"/>
    </xsl:function>
    
    <xsl:function name="acdh:label-by-key">
        <xsl:param name="key" as="xs:string"/>
        <xsl:sequence select="($fields//field[@key = $key],$key)[1]"/>
    </xsl:function>
    
    <xsl:function name="acdh:cell-by-label" as="element(tei:cell)*">
        <xsl:param name="table" as="element(tei:table)"/>
        <xsl:param name="label"/>
        <xsl:param name="cell-number" as="xs:integer?"/>
        <xsl:sequence select="$table//tei:cell[normalize-space(.) = $label]/parent::tei:row/tei:cell[$cell-number]"/>
    </xsl:function>
    
    <xsl:variable name="fields">
        <fields xmlns="">
            <field key="id">ID</field>
            <field key="author">Author of this profile</field>
            <field key="locNameEng">Name of location (English)</field>
            <field key="locNameFushaAr">Name of location (Fuṣḥā, Arabic)</field>
            <field key="locNameFusha">Name of location (Fuṣḥā, transcription)</field>
            <field key="locNameLoc">Name in local variety (in transcription)</field>
            <field key="geo">Geo location</field>
            <field key="typology">Typology (Local)</field>
            <field key="typologyGen">Typology (General)</field>
            <field key="imageCopyright">Copyright of image</field>
            <field key="general">General</field>
            <field key="researchHistory">Research history</field>
            <field key="dicts">Dictionaries</field>
            <field key="textbooks">Text books</field>
            <field key="audio">Audio data</field>
            <field key="image">Image</field>
            <field key="biblio">Bibliography</field>
            <field key="sample">Sample text</field>
            <field key="lingfeatures">Linguistic features</field>
        </fields>
    </xsl:variable>

    <xsl:variable name="author" select="acdh:field-value('author')"/>
    <xsl:variable name="id" select="acdh:field-value('id')"/>
    
    <xsl:variable name="locNameEng" select="acdh:field-value('locNameEng')"/>
    <xsl:variable name="locNameFushaAr" select="acdh:field-value('locNameFushaAr')"/>
    <xsl:variable name="locNameFusha" select="acdh:field-value('locNameFusha')"/>
    <xsl:variable name="locNameLoc" select="acdh:field-value('locNameLoc')"/>
    
    <xsl:variable name="imageCopyright" select="acdh:field-value('imageCopyright')"/>
    <xsl:variable name="image" select="acdh:field-value('image')//tei:figure"/>
    <xsl:variable name="geo" select="acdh:field-value('geo')"/>
    <xsl:variable name="typology" select="acdh:field-value('typology')"/>
    <xsl:variable name="typologyGen" select="acdh:field-value('typologyGen')"/>
    
    <xsl:variable name="general" select="acdh:field-value('general')"/>
    <xsl:variable name="researchHistory" select="acdh:field-value('researchHistory')"/>
    <xsl:variable name="dicts" select="acdh:field-value('dicts')"/>
    <xsl:variable name="textbooks" select="acdh:field-value('textbooks')"/>
    <xsl:variable name="audio" select="acdh:field-value('audio')"/>
    
    <xsl:variable name="biblio" select="acdh:field-value('biblio')"/>
    <xsl:variable name="sample" select="acdh:field-value('sample')"/>
    <xsl:variable name="lingfeatures" select="acdh:field-value('lingfeatures')"/>

    <xsl:template match="/">
        <xsl:if test="$debug">
            <xsl:result-document href="keys.xml">
                <xsl:sequence select="$bibl-entry-keys"/>
            </xsl:result-document>
        </xsl:if>
        
        <xsl:variable name="pass1">
            <xsl:processing-instruction name="xml-model">href="../tools/802_tei_odd/out/vicav_profiles.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
            <xsl:processing-instruction name="xml-model">href="../tools/802_tei_odd/out/vicav_profiles.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
            <TEI>
                <xsl:attribute name="xml:id"><xsl:value-of select="$id"/></xsl:attribute>
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title>A machine-readable profile of <xsl:value-of select="$locNameEng"/> Arabic</title>
                            <respStmt>
                                <resp>document preparation</resp>
                                <xsl:copy-of select="//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author/node()"/>
                            </respStmt>
                            <xsl:for-each select="$author">
                                <author><xsl:value-of select="."/></author>
                            </xsl:for-each>
                        </titleStmt>
                        <publicationStmt>
                            <publisher>ACDH-OeAW</publisher>
                            <pubPlace>Vienna</pubPlace>
                            <date>2019</date>
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
                    <xsl:sequence select="//tei:encodingDesc"/>
                    <xsl:apply-templates select="//tei:revisionDesc"/>
                </teiHeader>
                <text>
                    <body>
                        <div>
                            <head>
                                <xsl:apply-templates select="$image"/>
                                <label><xsl:value-of select="acdh:label-by-key('locNameEng')"/></label>
                                <name xml:lang="eng"><xsl:value-of select="$locNameEng"/></name>
                                
                                <xsl:if test="string-length($locNameFusha)&gt;0">
                                    <label><xsl:value-of select="acdh:label-by-key('locNameFusha')"/></label>
                                    <name xml:lang="ara"><xsl:value-of select="$locNameFusha"/></name>
                                </xsl:if>
                                <xsl:if test="string-length($locNameLoc)&gt;0">
                                    <label><xsl:value-of select="acdh:label-by-key('locNameLoc')"/></label>
                                    <name xml:lang="ara-x-DMG"><xsl:value-of select="$locNameLoc"/></name>
                                </xsl:if>
                                <xsl:if test="string-length($locNameFushaAr)&gt;0">
                                    <label><xsl:value-of select="acdh:label-by-key('locNameFushaAr')"/></label>
                                    <name xml:lang="ajp" ><xsl:value-of select="$locNameFushaAr"/></name>
                                </xsl:if>                                                        
                            </head>
                            
                            <xsl:if test="$geo">
                                <div type="positioning">
                                    <head><xsl:value-of select="acdh:label-by-key('geo')"/></head>
                                    <p><geo><xsl:value-of select="$geo"/></geo></p>
                                </div>
                            </xsl:if>
                            
                            <xsl:if test="$typology or $typologyGen">
                                <div type="typology">
                                    <head><xsl:value-of select="acdh:label-by-key('typology')"/></head>
                                    <p><xsl:value-of select="$typology"/></p>
                                    <p><xsl:value-of select="$typologyGen"/></p>
                                </div>
                            </xsl:if>
                            
                            <xsl:if test="exists($general)">
                                <div type="general">
                                    <head><xsl:value-of select="acdh:label-by-key('general')"/></head>
                                    <xsl:apply-templates select="$general"/>
                                </div>
                            </xsl:if>
                            
                            <xsl:if test="exists($researchHistory)">
                                <div type="researchHistory">
                                    <head><xsl:value-of select="acdh:label-by-key('researchHistory')"/></head>
                                    <xsl:apply-templates select="$researchHistory"/>
                                </div>
                            </xsl:if>
                            
                            <xsl:if test="exists($dicts)">
                                <div type="dictionaries">
                                    <head><xsl:value-of select="acdh:label-by-key('dicts')"/></head>
                                    <xsl:apply-templates select="$dicts"/>
                                </div>
                            </xsl:if>
                            
                            <xsl:if test="$textbooks">
                                <div type="textBooks">
                                    <head><xsl:value-of select="acdh:label-by-key('textbooks')"/></head>
                                    <xsl:apply-templates select="$textbooks"/>
                                </div>
                            </xsl:if>
                            
                            <xsl:if test="$audio">
                                <div type="audioData">
                                    <head><xsl:value-of select="acdh:label-by-key('audio')"/></head>
                                    <xsl:apply-templates select="$audio"/>
                                </div>
                            </xsl:if>
                            
                            <xsl:if test="$biblio">
                                <div type="bibliography">
                                    <head><xsl:value-of select="acdh:label-by-key('biblio')"/></head>
                                    <xsl:apply-templates select="$biblio"/>
                                </div>
                            </xsl:if>
                            
                            <xsl:if test="$sample">
                                <div type="sampleText">
                                    <head><xsl:value-of select="acdh:label-by-key('sample')"/></head>
                                    <xsl:apply-templates select="$sample"/>
                                </div>
                            </xsl:if>
                            
                            <xsl:if test="$lingfeatures">
                                <div type="lingFeatures">
                                    <head><xsl:value-of select="acdh:label-by-key('lingfeatures')"/></head>
                                    <xsl:apply-templates select="$lingfeatures"/>
                                </div>
                            </xsl:if>
                        </div>
                    </body>
                </text>
            </TEI>
        </xsl:variable>
        
        <xsl:apply-templates select="$pass1" mode="pass2"/>
        
    </xsl:template>
    
    <xsl:template match="tei:figure">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
            <head type="imgCaption">
                <xsl:for-each select="$imageCopyright">
                    <xsl:choose>
                        <xsl:when test="starts-with(.,'http:')">
                            <ref target="{.}"><xsl:value-of select="."/></ref>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </head>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="node() | @*" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="text()" mode="pass2" priority="1">
        <xsl:analyze-string select="." regex="{$bibl-entry-keys-regex}">
            <xsl:matching-substring>
                <xsl:variable name="string" select="."/>
                <xsl:variable name="biblid" select="$bibl-entry-keys//key[text() = $string]/@about"/>
                <xsl:if test="count($biblid) gt 1">
                    
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="count($biblid) gt 1">
                        <xsl:variable name="comment">Found <xsl:value-of select="count($biblid)"/> keys for '<xsl:value-of select="$string"/>': &#x0A;<xsl:for-each select="$biblid">
                            https://www.zotero.org/groups/2165756/vicav/items/itemKey/<xsl:value-of select="."/>&#x0A;
                            </xsl:for-each></xsl:variable>
                        <xsl:variable name="content">
                            author="A machine" timestamp="<xsl:value-of select="current-dateTime()"/> " comment="<xsl:value-of select="$comment"/>"
                        </xsl:variable>
                        <xsl:processing-instruction name="oxy_comment_start"><xsl:value-of select="$content"/></xsl:processing-instruction>
                        <rs type="bibl" ref=""><xsl:value-of select="."/></rs>
                        <xsl:processing-instruction name="oxy_comment_end"/>
                    </xsl:when>
                    <xsl:when test="$string != '' and exists($biblid)">
                        <rs type="bibl" ref="zotero:{$biblid}"><xsl:value-of select="."/></rs>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$string"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    
     
    <xsl:template match="w:proofErr"/>
    
    <xsl:template match="tei:p | w:p">
        <p xml:space="preserve"><xsl:apply-templates/></p>
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
    
    <xsl:template match="text()[ancestor::w:*]">
        <xsl:choose>
            <xsl:when test="parent::w:t"><xsl:value-of select="."/></xsl:when>
            <xsl:otherwise><xsl:value-of select="normalize-space(.)"/></xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <xsl:copy-of select="*"/>
            <change when="{current-dateTime()}" status="draft"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>