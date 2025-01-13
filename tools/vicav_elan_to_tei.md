# ELAN to TEI Workflow

The workflow, as it is currently designed, assumes the following setup:

* A set of ELAN files
* A baserow database with tables for the following entities:
	* recordings (including the filename of the audio recording)
	* informants
	* places

Generally, the workflow consists of the following steps:

* Step 1: Fetching the data from baserow and transforming it to a TEI Corpus document where each recording is represented by a `<TEI>` document. 
* Step 2: Transforming the ELAN transcriptions to TEI with [TEI Corpo](https://github.com/christopheparisse/teicorpo)
* Step 3: Merging the metadata from baserow and the transcriptions from ELAN with an XSLT script using the filename of the audio files as a key
* Step 4: Tokenizing and transforming to a plain-text "vertical" (i.e. one line per token) 

## ELAN Documents

We assume the existence of two tier types:

* transcription 
* translation

Each speaker should have its own transcription tier; the translation tier must be subordnate to its parent transcrpition tier.

NB Tiers with any other will be discarded in Step 3 and not result in the final TEI document.

 
