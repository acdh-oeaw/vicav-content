# Converting external contributions to TEI-XML

1. Add the docx document to this directory (called `contributions`).
2. Open vicav.xpr with Oxygen.
3. In Oxygen / *Project* View: Right click on the Word document and select `Transform > Transform with`.
4. A dialog box opens where you can select which transformation scenario to run:    

   * For a linguistic feature list choose *DOCX to TEI: Feature List*.
   * For a profile document choose *DOCX to TEI: Profile*.
   * For a sample text choose *DOCX to TEI: Sample Text*.

After the transformation, the resulting TEI document is automatically opened in Oxygen and stored next to the original Word document. You can now review and edit the document by hand.

After having finished editing, copy the XML file to the respective subdirectory (e.g. a feature list document goes into the `vicav_lingfeatures` directory), add it to the git repository and push it to the server.

# Troubleshooting

## General 

**I can’t find the transformation scenarios above!**

In case these transformation scenarios do not show up, click on the gear wheel symbol on the upper right side of the dialog box ("Settings") and choose "Show all scenarios".

## VICAV Profiles

**The transformation of Profile fails, with an error like: `Document has been marked not available: file: …/vicav-content/vicav_biblio/vicav_biblio_tei_zotero.xml`.**

Make sure you have an up-to-date TEI export of the VICAV bibliography under `vicav-content/vicav_biblio/vicav_biblio_tei_zotero.xml` or change the value of the XSLT Parameter `path-to-zotero-rdf` in the transformation scenario. 


**Some fields which contain information in the Word document of my profile are empty in the resulting TEI document.**

Probably the field name has changed in the Word table, thus the program does not recognize it. Please update `082_scripts_xsl/profile_fields.xml` with the new field name.

**I want to add a new field in the Word template / TEI output. What do I have to do?** 

(1) add a new `<field>` element in `082_scripts_xsl/profile_fields.xml` with two attributes: `@label` containing the field name as it is found in the Word template document, and `@key` providing the short name for the field value which will be used in the transformation stylesheet. E.g.
   
    <field key="myNewField" label=">My New Field"/>
    
   
(2) add a new variable in `profiles_word_2_xml__v001.xsl`, which uses the key of the new field and pulls in the information from the Word table. E.g. 
   
    <xsl:variable name="myNewField" select="acdh:field-value('myNewField')"/>
    
(3) use the new field somewhere  in `profiles_word_2_xml__v001.xsl` where it should be output in the resulting TEI Profile. E.g.
   
    <xsl:if test="exists($myNewField)">
        <div type="myNewField">
                <head><xsl:value-of select="acdh:label-by-key('myNewField')"/></head>
                <xsl:apply-templates select="$myNewField"/>
        </div>
    </xsl:if>

(4) In case you want to pass some additional static configuration parameter to the XSLT script for a given field, add a `<property name="" value=""/>` element inside of the `<field>`. E.g. 

    <field key="locNameFushaAr" label="Name (Fuṣḥā, Arabic)">
        <property name="lang" value="ajp"/>
    </field>
    
These static properties can then be accessed in the XSLT program using the function `acdh:properties-by-key($key)`. 

# Post processing Ling-features

## Tokenize with w tags
1. start vi_tok.exe (Delphi)
2. Open tei-doc
3. Push button "Show tokenizer"
4. Push button "Tokenise"
5. Set parameters in "Tokens" form: 
    * Token element: w
    * Char element: pc
    * Exclude elements: head,cell[@rend="tdCentre"],cell[@rend="tdCom"]cell[@rend="tdLast"],cell[@rend="tdLeft"],cell[@rend="tdID"],item,note,div[@type="positioning"],div[@type="dvTranslations"],title,idno,availability,country,settlement,bibl,publicationStmt,sourceDesc,author
    *     * With IDs: true
    * token on sep line: true
    * Add annotations: false
    * Whitespace as seg: true
    * Add @ana: true
5. Push button "Add Tags" in "Tokens" form
6. Save (Ctrl + S) with extension _toks.xml

## Annotate relevant w tags 
7. Start ling_annot.exe (Lazarus)
8. 