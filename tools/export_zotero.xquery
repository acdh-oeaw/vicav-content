  xquery version "3.0";
declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";

declare variable $db-name := "vicav_biblio_test";

declare %updating function local:import-zotero-rdf($url){
  let $data := <rdf:RDF><!-- Do not edit this data - it is fetched automatically from Zotero Group library 2165756 --></rdf:RDF>
  return 
    local:get-data($url, 0)
};
declare %updating function local:get-data($url, $chunk-no){
  let $req := <http:request method='get' href='{$url}' timeout='10'/>
  let $re := http:send-request($req)
  let $Link := $re/http:header[@name = 'Link']
  let $next := tokenize($Link/@value, 'rel=')[1]
  let $next-url := if (exists($next)) then fn:analyze-string($next, '<(.+)>')//fn:group[@nr='1']/data(.) else ()
  let $data := $re/rdf:RDF
  return 
      if ($next-url) 
      then (
          db:add($db-name, <url chunk="{$chunk-no}">{$url}</url>, "vicav_biblio_"||format-integer($chunk-no,"0000")||".xml"),
          (: db:add($db-name, $data, "vicav_biblio_"||format-integer($chunk-no,"0000")||".xml"), :)
          local:get-data($next-url, $chunk-no+1)
      )
      else db:add($db-name, $data, "vicav_biblio_"||format-integer($chunk-no,"0000")||".xml")
};


local:import-zotero-rdf("https://api.zotero.org/groups/2165756/items/top?start=0&amp;limit=100&amp;format=rdf_zotero&amp;v=1")
