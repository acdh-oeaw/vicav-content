<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:_="urn:acdh"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:archive="http://expath.org/ns/archive"
    xmlns:file="http://expath.org/ns/file"
    xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas"
    xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
    xmlns:o="urn:schemas-microsoft-com:office:office"
    xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
    xmlns:rs="http://schemas.openxmlformats.org/package/2006/relationships"
    xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
    xmlns:v="urn:schemas-microsoft-com:vml"
    xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing"
    xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
    xmlns:w10="urn:schemas-microsoft-com:office:word"
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml"
    xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup"
    xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk"
    xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
    xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"
    exclude-result-prefixes="#all"
    version="3.0">
    <xsl:preserve-space elements="w:t"/>
    <xsl:output indent="yes"/>
    <xsl:function name="_:unzip-and-parse">
        <xsl:param name="filename"/>
        <xsl:variable name="text" select="archive:extract-text(file:read-binary($path-to-docx), $filename)"/>
        <xsl:sequence select="if (exists($text)) then parse-xml($text) else ()"/>
    </xsl:function>
    <xsl:key name="comment-by-id" match="w:comment" use="@w:id"/>
    <xsl:param name="debug" as="xs:boolean" select="true()"/>
    <xsl:param name="path-to-docx" as="xs:string"/>
    <xsl:variable name="doc" select="_:unzip-and-parse('word/document.xml')"/>
    <xsl:variable name="comments" select="_:unzip-and-parse('word/comments.xml')"/>
    <xsl:variable name="document.xml.rels" select="_:unzip-and-parse('word/_rels/document.xml.rels')"/>
    
    <xsl:variable name="correctionMarksDoc" select="doc('correctionMarks.xml')"/>
    <xsl:variable name="correctionMarks" select="$correctionMarksDoc//tei:interp/xs:string(@xml:id)" as="xs:string+"/>
    <xsl:template match="xsl:stylesheet" mode="#all">
        <!-- this to omit processor warnings of missing template rules matching the input document's namespace. -->
    </xsl:template>
    <xsl:template match="/">
        <xsl:if test="$debug">
            <xsl:result-document href="debug/archive-entries.xml">
                <xsl:sequence select="archive:entries(file:read-binary($path-to-docx))"/>
            </xsl:result-document>
            <xsl:result-document href="debug/doc.xml">
                <xsl:sequence select="$doc"/>
            </xsl:result-document>
            <xsl:result-document href="debug/document.xml.rels">
                <xsl:sequence select="$document.xml.rels"/>
            </xsl:result-document>
        </xsl:if>
        
        <xsl:variable name="simplified">
            <xsl:apply-templates select="$doc" mode="simplify"/>
        </xsl:variable>
        
        <xsl:if test="$debug">
            <xsl:result-document href="debug/simplified.xml">
                <xsl:sequence select="$simplified"/>
            </xsl:result-document>
        </xsl:if>
        
        <xsl:variable name="commentRangesSorted" as="item()">
            <xsl:apply-templates select="$simplified" mode="sortCommentRanges"/>
        </xsl:variable>
        
        <xsl:if test="$debug">
            <xsl:result-document href="debug/commentRangesSorted.xml">
                <xsl:sequence select="$commentRangesSorted"/>
            </xsl:result-document>
        </xsl:if>
        
        <xsl:variable name="commentRangesGrouped" as="item()">
            <xsl:apply-templates select="$commentRangesSorted" mode="groupByCommentRange"/>
        </xsl:variable>
        
        <xsl:if test="$debug">
            <xsl:result-document href="debug/commentRangesGrouped.xml">
                <xsl:sequence select="$commentRangesGrouped"/>
            </xsl:result-document>
        </xsl:if>
        
        <xsl:variable name="segPartsAdded" as="item()">
            <xsl:apply-templates select="$commentRangesGrouped" mode="addPartOnSeg"/>
        </xsl:variable>
        <xsl:if test="$debug">
            <xsl:result-document href="debug/segPartsAdded.xml">
                <xsl:sequence select="$segPartsAdded"/>
            </xsl:result-document>
        </xsl:if>
        
        <xsl:variable name="tei" as="item()">
            <xsl:apply-templates select="$segPartsAdded" mode="w2t"/>
        </xsl:variable>
        
        <xsl:if test="$debug">
            <xsl:result-document href="debug/tei.xml">
                <xsl:sequence select="$tei"/>
            </xsl:result-document>
        </xsl:if>
        
        <xsl:sequence select="$tei"/>
    </xsl:template>
    
    
    <xsl:template match="node() | @*" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="w:r[not(w:t) and not(w:commentReference)]" mode="simplify"/>
    
    <xsl:template match="w:commentReference[not(exists(root()//w:commentRangeStart[@w:id = current()/@w:id]))][not(exists(root()//w:commentRangeEbd[@w:id = current()/@w:id]))]" mode="simplify">
        <seg rangeID="seg{@w:id}"/>
    </xsl:template>
    <xsl:template match="w:proofErr" mode="simplify"/>
    <xsl:template match="w:sectPr" mode="simplify"/>
    <xsl:template match="w:trPr" mode="simplify"/>
    <xsl:template match="w:bookmarkStart" mode="simplify"/>
    <xsl:template match="w:bookmarkEnd" mode="simplify"/>
    
    <xsl:template match="tei:seg" mode="addPartOnSeg">
        <xsl:variable name="preceding" select="preceding::tei:seg[@rangeID = current()/@rangeID]" as="element(tei:seg)*"/>
        <xsl:variable name="following" select="following::tei:seg[@rangeID = current()/@rangeID]" as="element(tei:seg)*"/>
        <xsl:variable name="allParts" select="($preceding, ., $following)"/>
        <xsl:variable name="part" select="if (not(exists($preceding)) and not(exists($following))) then () else if (exists($preceding) and not(exists($following))) then 'F' else if (exists($preceding) and exists($following)) then 'M' else 'I'"/>
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@* except @rangeID"/>
            <xsl:if test="exists($part)">
                <xsl:attribute name="part" select="$part"/>
            </xsl:if>
            <xsl:attribute name="xml:id" select="if ($part = ('M','F')) then concat(@rangeID,'_',count($preceding)) else @rangeID"/>
            <xsl:apply-templates select="node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*[*/@inRanges]" mode="groupByCommentRange">
        <xsl:variable name="nodes" select="*"/>
        <xsl:variable name="allRanges" select="distinct-values(*/tokenize(@inRanges,' '))"/>
        <xsl:variable name="processed" as="item()*">
            <xsl:copy copy-namespaces="no">
                <xsl:copy-of select="@*"/>
                <xsl:call-template name="groupNodesByRange">
                    <xsl:with-param name="nodes" select="node()" as="node()*"/>
                    <xsl:with-param name="ranges" select="$allRanges"/>
                </xsl:call-template>
            </xsl:copy>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$processed//@inRanges">
                <xsl:apply-templates select="$processed" mode="groupByCommentRange"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$processed"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="groupNodesByRange">
        <xsl:param name="nodes" as="node()*"/>
        <xsl:param name="ranges" as="xs:string+"/>        
        <xsl:for-each-group select="$nodes" group-adjacent="if (@inRanges) then tokenize(@inRanges, ' ') = $ranges[1] else false()">
            <xsl:choose>
                <xsl:when test="current-grouping-key()">
                    <xsl:variable name="ranges" select="current-group()/tokenize(@inRanges,' ')"/>
                    <seg rangeID="seg{$ranges[1]}">
                        <xsl:for-each select="current-group()">
                            <xsl:call-template name="rmRange">
                                <xsl:with-param name="node" select="."/>
                                <xsl:with-param name="range" select="$ranges[1]"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </seg>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="current-group()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template name="rmRange">
        <xsl:param name="node" as="item()"/>
        <xsl:param name="range"/>
        <xsl:variable name="newRanges" select="for $t in tokenize(@inRanges, ' ') return if ($t != $range) then $t else ()" as="xs:string*"/>
        <xsl:choose>
            <xsl:when test="@inRanges">
                <xsl:copy copy-namespaces="no">
                    <xsl:copy-of select="@* except @inRanges"/>
                    <xsl:if test="exists($newRanges)">
                        <xsl:attribute name="inRanges" select="string-join($newRanges, ' ')"/>
                    </xsl:if>
                    <xsl:copy-of select="node()"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:copy-of select="@*"/>
                    <xsl:for-each select="node()">
                        <xsl:choose>
                            <xsl:when test=". instance of element()">
                                <xsl:call-template name="rmRange">
                                    <xsl:with-param name="range" select="$range"/>
                                    <xsl:with-param name="node" select="."/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*[w:commentRangeStart]" mode="sortCommentRanges">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()[1]" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*[w:commentRangeStart]/node()" mode="sortCommentRanges">
        <xsl:param name="ranges" as="xs:string*"/>
        <xsl:variable name="rangeEndID" select="if (. instance of element(w:commentRangeEnd)) then @w:id else ()" as="xs:string?"/>        
        <xsl:variable name="rangeStartID" select="if (. instance of element(w:commentRangeStart)) then @w:id else ()" as="xs:string?"/>
        <xsl:variable name="rangesExceptRangeEnd" select="if ($rangeEndID) then $ranges[not(. = $rangeEndID)] else ($ranges, $rangeStartID)"/>
        <xsl:if test="not(self::w:commentRangeStart or self::w:commentRangeEnd)">
            <xsl:copy copy-namespaces="no">
                <xsl:copy-of select="@*"/>
                <xsl:if test="exists($ranges)">
                    <xsl:attribute name="inRanges" select="string-join($ranges, ' ')"/>
                </xsl:if>
                <xsl:copy-of select="node()"/>
            </xsl:copy>
        </xsl:if>
        <xsl:apply-templates select="following-sibling::node()[1]" mode="#current">
            <xsl:with-param name="ranges" select="$rangesExceptRangeEnd" as="xs:string*"/>
        </xsl:apply-templates> 
    </xsl:template>
    
    <xsl:template match="tei:*" mode="w2t">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="w2t"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="w:body" mode="w2t">
        <xsl:element name="{local-name(.)}" exclude-result-prefixes="#all">
            <xsl:call-template name="rPr2rend"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template>
    
    
    
    <xsl:template match="w:p" mode="w2t">
        <xsl:if test="w:r">
            <p>
                <xsl:apply-templates mode="#current"/>
            </p>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="w:tbl" mode="#default w2t">
        <table>
            <xsl:apply-templates select="w:tr" mode="w2t"/>
        </table>
    </xsl:template>
    <xsl:template match="w:tr" mode="w2t">
        <row>
            <xsl:apply-templates mode="#current"/>
        </row>
    </xsl:template>
    <xsl:template match="w:tc" mode="w2t">
        <cell>
            <xsl:apply-templates mode="#current"/>
        </cell>
    </xsl:template>
    <xsl:template match="w:tcPr" mode="w2t"/>
    
    <xsl:template match="w:hyperlink" mode="w2t">
        <ref target="{$document.xml.rels//rs:Relationship[@Id = current()/@r:id]/@Target}"><xsl:apply-templates mode="#current"/></ref>
    </xsl:template>
    
    <xsl:template match="w:r" mode="w2t">
        <xsl:apply-templates select="*" mode="#current"/>
    </xsl:template>
    
    <xsl:template match="w:rPr|w:commentRangeEnd|w:tab|w:commentReference|w:lastRenderedPageBreak" mode="w2t"/>
    
    <xsl:template match="w:br" mode="w2t">
        <lb/>
    </xsl:template>
    
    
    
    <xsl:template match="w:t" mode="w2t">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <xsl:function name="_:token2rendItem">
        <xsl:param name="t" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$t = 'b'">bold</xsl:when>
            <xsl:when test="$t = 'i'">italic</xsl:when>
            <xsl:otherwise><xsl:value-of select="$t"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:template name="rPr2rend" as="attribute(rend)?">
        <xsl:variable name="properties" select="w:pPr" as="element()?"/>
        <xsl:variable name="tokens" select="$properties/*/*/_:token2rendItem(local-name(.))" as="xs:string*"/>
        <xsl:if test="count($tokens)">
            <xsl:attribute name="rend" select="string-join($tokens,' ')"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="w:document" mode="w2t">
        <TEI>
            <xsl:comment select="current-dateTime()"/>
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title><xsl:value-of select="$doc//w:tbl[1]/w:tr[1]/w:tc[2]/normalize-space(.)"/></title>
                    </titleStmt>
                    <publicationStmt>
                        <p>Add publication stmt.</p>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Automatically converted from DOCX source "<xsl:value-of select="$path-to-docx"/>" on <xsl:value-of select="current-dateTime()"/>.</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <xsl:apply-templates mode="#current"/>
            </text>
        </TEI>    
    </xsl:template>
    
    <xsl:template match="w:pPr" mode="w2t">
        <xsl:if test="w:pStyle/@w:val != ''">
            <xsl:attribute name="rend" select="w:pStyle/@w:val"/>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>