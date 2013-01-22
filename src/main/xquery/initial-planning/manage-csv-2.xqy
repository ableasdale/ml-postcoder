xquery version "1.0-ml";

(:
let $name := "medline03n0331"
let $file := fn:concat($name,".xml")
for $node at $index in xdmp:document-get($file)/MedlineCitationSet/MedlineCitation
let $uri := fn:concat($name,"-",$index,".xml")
return xdmp:document-insert($uri,$node)
:)
(:
let $kml := xdmp:filesystem-file("C:\Users\ableasdale\Downloads\postcodes (1).csv")
:)

declare variable $filename as xs:string := "C:\Users\ableasdale\Downloads\postcodes (1).csv";

declare variable $line-delemeter as xs:string := "(\r\n?|\n\r?)";

declare function local:tokenize-file() as xs:string+ {
  fn:tokenize(xdmp:filesystem-file($filename), $line-delemeter)
};

declare function local:generate-element-from-csv($header as xs:string, $data as xs:string) as element(Item){
 let $values := fn:tokenize($data, ",")
 return
 element Item {
    for $ele at $pos in fn:tokenize ($header, ",")
    return element { $ele } {$values[$pos]}
 }
};

let $items := local:tokenize-file()
return
for $line at $pos in $items[2 to fn:count($items)]
return 
local:generate-element-from-csv($items[1], $line)/Postcode/text()


(: let $element := local:generate-element-from-csv($items[1], $items[2]) :)
(:
for $line at $pos in $items[2 to fn:count($items)]
return xdmp:document-insert(concat($pos, ".xml"), local:generate-element-from-csv($items[1], $line))
:)