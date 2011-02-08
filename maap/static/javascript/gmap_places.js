var maap_places;

function loadPlaces(data) {
    maap_places = data.places;
    if (GBrowserIsCompatible()) {
	connect(window,'onload',mapPlaces);
	connect(window, 'onunload', GUnload);
    }
}

function parseBigmapQstr() {
    var bigmapPos = {};
    qstr = String(document.location);
    if (qstr.indexOf('#') >= 0) {
	qstr  = qstr.substring(qstr.indexOf('#')+1);
    }
    var args = parseQueryString(qstr);
    if ('zoom' in args) {
	bigmapPos['zoom'] = args.zoom;
    }
    if ('lat' in args) {
	bigmapPos['lat'] = args.lat;
    }
    if ('lng' in args) {
	bigmapPos['lng'] = args.lng;
    }
    return bigmapPos;
}

var sky;
var possky;

function mapPlaces() {
    // show the terrain map
    var opts = { mapTypes : new Array(G_PHYSICAL_MAP) };
    var map = new GMap2(document.getElementById("map_canvas"), opts);
    //LAYOUT 
    DEFAULT_LAT  = 40.763901;
    DEFAULT_LNG  = -73.899536;
    DEFAULT_ZOOM = 11;
    
    bigmapPos = parseBigmapQstr();

    if (bigmapPos['lat'] && bigmapPos['lng'] && bigmapPos['zoom']) {
	bigmap_lat  = bigmapPos['lat'];
	bigmap_lng =  bigmapPos['lng'];
	// for unknown reasons, this isn't working correctly. I fear it needs 
	// to be cast as an int, but I can't figure out how.
	// bigmap_zoom = bigmapPos['zoom'];
	// luckily, this works, and is what we always want the patches to be
	bigmap_zoom = 15;
    } else {
	bigmap_lat = DEFAULT_LAT;
	bigmap_lng = DEFAULT_LNG;
	bigmap_zoom = DEFAULT_ZOOM;
    }
    
    map.setCenter(new GLatLng(bigmap_lat, bigmap_lng), bigmap_zoom);

    //CONTROLS
    var overview_control_pos = new GControlPosition(G_ANCHOR_TOP_RIGHT, new GSize(10,10));

    sky = new GOverviewMapControl();
    //map.addControl(sky, overview_control_pos);
    map.addControl(sky);
    //map.addControl(new GOverviewMapControl())
    map.addControl(new GLargeMapControl());
	
    initMAAPIcons();
    forEach(maap_places, function(p) {
	var point = new GLatLng(p.latitude, p.longitude);
	var markerOpts = { icon : ICONS[p.color] }
	var mark = new GMarker(point, markerOpts);

	//var content = '<a href="/blah">Tontine Coffee House</a>';

	//mark.bindInfoWindowHtml(content);
	mark.bindInfoWindow($('place_'+p.id),{'maxWidth':300});
	maap_marker_groups[p.color].push(mark);
	map.addOverlay(mark);
    });

    //moveOverview('gmap_overview_destination');
    //moveOverview('navigator-top-left-inner');

    if ($('red')) {
	connect('red','onclick',maap_hideshow);
	connect('blue','onclick',maap_hideshow);
	connect('gold','onclick',maap_hideshow);
	connect('purple','onclick',maap_hideshow);
    }
    
}

function hello() {
    logDebug('hello');
}

var insky=[];
function moveOverview(destination) {
    var timeout_id;
    var i=0;
    function checkUntil() {
	var overview_div = $('map_canvas_overview');
	if (overview_div
	    && overview_div.firstChild.getElementsByTagName('img').length > 0) {
	    /*
	      why this doesn't work:
	      moving the map div absolutely under a relatively positioned 
	      creates a bug in clicking on a location:
	        instead of positioning the bubble infowindow inside the gmap,
		it positions it off screen.
	      not sure if google just has a buggy positioning or if they 
 	        do this on purpose to stop us from moving the overview window
		
	    */
	    clearInterval(timeout_id);
	    /*
	    ///this will get rewritten if someone clicks the arrow, which we can remove
	      
	    overview_div.style.right = '';
	    overview_div.style.bottom = '';
	    overview_div.style.top = '0px';
	    overview_div.style.left = '0px';
	    overview_div.style.width = '120px';
	    overview_div.style.height = '120px';
	    */

	    //delete hide/show arrow:
	    overview_div.lastChild.style.display = 'none';

	    appendChildNodes(destination, overview_div);
	}
	
    }
    timeout_id = setInterval(checkUntil, 30);
    
}

function maap_hideshow(evt) {
    var src = evt.src();
    var color = src.name;
    if (src.checked) {
	maap_show(color);
    } else {
	maap_hide(color);
    }
}

function maap_hide(color) {
    forEach(maap_marker_groups[color], function(m) {
	m.hide();
    });
}

function maap_show(color) {
    forEach(maap_marker_groups[color], function(m) {
	m.show();
    });
}
