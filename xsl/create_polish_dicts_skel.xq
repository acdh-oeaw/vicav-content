declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare variable $skel external := 'dc_ar_en__skel';
declare variable $publ external := 'dc_ar_en_publ1';

if (db:exists($publ)) then db:drop($publ),
db:create($publ, parse-xml(replace(serialize(collection($skel)//tei:TEI), '<?', '<', 'q') => replace('?>', '/>', 'q')), $publ||'.xml')
(: replace(serialize(collection($skel)//tei:TEI), '<?', '<', 'q') => replace('?>', '/>', 'q') :)