# Updating the VICAV Bibliography

The zotero library export we use contains nearly all needed data. In order to integrate the geo data with the bibliographic data proceed as described below: 

1. Export the VICAV Group Library as TEI and store it to
        vicav_content\vicav_bibl\vicav_biblio_tei_zotero.xml
2. Open it with oXygen, format and save it. 
3. Run vicolo.exe, tabsheet Geolocator and open:
    TEI Biblio.: vicav_content\vicav_biblio\vicav_biblio_tei_zotero.xml
    Geonames: vicav_content\vicav_biblio\vicav_geo_data.xml 
4. Push the button "Clear Geodata and Reassign"
5. Save 'vicav_biblio_tei_zotero.xml' (Ctrl + S)
6. Copy this data to BaseX vicav_biblio


Todo in Zotero: 
1. No more geo coordinates!!!
2. check if something is reg: or geo: (Gozo, Malta, Samha)
    geo:Atlas Mountains --> reg:Atlas Mountains
    geo:Hadramaut --> reg:Hadramaut
    ...

Todo Zotoscope:
1. assign geo coordinates to items of taxonomy
2. Save this data and proceed as described above  