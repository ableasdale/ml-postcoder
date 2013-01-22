xquery version "1.0-ml";
let $query := xdmp:get-request-field("postcode", "W2 6BD")
let $doc := 
cts:search(
    doc(),
    cts:element-value-query(
        xs:QName("Postcode"), 
        $query, 
        ("case-insensitive", "whitespace-insensitive")
    )
)
return
(xdmp:set-response-content-type("text/html; charset=utf-8"),
'<!DOCTYPE html>',
<html>
<head>
<title>Information for {$doc/Location/Postcode/text()}</title>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
<meta http-equiv="content-type" content="text/html; charset=UTF-8"/> 
<style type="text/css">
<![CDATA[
  html { height: 100% }
  body { height: 100%; margin: 0px; padding: 0px; font-family:Arial;}
  #map_canvas { height: 100% }
]]>
</style>
<script language="javascript" src="http://maps.google.com/maps/api/js?v3.4&amp;sensor=false">{" "}</script>
<script type="text/javascript">
<![CDATA[ 
    function initialize() {
        var latlng = new google.maps.LatLng(]]>{concat($doc/Location/Latitude/text(),",",$doc/Location/Longitude/text())}<![CDATA[); 
        var myOptions = {zoom: 16, center: latlng,mapTypeId: google.maps.MapTypeId.ROADMAP};
        var map = new google.maps.Map(document.getElementById("map_canvas"),myOptions);
        var marker = new google.maps.Marker({map:map, animation:google.maps.Animation.DROP, position:latlng, title:"]]>{$doc/Location/Postcode/text()}<![CDATA["});
        var infowindow = new google.maps.InfoWindow({ content: ']]>{(
        xdmp:unquote("<strong>Postcode: </strong>"),$doc/Location/Postcode/text(),
        xdmp:unquote("<br/><strong>District: </strong>"),$doc/Location/District/text(),
        xdmp:unquote("<br/><strong>Ward: </strong>"),$doc/Location/Ward/text()
        )}<![CDATA['});
        google.maps.event.addListener(marker, 'click', function() {infowindow.open(map,marker);});
    } 
]]>
</script>    
</head>
<body onload="initialize()">
  <h1>Postcoder: {$doc/Location/Postcode/text()}</h1>
  <div id="map_canvas" style="width:100%; height:100%"></div>
</body>
</html>)