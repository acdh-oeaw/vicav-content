# Updating the VICAV Bibliography (GEO Data)

The geo references in the tei export (vicav_biblio_tei_zotero.xml) is enriched with 
data from a list of toponyms enhanced with geo coordinates (vicav_geo_data.xml). This is done with the VICAV TExt Enricher (vigolo). The application can be found on the ACDH VICAV website  (https://www.oeaw.ac.at/fileadmin/Institute/ACDH/vicav_annotator_1_3.zip).  

1. Start the application
2. Open the "List Enricher" tabsheet. 
3. Load the bibliography by double-clicking in TEI Biblio.
4. Load the existing geo references by double-clicking in Geonames. The goal is to repair and clean up the geo coordinates.
5. Double click on an item in the list with the coordinates, e.g. geo:Abéché [13.83, 20.84]. A map should open which displays the position of the coordinates.
6. Check the correctness of the coordinates. By right-clicking on the map, you can change the coordinates.
7. There are to options to obtain the corrdinates: (a) either through clicking as descibed above or (b) through search the geonames database.
    

##Problems:

1. The Openstreetmap map ist not visible: enter the path to this html document manually:  C:\progs\vicav_annotator\data\openstreetmap.html.
2. I have copied data in the browser and the application does not budge anymore: wait a little while. this only happens when you copy to the clipboard for the first time. 

##Todo in Zotero: 
1. No more geo coordinates!!!
2. check if something is reg: or geo: (Gozo, Malta, Samha)
    geo:Atlas Mountains --> reg:Atlas Mountains
    geo:Hadramaut --> reg:Hadramaut
    ...

##Todo in vigolo:
1. assign geo coordinates to items of taxonomy
2. Save this data and proceed as described above  