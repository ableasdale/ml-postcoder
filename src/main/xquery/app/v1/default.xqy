xquery version "1.0-ml";
let $doc := doc("/location/postcode/W2_6BD.xml")
return
(xdmp:set-response-content-type("text/html"),
 '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">',
<html>
<head>
    <title>Information for {$doc/Location/Postcode/text()}</title>
</head>
<body>
<h1>Postcode: {$doc/Location/Postcode/text()}</h1>
<h3>GridRef: {$doc/Location/GridRef/text()}</h3>
<h3>District: {$doc/Location/District/text()}</h3>
<h3>Ward: {$doc/Location/District/text()}</h3>
<img src="http://maps.google.com/maps/api/staticmap?zoom=15&amp;size=1024x1024&amp;markers=color:blue|label:A|{$doc/Location/Latitude/text()},{$doc/Location/Longitude/text()}&amp;sensor=false" />
</body>
</html>)