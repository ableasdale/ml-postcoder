xquery version "1.0-ml";

(: 
 : To be used if you encounter problems using add-london-postcodes.xqy
 : 
 : There are 8 individual CSV files in the folder, change the $filename to match the file you want 
 : to insert - and execute (in CQ) for each file
 : - london-postcodes-e.csv
 : - london-postcodes-ec.csv
 : - london-postcodes-w.csv
 :
 : etc... 
 : 
 :)
 
declare variable $filename as xs:string := "%PATH_TO%\ml-geospatial-course\src\main\resources\output\postcodes\london-postcodes-e.csv";

declare variable $line-delemeter as xs:string := "(\r\n?|\n\r?)";

declare function local:tokenize-file() as xs:string+ {
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

(: split the CSV into individual lines :)
let $items := local:tokenize-file()
return
for $line in $items[2 to fn:count($items)]
let $element := local:generate-element-from-csv($items[1], $line)
return 
xdmp:document-insert(concat("/location/postcode/", replace($element/Postcode/text()," ", "_"), ".xml"), $element)