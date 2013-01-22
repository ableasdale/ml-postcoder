xquery version "1.0-ml";

(:
 : To use:
 : - change the Content Source in cq to point to the database you created earlier
 : - update the %PATH_TO% directory for your folder (e.g. C:\course\)
 : - Execute the script (it should take approximately 2-5 minutes)
 : - On completion, it should have created 117,302 documents in the database
 :)

declare variable $directory as xs:string := "%PATH_TO%\ml-geospatial-course\src\main\resources\output\postcodes";

declare variable $line-delemeter as xs:string := "(\r\n?|\n\r?)";

declare function local:tokenize-file($filename) as xs:string+ {
  fn:tokenize(xdmp:filesystem-file($filename), $line-delemeter)
};

declare function local:generate-element-from-csv($header as xs:string, $data as xs:string) as element(Location){
 let $values := fn:tokenize($data, ",")
 return
 element Location {
    for $ele at $pos in fn:tokenize ($header, ",")
    return element { $ele } {local:tidy($values[$pos])}
 }
};

declare function local:tidy($value as xs:string) as xs:string {
  let $value := replace($value, '"', '')
  let $value := replace($value, " Ward", "")
  let $value := replace($value, " Boro", "") 
  return $value
};

for $csvfile at $pos in xdmp:filesystem-directory($directory)/dir:entry
(: split the CSV into individual lines :)
let $items := local:tokenize-file(xdmp:filesystem-directory($directory)/dir:entry[$pos]/dir:pathname/text())
return
for $line in $items[2 to fn:count($items)]
let $element := local:generate-element-from-csv($items[1], $line)
let $uri := concat("/location/postcode/", replace($element/Postcode/text()," ", "_"), ".xml")
return 
xdmp:eval('
    declare variable $uri as xs:string external;
    declare variable $element as node() external;
    xdmp:document-insert(xs:string($uri), $element)',
    ((fn:QName("","uri"),xs:string($uri), fn:QName("","element"),($element))),
    <options xmlns="xdmp:eval">
        <isolation>different-transaction</isolation>
        <prevent-deadlocks>true</prevent-deadlocks>
    </options>)