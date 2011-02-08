// load the now-patch using google maps
// this is a map with just a single place on it
//

///this is for creating a listener with connect() below
ViewSelectors['then_now_tabber'] = {};

function loadPlace(patch_lat, patch_lng, color) {
    if (GBrowserIsCompatible()) {
	var patch_func = partial(nowPatch, patch_lat, patch_lng, color);
	connect(window, 'onload', patch_func);
	connect(ViewSelectors['then_now_tabber'], 'change_view', patch_func);
	connect(window, 'onunload', GUnload);
    }
}

function nowPatch(patch_lat, patch_lng, color) {
    // show the terrain map
    initMAAPIcons();

    var mapOpts = { mapTypes : [G_PHYSICAL_MAP] };
    var map = new GMap2(document.getElementById("map_canvas"), mapOpts);

    map.setCenter(new GLatLng(patch_lat, patch_lng), 14);

    // disable dragging on now map patch 
    map.disableDragging();

    // add controls 
    //map.addControl(new GSmallZoomControl());
    //map.addControl(new GScaleControl());
    
    var point = new GLatLng(patch_lat, patch_lng);
    var markerOpts = { icon : ICONS[color] };
    //logDebug(ICONS[color].image);
    var marker = new GMarker(point, markerOpts);

    /* here is some sample code for the info windows 
    GEvent.addListener(marker, "mouseover", function() {
	marker.openInfoWindowHtml("<a href=" + '/place/13' + ">" + "Click Me" + "</a>");
    });
    GEvent.addListener(marker, "mouseout", marker.closeInfoWindow);
    */

    map.addOverlay(marker);
}

