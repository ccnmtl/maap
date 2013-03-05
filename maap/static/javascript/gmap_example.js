    function initialize() {
	if (document.getElementById) { // formerly GBrowserIsCompatible(), but deprecated in v3
	    var map = new google.maps.Map(
		document.getElementById('map_canvas'), {
		    center: new google.maps.LatLng(37.4419, -122.1419),
		    zoom: 13,
		    mapTypeId: google.maps.MapTypeId.ROADMAP
		});
	    
            // Add 10 markers to the map at random locations
            var bounds = map.getBounds();
            var southWest = bounds.getSouthWest();
            var northEast = bounds.getNorthEast();
            var lngSpan = northEast.lng() - southWest.lng();
            var latSpan = northEast.lat() - southWest.lat();
            for (var i = 0; i < 10; i++) {
		
		var marker = new google.maps.Marker({
		    position: new google.maps.LatLng(southWest.lat() + latSpan * Math.random(),
						     southWest.lng() + lngSpan * Math.random()),
		    map: map
		});
	    }
	}
	google.maps.event.addDomListener(window, 'load', initialize)
    }

