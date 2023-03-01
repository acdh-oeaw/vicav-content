declare namespace t = 'http://www.tei-c.org/ns/1.0';
for $unmarked_geo in db:open("vicav_biblio", "TEI_export.xml")//t:biblStruct//t:note[@subtype="unmarked_geo"]
let $placeName := $unmarked_geo/t:name/text()
group by $placeName
let $c := count($unmarked_geo)
order by $c descending
return $placeName||': '||$c||' ('||string-join($unmarked_geo/../../@xml:id, ', ')||')'