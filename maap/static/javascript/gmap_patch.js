// load the now-patch using google maps
// this is a map with just a single place on it
//

///this is for creating a listener with connect() below
ViewSelectors['then_now_tabber'] = {};

function loadPlace(patch_lat, patch_lng, color) {
    if (document.getElementById) {
	var patch_func = partial(nowPatch, patch_lat, patch_lng, color);
	connect(window, 'onload', patch_func);
	connect(ViewSelectors['then_now_tabber'], 'change_view', patch_func);
	// connect(window, 'onunload', GUnload); 
    }
}

function nowPatch(patch_lat, patch_lng, color) {
    // show the terrain map
    initMAAPIcons();

    var mapOpts = {  mapTypeId : google.maps.MapTypeId.TERRAIN,
		     center : new google.maps.LatLng(patch_lat, patch_lng),
		     zoom: 14
		  };
    var map = new google.maps.Map(document.getElementById("map_canvas"), mapOpts);

    // disable dragging on now map patch
    // map.disableDragging()
    map.setOptions({draggable:false}); 

    // add controls 
    //map.addControl(new GSmallZoomControl());
    //map.addControl(new GScaleControl());
    
    //var point = new GLatLng(patch_lat, patch_lng);
    // var markerOpts = { icon : ICONS[color] };
        //logDebug(ICONS[color].image);
    //var marker = new GMarker(point, markerOpts);

    /* here is some sample code for the info windows 
    GEvent.addListener(marker, "mouseover", function() {
	marker.openInfoWindowHtml("<a href=" + '/place/13' + ">" + "Click Me" + "</a>");
    });
    GEvent.addListener(marker, "mouseout", marker.closeInfoWindow);
    */

    //map.addOverlay(marker);

    markerOpts = merge({ position: new google.maps.LatLng( patch_lat, patch_lng),
			  map: map } , 
			ICONS[color]); // v2 -> v3
    var marker  = new google.maps.Marker(markerOpts);
    //var marker = new google.maps.Marker({ position: new google.maps.LatLng( patch_lat, patch_lng),
    // map: map });

}

