# Updating the VICAV Bibliography

The zotero library export we use contains nearly all needed data – except the original, stable and globally unique identifiers of the Zotero items in the collection. Fortunately, we have this information in the CSV export of the group library. In order to create stable links to Zotero from within TEI documents, we have to merge the two informaions by applying the following workflow: 

1. Export the VICAV Group Library as Zotero RDF and store it as `vicav_bibliography.rdf`
2. Export the VICAV Group Library as CSV and store it as `vicav_bibliography.csv` 
3. Run the transformation scenario *Bibliography: Add Zotero-URLs* on `vicav_bibliography.rdf`. This will match the two versions by the given short title or a combined key created from the title+year fields and update the @rdf:about attribute on the relevant entries. 