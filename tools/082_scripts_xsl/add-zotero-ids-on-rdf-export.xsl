<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:res="http://purl.org/vocab/resourcelist/schema#"
    xmlns:bibo="http://purl.org/ontology/bibo/"
    xmlns:bib="http://purl.org/net/biblio#"
    xmlns:z="http://www.zotero.org/namespaces/export#"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:acdh="http://acdh.oeaw.ac.at/ns"
    xmlns:ctag="http://commontag.org/ns#"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:param name="path-to-csv-export"/>
    <xsl:variable name="csv-export">
        <xsl:variable name="entries" as="element(entry)+">
            <xsl:for-each select="tokenize(unparsed-text($path-to-csv-export),'&#10;')[position() gt 1]">
                <xsl:variable name="tokens" as="xs:string*">
                    <xsl:for-each select="tokenize(.,'&quot;,&quot;')">
                        <xsl:value-of select="."/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="id" select="replace($tokens[1],'^&quot;','')"/>
                <xsl:variable name="authors" select="$tokens[4]"/>
                <xsl:variable name="title" select="replace($tokens[5],'&quot;&quot;','&quot;')"/>
                <xsl:variable name="year" select="$tokens[3]"/>
                <xsl:variable name="subjects" select="$tokens[40]"/>
                <xsl:variable name="shorttitle" select="$tokens[36]"/>
                <entry title-year-key-subjects="{acdh:title-year-subjects($title,$year,$subjects)}" id="{$id}">
                    <title><xsl:value-of select="$title"/></title>
                    <author><xsl:value-of select="$authors"/></author>
                    <year><xsl:value-of select="$year"/></year>
                    <subjects><xsl:value-of select="$subjects"/></subjects>
                    <shorttitle><xsl:value-of select="$shorttitle"/></shorttitle>
                </entry>
            </xsl:for-each>
        </xsl:variable>
        <entries>
                <xsl:sequence select="$entries"/>
        </entries>
    </xsl:variable>
    
    <xsl:key name="entry-by-biblid" match="entry" use="shorttitle"/>
    <xsl:key name="entry-by-title" match="entry" use="title"/>
    <xsl:key name="entry-by-title-year-subjects" match="entry" use="@title-year-key-subjects"/>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:result-document href="csv.xml" indent="yes">
            <entries>
                <xsl:for-each select="$csv-export//entry">
                    <xsl:sort select="author"/>
                    <xsl:sort select="year"/>
                    <xsl:sequence select="."/>
                </xsl:for-each>
            </entries>
        </xsl:result-document>
        
        <xsl:for-each-group select="rdf:RDF/*" group-by="dc:description[.!='']">
            <xsl:if test="count(current-group()) gt 1">
                <xsl:message terminate="no">WARNING! Ambiguous short title <xsl:value-of select="current-grouping-key()"/></xsl:message>
                <!--<xsl:message terminate="yes" select="current-group()"/>-->
            </xsl:if>
        </xsl:for-each-group>
        
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:function name="acdh:title-year-subjects">
        <xsl:param name="title-param"/>
        <xsl:param name="year-param"/>
        <xsl:param name="subjects-param"/>
        <xsl:variable name="title" select="$title-param"/>
        <xsl:variable name="year">
            <xsl:choose>
                <xsl:when test="$year-param instance of xs:string">
                    <xsl:value-of select="$year-param"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="years" as="xs:string*">
                        <xsl:analyze-string select="$year-param" regex="\d{{4,4}}">
                            <xsl:matching-substring>
                                <xsl:value-of select="."/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:variable>
                    <xsl:value-of select="$years[1]"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="subjects">
            <xsl:choose>
                <xsl:when test="$subjects-param instance of xs:string">
                    <xsl:value-of select="$subjects-param"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="string-join($subjects-param,'; ')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="replace(concat(normalize-space($title),'_',$year,'_',$subjects),'\s+','')"/>
    </xsl:function>
    
    <xsl:template match="rdf:Description[z:itemType=('conferencePaper','encyclopediaArticle')]|bib:Article|bib:BookSection|bib:Book|bib:Thesis|bib:Document|bib:Manuscript">
        <xsl:variable name="orig">
            <xsl:copy-of select="."/>
        </xsl:variable>
        <xsl:variable name="biblid" select="dc:description"/>
        <xsl:variable name="entry-by-biblid" as="element()*">
            <xsl:if test="$biblid != ''">
                <xsl:variable name="candidates" select="key('entry-by-biblid', $biblid, $csv-export)"/>
                <xsl:variable name="position" select="count(preceding-sibling::*[dc:description = $biblid])+1"/>
                <xsl:sequence select="$candidates[$position]"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="year" as="xs:string*">
            <xsl:analyze-string select="dc:date" regex="\d{{4,4}}">
                <xsl:matching-substring>
                    <xsl:value-of select="."/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:variable name="title" select="dc:title"/>
        <xsl:variable name="entry-by-title" as="element()*">
            <xsl:if test="$title != ''">
                <xsl:variable name="candidates" select="key('entry-by-title', $title, $csv-export)" as="item()*"/>
                <xsl:variable name="position" select="count(preceding-sibling::*[dc:title = $title])+1"/>
                <xsl:sequence select="$candidates[$position]"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="subjects" select="string-join(dc:subject,'; ')"/>
        <xsl:variable name="title-year-subjects" select="replace(concat(normalize-space(dc:title),'_',$year[1],'_',$subjects),'\s+','')"/>
        <xsl:variable name="entry-by-title-year-subjects" as="element()*">
            <xsl:if test="$title-year-subjects != '' and not($entry-by-title) and not($entry-by-biblid)">
                <xsl:variable name="candidates" select="key('entry-by-title-year-subjects', $title-year-subjects, $csv-export)"/>
                <xsl:variable name="position" select="count(preceding-sibling::*[acdh:title-year-subjects(dc:title,dc:date,dc:subjects) = $title-year-subjects])+1"/>
                <xsl:if test="count($candidates) gt 1">
                    <xsl:message><xsl:value-of select="count($candidates)"/> candidates found for the following entry</xsl:message>
                    <xsl:message><xsl:sequence select="$orig"/></xsl:message>
                    <xsl:message>Candidates: </xsl:message>
                    <xsl:message select="$candidates"/>
                    <xsl:message>filtering by position(<xsl:value-of select="$position"/>)</xsl:message>
                </xsl:if>
                <xsl:sequence select="$candidates[$position]"/>
            </xsl:if>
        </xsl:variable>
        

        <xsl:if test="count($entry-by-biblid) gt 1"><xsl:message>** more than one biblids for <xsl:sequence select="xs:string($biblid)"></xsl:sequence></xsl:message></xsl:if>
        <xsl:if test="count($entry-by-title-year-subjects) gt 1"><xsl:message>** more than one title-year-subjects matches for <xsl:value-of select="$title-year-subjects"/></xsl:message></xsl:if>
        <xsl:if test="count($entry-by-title) eq 0 and count($entry-by-biblid) eq 0 and count($entry-by-title-year-subjects) eq 0"><xsl:message>no matches for id <xsl:value-of select="$biblid"/> or title <xsl:value-of select="$title"/> or title-year-subject <xsl:value-of select="$title-year-subjects"/></xsl:message></xsl:if>
        <xsl:if test="count(distinct-values(($entry-by-biblid/@id, $entry-by-title/@id, $entry-by-title-year-subjects/@id))) gt 1">
            <xsl:message><xsl:value-of select="count(distinct-values(($entry-by-biblid/@id, $entry-by-title/@id, $entry-by-title-year-subjects/@id)))"/> matches</xsl:message>
            <xsl:message select="current()"/>
            <xsl:for-each select="distinct-values(($entry-by-biblid/@id, $entry-by-title/@id, $entry-by-title-year-subjects/@id))">
                <xsl:message><xsl:value-of select="."/></xsl:message>
                <xsl:message>entry-by-biblid <xsl:value-of select="$entry-by-biblid/@id = current()"/></xsl:message>
                <xsl:message>entry-by-title <xsl:value-of select="$entry-by-title/@id = current()"/></xsl:message>
                <xsl:message>entry-by-title-year-subjects <xsl:value-of select="$entry-by-title-year-subjects/@id = current()"/></xsl:message>
            </xsl:for-each>
        </xsl:if>
        
        <xsl:copy>
            <xsl:copy-of select="@* except @rdf:about"/>
            <xsl:attribute name="rdf:about" select="($entry-by-biblid/@id, $entry-by-title/@id, $entry-by-title-year-subjects/@id)[1]"/>
            <xsl:copy-of select="node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>