# Updating the VICAV Bibliography

The zotero library export we use contains nearly all needed data. In order to integrate the geo data with the bibliographic data proceed as described below: 

1. Export the VICAV Group Library as TEI and store it to
   vicav_content\vicav_bibl\vicav_biblio_tei_zotero.xml
   
2. Open it with oXygen, format and save it.
   This step is needed to insert line-breaks.
    
3. Run tei_enricher.exe, macros
    macro_create_vicav_zotero_data.mcr
    
4. Copy the output to BaseX vicav_biblio (local instance)
   db:add('vicav_biblio', 'C:\Users\kmoerth\ch_data\git\vicav_content\vicav_biblio\vicav_biblio_tei_zotero.xml') :)
   db:create-backup('vicav_biblio')
   
5. Git vicav_biblio

 