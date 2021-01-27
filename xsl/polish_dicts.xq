declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare variable $publ external := 'dc_ar_en_publ1';
declare variable $source-data := substring-before($publ, 'publ')||'_src';

for $include in collection($publ)//tei:include
return xquery:eval-update(
``[declare namespace tei = "http://www.tei-c.org/ns/1.0";
replace node db:open-pre("`{$publ}`", `{db:node-pre($include)}`) with collection("`{$source-data}`")`{$include/@xpath/data()}`]``
)