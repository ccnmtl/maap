// prep some contsants, like our custom icons
//
//
var maap_marker_groups = {'blue':[],
			  'gold':[],
			  'green':[],
			  'red':[],
			  'purple':[],
			  'brown':[]
};
//var ICON_COLORS = [ "blue", "darkgreen", "orange", "pink" ];
var ICON_COLORS = [ "blue", "gold", "green", "red", "purple", "brown" ];
var ICONS = {};
//var MARKER_DIR = "/static/images/markers/samples/";
var MARKER_DIR = "/static/images/markers/";

function initMAAPIcons() {
    forEach(ICON_COLORS, initMAAPIcon);
}

function initMAAPIcon(color) {
    var icon = { 

	//icon.image = MARKER_DIR + color + "_MarkerA.png";
	icon : MARKER_DIR + color + "pin.png",
	
	// the sample marker set doesn't have shadows 

	shadow : MARKER_DIR + "shadow-pin.png",
	
	//icon.shadow = "http://www.google.com/mapfiles/shadow50.png";
	//icon.iconSize = new GSize(20, 34);
	//icon.shadowSize = new GSize(59, 32);

	size : new google.maps.Size(19, 22),
	// does v3 need this?

	// icon.shadowSize = new GSize(31, 22);

	// do we need transparent to capture/fire events in ie?
	// does v3 need this?
	// icon.transparent = "http://www.google.com/intl/en_ALL/mapfiles/markerTransparent.png";

	anchor : new google.maps.Point(16, 16),

	// does v3 need this? 
	// icon.infoWindowAnchor = new GPoint(16, 0);
	// does v3 need this? 
	// icon.infoShadowAnchor = new GPoint(18, 25);
    }
    ICONS[color] = icon;
}

