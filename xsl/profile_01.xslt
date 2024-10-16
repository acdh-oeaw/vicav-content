<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns="http://www.w3.org/1999/xhtml" 
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   version="2.0">
   
    <xsl:output method="html"/>
    <!-- we make sure that $images-base-path always has a trailing slash -->
    
    <xsl:template match="/">
                                        
        <div>
            <table class="tbHeader">
                <tr><td><h2><xsl:value-of select="//tei:name[@xml:lang='eng']"/></h2></td><td class="tdTeiLink">{teiLink}</td></tr>
            </table>    
            
            <div class="dvImgProfile">
                <xsl:if test="//tei:head/tei:figure/tei:graphic">
                     <img>
                        <xsl:attribute name="src">images/<xsl:value-of select="//tei:head/tei:figure/tei:graphic/@url"/></xsl:attribute>
                    </img>
                    <xsl:if test="//tei:head/tei:figure/tei:head">
                        <div class="imgCaption">
                            <xsl:apply-templates select="//tei:head/tei:figure/tei:head"/>
                        </div>                                           
                    </xsl:if> 
                    
                </xsl:if>                
                <!-- 
                <xsl:choose>
                    <xsl:when test="//tei:head/tei:figure/tei:graphic">
                        <img>
                            <xsl:attribute name="src">images/<xsl:value-of select="//tei:head/tei:figure/tei:graphic/@url"/></xsl:attribute>
                        </img>
                        <div class="imgCaption">
                            <xsl:apply-templates select="//tei:head/tei:figure/tei:head"/>
                        </div>                   
                    </xsl:when>
                    <xsl:otherwise>
                        <img>
                            <xsl:attribute name="src">images/<xsl:value-of select="//tei:head/tei:ref[1]/@target"/></xsl:attribute>
                        </img>
                        <div class="imgCaption">
                            <xsl:apply-templates select="//tei:head/tei:ref/tei:p[1]"/>
                        </div>                   
                    </xsl:otherwise>
                </xsl:choose>
                 -->
            </div>
            
            <table class="tbProfile">
                <xsl:if test="//tei:name[@xml:lang='ara']">
                    <tr>
                        <td class="tdHead">MSA Name</td>
                        <td class="tdProfileTableRight"><xsl:value-of select="//tei:name[@xml:lang='ara']"/></td>
                    </tr>
                </xsl:if>
                <xsl:if test="//tei:name[@xml:lang='ara-x-DMG']">
                    <tr>
                        <td class="tdHead">MSA Name (trans.)</td>
                        <td class="tdProfileTableRight"><xsl:value-of select="//tei:name[@xml:lang='ara-x-DMG']"/></td>                    
                    </tr>
                </xsl:if>
                
                <xsl:if test="//tei:name[@type='araLoc']">
                    <tr>
                        <td class="tdHead">Local name</td>
                        <td class="tdProfileTableRight"><xsl:value-of select="//tei:name[@type='araLoc']"/></td>
                    </tr>
                </xsl:if>
                
                <xsl:if test="//tei:name[@type='latLoc']">
                    <tr>
                        <td class="tdHead">Local name (trans.)</td>
                        <td class="tdProfileTableRight"><xsl:value-of select="//tei:name[@type='latLoc']"/></td>
                    </tr>
                </xsl:if>
                
                <tr>
                    <td class="tdHead">Geo location</td>
                    <td class="tdProfileTableRight"><i><xsl:value-of select="//tei:div[@type='positioning']/tei:p"/></i></td>
                </tr>
                <tr>
                    <td class="tdHead">Contributed by</td>
                    <td class="tdProfileTableRight"><i><xsl:value-of select="//tei:author"/></i></td>
                </tr>
            </table>
        
            <xsl:apply-templates select="//tei:div"/>        
            <br/>
            <br/>
            <br/>
        </div>
    </xsl:template>

    <xsl:template match="tei:div[@type='typology']">
        <div class="h3ProfileTypology">Typology</div>
        <table class="tbProfile">
            <tr><td colspan="2" class="tdProfileTableRight"><xsl:value-of select="tei:p[1]"/></td></tr>
            <tr><td colspan="2" class="tdProfileTableRight"><xsl:value-of select="tei:p[2]"/></td></tr>
        </table>   
    </xsl:template>

    <xsl:template match="tei:div[@type='positioning']"/>
    
    <xsl:template match="tei:div[@type and not(./tei:head)]">
        <xsl:choose>
            <xsl:when test="@type='lingFeatures'">
                <div class="h3Profile">Linguistic Features</div>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@type='general'">
                <div class="h3Profile">General</div>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@type='researchHistory'">
                <div class="h3Profile">Research History</div>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@type='sampleText'">
                <div class="h3Profile">Sample Text</div>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@type='bibliography'">
                <div class="h3Profile">Bibliography</div>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@type='textBooks'">
                <div class="h3Profile">Text Books</div>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@type='dictionaries'">
                <div class="h3Profile">Dictionaries</div>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@type='audioData'">
                <div class="h3Profile">Audio Data</div>
                <xsl:apply-templates/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:div[@type and @type!='typology' and ./tei:head]/tei:head">
        <div class="h3Profile"><xsl:value-of select="."/></div>
    </xsl:template>
    
    <xsl:template match="tei:div[not(@type)]" />
    <xsl:template match="tei:hi">
        <xsl:choose>
            <xsl:when test="@rendition='#u'"><span style="text-decoration: underline;"><xsl:apply-templates/></span></xsl:when>
            <xsl:when test="@rendition='#b'"><b><xsl:apply-templates/></b></xsl:when>
            <xsl:when test="@rendition='#i'"><i><xsl:apply-templates/></i></xsl:when>
            <xsl:when test="@rend='italic'"><i><xsl:apply-templates/></i></xsl:when>
            <xsl:otherwise><b><xsl:apply-templates/></b></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:teiHead[@type='imgCaption']"><xsl:apply-templates/></xsl:template>
    <xsl:template match="tei:teiHeader"></xsl:template>
    
    <xsl:template match="tei:p">
        <div class="pNorm"><xsl:apply-templates/></div>
    </xsl:template>
        
    <xsl:template match="tei:list">
        <ul><xsl:apply-templates/></ul>
    </xsl:template>
    <xsl:template match="tei:item">
        <li><xsl:apply-templates/></li>
    </xsl:template>
    
    <xsl:template match="tei:ptr">
        <a class="aVicText">
            <xsl:attribute name="href">#</xsl:attribute>
            <xsl:attribute name="onClick">refEvent("<xsl:value-of select="@target"/>")</xsl:attribute>
            -->
        </a>
    </xsl:template>
    
    <xsl:template match="tei:ref[starts-with(@target,'http')]">
        <a target="_blank" class="aVicText">      
            <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <xsl:template match="tei:rs[
        starts-with(@ref,'profile:') or
        starts-with(@ref,'feature:') or
        starts-with(@ref,'corpus:') or
        starts-with(@ref,'bibl:') or
        starts-with(@ref,'zotID:') or
        starts-with(@ref,'flashcards:') or
        starts-with(@ref,'text:') or
        starts-with(@ref,'sample:')]">
        <a class="aVicText">
            <xsl:attribute name="href">javascript:getDBSnippet("<xsl:value-of select="@ref"/>")</xsl:attribute>
            <xsl:apply-templates/>          
        </a>
    </xsl:template>
    
    <xsl:template match="tei:ref[
        starts-with(@target,'profile:') or
        starts-with(@target,'feature:') or
        starts-with(@target,'zotID:') or
        starts-with(@target,'corpus:') or
        starts-with(@target,'bibl:') or
        starts-with(@target,'flashcards:') or
        starts-with(@target,'text:') or
        starts-with(@target,'sample:')]">
        <a class="aVicText">
            <xsl:attribute name="href">javascript:getDBSnippet("<xsl:value-of select="@target"/>")</xsl:attribute>
            <xsl:apply-templates/>          
        </a>
    </xsl:template>
<!-- 
    <xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="@type='jsLink'">
                <a class="aVicText">
                    <xsl:attribute name="href">#</xsl:attribute>
                    <xsl:attribute name="onClick"><xsl:value-of select="@target"/></xsl:attribute>
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <a class="aVicText">
                    <xsl:attribute name="href">#</xsl:attribute>
                    <xsl:attribute name="onClick">refEvent("<xsl:value-of select="@target"/>")</xsl:attribute>
                    <xsl:apply-templates/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
 -->    
</xsl:stylesheet>

