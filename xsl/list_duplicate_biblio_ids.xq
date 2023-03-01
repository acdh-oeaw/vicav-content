declare namespace t = 'http://www.tei-c.org/ns/1.0';
for $bibStr in db:open("vicav_biblio", "TEI_export.xml")//t:biblStruct
let $id := $bibStr/@xml:id
group by $id
let $c := count($bibStr)
order by $c descending
where $c > 1
return $id||': '||$c