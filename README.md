# Vienna Corpus of Arabic Varieties – Content repository

This repository contains the content of [VICAV, the Vienna Corpus of Arabic Varieties](https://vicav.acdh.oeaw.ac.at). It consists of the following directories:

* *vicav_biblio:* A dump of the **VICAV bibliography** curated in the shared [VICAV Group library on Zotero](https://www.zotero.org/groups/2165756/vicav)
* *vicav_profiles:* sketches of varieties of spoken contemporary Arabic, so called **language profiles**
* *vicav_lingfeatures:* **linguistic feature lists** – lists of sentence pairs in English and Arabic that are meant to exemplify selected salient linguistic features of the particular varieties
* *vicav_samples:* **sample texts** – translations of the same source text into several varities, allowing the comparison of various linguistic phenomena.
* *vicav_corpus:* **texts** – the VICAV corpus of sample texts in various Arabic varieties.

All six text types are encoded according to the *Guidelines* of the [Text Encoding Initiative](http://www.tei-c.org/).  We are in the process of preparing [ODD specifications](https://wiki.tei-c.org/index.php/ODD) for each of it (see `tools/802_tei_odd`)

Please note that the **VICAV dictionaries** are not part of this repository since they are curated with the [Viennese Lexicographic Editor (VLE)](https://www.oeaw.ac.at/acdh/tools/vle/) and reside inside a dedicated instance of the [BaseX XML database](http://basex.org/).

## Contributing to VICAV

VICAV is a group effort. Your support is highly welcome. Write a profile, write a sample text, share your lexical data or help us in improving the bibliography.

We highly value our cooperators and do our best to credit them. The author of a text is always mentioned in all the profiles, the sample texts, feature lists and dictionary entries. Unfortunately, we did not find a way to preserve who did what in ZOTERO while transfering data not the VICAV database. However, your name will still be mentioned in the [list of contributors](https://vicav.acdh.oeaw.ac.at/#1=[textQuery,vicavContributors,CONTRIBUTORS,open]&1=[textQuery,vicavExplBar_Contributions,CONTRIBUTING,open]&2=[textQuery,vicavContributors,CONTRIBUTORS,open]).

* If you would like to contribute a **profile**, a **sample text**, a **linguistic feature description** or a **languge profile** simply download the respective `.docx` template from the `contributions` directory and send it to us – we will prepare a TEI version of it and integrate it into the corpus.   
However, if working with XML does not frighten you, feel free to have a look at the TEI source documents, fork this repository and send us a pull request.
* If you want to help us enhance the **bibliography** there are different possibilities to proceed. Either you start your own ZOTERO group and grant us access or you write directly into the VICAV-Zotero-group.
* If you would like to contribute a **dictionary** or a **glossary**, get in touch with us. Tell us about the data you have and we will discuss how to proceed best.

If you have any quesions, don’t hesitate to contact us at acdh@oeaw.ac.at or via the [VICAV web application](https://vicav.acdh.oeaw.ac.at/#map=[biblMarkers,,geo]&1=[textQuery,vicavMission,MISSION,open]&2=[textQuery,vicavNews,NEWS,open]&3=[textQuery,vicavExplBar_Contributions,CONTRIBUTING,open]&%20OPEN%20ACCESS,open]).

## License

Unless otherwise noted the VICAV material is published under the terms of the [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) license.
