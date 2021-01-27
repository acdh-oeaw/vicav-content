declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare variable $publ external := 'dc_ar_en_publ1';
declare variable $dict_source := substring-before($publ, 'publ')||'_src';
declare variable $source-data-match := '('||string-join(distinct-values(collection($publ)//tei:include/@collection-name-regex/data()), ')|(')||')';
declare variable $source-data := xquery:eval('(collection("'||string-join(db:list()[matches(., $source-data-match)], '"),collection("')||'"))');

if (db:exists($dict_source)) then db:drop($dict_source),
db:create($dict_source, <_>{($source-data/_!xslt:transform(., 'polish_dicts.xsl'))/*/*}</_>, $dict_source||'.xml')