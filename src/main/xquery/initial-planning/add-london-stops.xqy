xquery version "1.0-ml";

declare variable $filename as xs:string := "C:\Users\ableasdale\workspace\ml-bp-training\src\main\resources\output\naptan\london-stops.csv";

declare variable $line-delemeter as xs:string := "(\r\n?|\n\r?)";

declare function local:tokenize-file() as xs:string+ {
  fn:tokenize(xdmp:filesystem-file($filename), $line-delemeter)
};

declare function local:generate-element-from-csv($header as xs:string, $data as xs:string) as element(Location){
 let $values := fn:tokenize($data, ',')
 return
 element Location {
    for $ele at $pos in fn:tokenize ($header, ',')
    return element { $ele } {$values[$pos]}
 }
};

(: split the CSV into individual lines :)
let $items := local:tokenize-file()
return
for $line in $items[2 to fn:count($items)]
let $element := local:generate-element-from-csv($items[1], $line)
return 
xdmp:document-insert(concat("/location/stops/", $element/AtcoCode/text(), ".xml"), $element)