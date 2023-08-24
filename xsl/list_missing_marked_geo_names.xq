declare namespace t = 'http://www.tei-c.org/ns/1.0';
for $missing_geo_data in db:open("vicav_biblio", "TEI_export.xml")//t:biblStruct//t:note[@type="missing_geo_data"]
let $placeName := $missing_geo_data/../t:name/text()
group by $placeName
let $c := count($missing_geo_data)
order by $c descending
return $placeName||': '||$c