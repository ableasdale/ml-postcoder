var map;
var markers = [];
var infoWindow;
var locationSelect;
var milesRadius = 0.3;

function init() {
    /* initial setup */
    var myOptions = {
        zoom: 13, mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map(document.getElementById("map"), myOptions);
    infoWindow = new google.maps.InfoWindow();
    
    /* prepare XML feed */
    downloadUrl(searchUrl, function (data) {
        var xml = parseXml(data);
        var markerNodes = xml.documentElement.getElementsByTagName("Marker");
        var bounds = new google.maps.LatLngBounds();
        /* Loop through and prepare Markers */
        for (var i = 0; i < markerNodes.length; i++) {
            var name = markerNodes[i].getAttribute("Name");
            var address = markerNodes[i].getAttribute("Address");
            var latlng = new google.maps.LatLng(
            parseFloat(markerNodes[i].getAttribute("Lat")),
            parseFloat(markerNodes[i].getAttribute("Long")));
            if (i === 0) {
            	var marker = createMarker(latlng, name, address, true);
            	generateCircle(marker);
        	} else {
        		var marker = createMarker(latlng, name, address, false);
        	}
            bounds.extend(latlng);
        }
        map.fitBounds(bounds);
    });
}

function generateCircle(marker){
    var circle = new google.maps.Circle({
        map: map,
        // 0.1 mile = 1609.344m
        radius: (milesRadius * 1610)
    });
    circle.bindTo('center', markers[0], 'position');
}

function createMarker(latlng, name, address, centre) {
    // console.log(latlng, name, address)
	var html = "<p><strong>" + name + "</strong></p><p>" + address + "</p>";
	if (centre === true) {
		// Add a different icon for the central marker
		var marker = new google.maps.Marker({
	        map: map,
	        position: latlng,
	        icon: "http://maps.google.com/mapfiles/marker" + String.fromCharCode(markers.length + 65) + ".png",
			animation:google.maps.Animation.DROP
	    });		
    } else {
    	var marker = new google.maps.Marker({ map: map, position: latlng, animation:google.maps.Animation.DROP });
    }
	
    google.maps.event.addListener(marker, 'click', function () {
        infoWindow.setContent(html);
        infoWindow.open(map, marker);
    });
    markers.push(marker);
}

function downloadUrl(url, callback) {
    var request = window.ActiveXObject?
    new ActiveXObject('Microsoft.XMLHTTP'):
    new XMLHttpRequest;
    
    request.onreadystatechange = function () {
        if (request.readyState == 4) {
            request.onreadystatechange = function(){};
            callback(request.responseText, request.status);
        }
    };
    request.open('GET', url, true);
    request.send(null);
}

function parseXml(str) {
    if (window.ActiveXObject) {
        var doc = new ActiveXObject('Microsoft.XMLDOM');
        doc.loadXML(str);
        return doc;
    } else if (window.DOMParser) {
        return (new DOMParser).parseFromString(str, 'text/xml');
    }
}