xquery version "1.0-ml";

declare variable $miles-radius := 0.3;
declare variable $query := xdmp:get-request-field("postcode", "W2 6BD");

declare function local:create-primary-marker($doc){
    element Marker {
        attribute Name {$doc/Location/Postcode/text()},
        attribute Address {$doc/Location/District/text()},
        attribute Lat {$doc/Location/Latitude/text()},
        attribute Long {$doc/Location/Longitude/text()}
    }
};

declare function local:create-geosearch-markers($docs){
    for $item in $docs/Location
    return 
    element Marker {
        attribute Name {$item/CommonName/text()},
        (: Add more information in addition to the Street/text() here for it to 
           appear on the infoWindow bubbles on the markers :)
        attribute Address {$item/Street/text()},
        attribute Lat {$item/Latitude/text()},
        attribute Long {$item/Longitude/text()}
    }
};

(: Match the Postcode for the centre pin :)
let $doc := 
cts:search(
    doc(),
    cts:element-value-query(
        xs:QName("Postcode"), 
        $query, 
        ("case-insensitive", "whitespace-insensitive")
    )
)
(: from the doc - create the radial search :)
return
let $point := cts:point($doc/Location/Latitude/text(), $doc/Location/Longitude/text())
let $circle := cts:circle($miles-radius, $point)
let $docs := cts:search(doc()[/Location/AtcoCode],
cts:element-pair-geospatial-query(xs:QName("Location"), xs:QName("Latitude"),
xs:QName("Longitude"), $circle))
return
element Markers {
  (
  local:create-primary-marker($doc),
  local:create-geosearch-markers($docs)  
  )
}