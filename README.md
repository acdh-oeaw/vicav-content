# VICAV Content

This repository contains the content of the VICAV web application other than dictionaries (which are curated using VLE and its backend vle-curation.acdh.oeaw.ac.at).
It consists of the following directories:

* *vicav_biblio:* The copy of the bibliographic data curated in the shared VICAV Zotero  library which is publicly accessible in the VICAV user interface.
* *vicav_corpus:* The VICAV corpus of sample arabic dialect texts.
* *vicav_lingfeatures:*
* *vicav_profiles:*
* *vicav_samples:*
* *vicav_texts:*

## Workflows

### Editing

The TEI documents in this repository can be edited with any text editor at hand. For ease of use an Oxygen Project (`vicav.xpr`) is included.

### Converting contributions to TEI 

See the Stephan README document in the `contributions` directory.

## Technical Tools
### XSLT Scripts

The XSLT scripts in `tools/082_scripts_xsl` are used for data conversions in the editorial process.

### TEI ODDs

For each of the above meantioned text type (corpus, linguistic features, etc) there will be a dedicated ODD document which defines a TEI model tailored to the text types's specific structure.
