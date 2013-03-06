var maap_places;

function loadPlaces(data) {
    maap_places = data.places;
    if (document.getElementById) {
	connect(window,'onload',mapPlaces);
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

/// Use this code to adapt from v2 - jsb - http://koti.mbnet.fi/ojalesa/boundsbox/attachinfowindow.htm

///     Insert this code before constructing Maps or Markers

/**
 * attachInfoWindow() binds InfoWindow to a Marker 
 * Creates InfoWindow instance if it does not exist already 
 * @extends Marker
 * @param InfoWindow options
 * @author Esa 2009
 */
google.maps.Marker.prototype.attachInfoWindow = function (options){
  var map_ = this.getMap();
  map_.bubble_ = map_.bubble_ || new google.maps.InfoWindow();
  google.maps.event.addListener(this, 'click', function () {
    map_.bubble_.setOptions(options);
    map_.bubble_.open(map_, this);
  });
  map_.infoWindowClickShutter = map_.infoWindowClickShutter || 
  google.maps.event.addListener(map_, 'click', function () {
    map_.bubble_.close();
  });
}

/**
 * accessInfoWindow()
 * @extends Map
 * @returns {InfoWindow} reference to the InfoWindow object instance
 * Creates InfoWindow instance if it does not exist already 
 * @author Esa 2009
 */
google.maps.Map.prototype.accessInfoWindow = function (){
  this.bubble_ = this.bubble_ || new google.maps.InfoWindow();
  return this.bubble_;
}

function mapPlaces() {
    //LAYOUT 
    DEFAULT_LAT  = 40.763901;
    DEFAULT_LNG  = -73.899536;
    DEFAULT_ZOOM = 11;

    var mapOpts = {  mapTypeId : google.maps.MapTypeId.TERRAIN,
		     center : new google.maps.LatLng(DEFAULT_LAT, DEFAULT_LNG),
		     zoom: DEFAULT_ZOOM,

		     // add controls
		     overviewMapControl: true,
		     overviewMapControlOptions: {
			 opened: true,
			 position: google.maps.ControlPosition.TOP_LEFT
		     }, 
		     zoomControlOptions : { 
			 style : google.maps.ZoomControlStyle.LARGE
		     },
		     streetViewControl : false

		  };
    var map = new google.maps.Map(document.getElementById("map_canvas"), mapOpts);
    
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
    
    map.setCenter(new google.maps.LatLng(bigmap_lat, bigmap_lng));
    map.setZoom(bigmap_zoom);

    initMAAPIcons();
    forEach(maap_places, function(p) {
	var point = new google.maps.LatLng(p.latitude, p.longitude);
	var markerOpts = merge({ position: point, map : map } , ICONS[p.color]);
	var mark = new google.maps.Marker(markerOpts);

	//var content = '<a href="/blah">Tontine Coffee House</a>';

	//mark.bindInfoWindowHtml(content);
	mark.attachInfoWindow({ 'content' : $('place_'+p.id), 'boxClass' : 'infowin', boxStyle : { 'maxWidth' : 300, 'borderRadius' : 5 } } );
	maap_marker_groups[p.color].push(mark);
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
