# VICAV Framework Data Architecture
Daniel Schopper, 10/2024

VICAV datasets share a set of common linguistic data types: 

* Feature Lists
* Sample Texts
* Free Speech (dialogues, narration)

Next to this corpus data in the narrower sense, a VICAV dataset can moreover contain:

* a glossary or dictionary
* place profiles (describing the socio-demographic or linguistic particularities)
* a bibliography

This document describes the architecture of such a dataset and the rules which it needs to follow if it should be published in an instance of the VICAV application framework.

## Identifier System 

* All references MUST be routed through suffixes defined in `<prefixDef>` elements in the corpus document
* Each TEI document MUST  an `@xml:id` on its root element (`<TEI>` or `<teiCorpus>`) for easier querying/processing 
* Each TEI document MUST contain an `<idno>` element containing the same identifier.

## Corpus Document

### Information contained in the Corpus Document 
Each data set is represented by one [TEI Corpus document](https://www.tei-c.org/release/doc/tei-p5-doc/en/html/ref-teiCorpus.html) which contains the main information of the data in one central place:

* general project and dataset metadata, esp. `<respStmt>` elements covering general responsibltes pertaining to the project as a whole
* list of team members and contributors (in `<standOff>`)
* list of informants with ID and socio-demographic information in `<particDesc>`
* list of places in `<standOff>`
* list of document types in `encodingDesc/classDecl/taxonomy`
* `<ptr>` elements to all TEI documents in the data set AND/OR `<TEI>` stubs (in case of audio recordings that have not been transcribed further)

The corpus document has an identifier within `/TEI/teiHeader/fileDesc/publicationStmt/idno`. The name of the dataset is encoded within `/TEI/teiHeader/fileDesc/titleStmt/title[@level="s"]`, e.g. "TUNOCENT Dataset".



### Team Members

Each team member is represented by a `<person>` element in `/teiCorpus/standOff/listPerson[@type="team"]`

The `<person>` element …

* MUST have an `@xml:id` with ID/sigil of the person, 
* SHOULD contain one `<persName>` element with `<forename>` and `<surname>` 
* CAN contain one `<note>` element for further information on ther person.


### Informants

Each informant is represented by a `<person>` element in `/teiCorpus/teiHeader/particDesc`

The `<person>` element …

* MUST have an `@xml:id` AND  an `<idno>` element with the ID/sigil of the person (NB clear names should not be encoded in TEI documents) 
* MUST have `@sex` and `@age` attributes  
* CAN contain one `<note>` element for further information on the person


### Places

The list of places is encoded within `/teiCorpus/standOff/listPlace`. This semantically neutral position takes into account that places play various roles in a corpus.   

Each place is represented by a `<place>` element which … 

* MUST have an `@xml:id`
* MUST contain ONE `<settlement>` element with exactly ONE `<name xml:lang="en">` containing the place's name in English (which will be used for displaying a label for the place in the application); moreover, `<settlement>` MAY contain several other `<name>` elements with different values in `@xml:lang`.
* MAY contain exactly one `<region>` element containing a text node with the region's name in English (which can be used in the frontend to group places)
* MUST contain exactly one `<country>` element containing a text node with the region's name in English
* MUST contain exactly one `<location>` element wi<person sameAs="corpus:Tajerouine4">
                     <idno>Tajerouine4/m/25</idno>
                  </person>th `<geo>` containing the coordinates of the place in decimal notation
* MAY contain several `<idno>` elements providing authority file identifiers for the settlement in question  

```
<place xml:id="place0134">
    <settlement>
       <name xml:lang="en">Tajerouine</name>
       <name xml:lang="aeb">Tāžirwīn</name>
    </settlement>
    <region>Kef</region>
    <country>Tunisia</country>
    <location>
        <geo>35.97545, 8.5505</geo>
    </location>
</place>
```

### Data Type

Next to the common VICAV data types mentioned above, a project can also define its own data types. These need to be listed in a `<taxonomy>` element in the Corpus Document within `/teiCorpus/teiHeader/encodingDesc/classDecl/taxonomy`. 

Each data type is represented by a `<category>` element which

* MUST have an `@xml:id`
* MUst have an `<catDesc>


#### Referencing the data type taxonomy

Each TEI Header must contain a `<catRef>` element within `` 



# Single Document Level

Each document of any kind must be encoded within a `<TEI>` element. Documents can be stored as one file each, or grouped together within another `<teiCorpus>` element.

## Titles and Identifiers

Each document needs a title encoded in `<title level="a">` within `TEI/fileDesc/titleStmt`. The name of the dataset must be encoded in a sibling `<title level="s">` element.

Each document must have an `@xml:id` on its root `<TEI>` element AND an `<idno>` within `TEI/fileDesc/publicationStmt`. 



## VICAV Platform 

The *VICAV Platform* joins several datasets into one instance.   
