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
    var icon = new GIcon();
    //icon.image = MARKER_DIR + color + "_MarkerA.png";
    icon.image = MARKER_DIR + color + "pin.png";
    // the sample marker set doesn't have shadows 

    icon.shadow = MARKER_DIR + "shadow-pin.png";
    //icon.shadow = "http://www.google.com/mapfiles/shadow50.png";
    //icon.iconSize = new GSize(20, 34);
    //icon.shadowSize = new GSize(59, 32);
    icon.iconSize = new GSize(19, 22);
    icon.shadowSize = new GSize(31, 22);

    // do we need transparent to capture/fire events in ie?
    icon.transparent = "http://www.google.com/intl/en_ALL/mapfiles/markerTransparent.png";

    icon.iconAnchor = new GPoint(16, 16);
    icon.infoWindowAnchor = new GPoint(16, 0);
    icon.infoShadowAnchor = new GPoint(18, 25);

    ICONS[color] = icon;
}

