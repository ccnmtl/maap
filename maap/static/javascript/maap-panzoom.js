var mapData = {};

function loadMaps(mapdict) {
    mapData = mapdict.maps;
}

function initMaapPanZoomForm() {
    var queryrepo = $('mappatch_update_src_url');
    if (queryrepo) {
	src = $('mappatch_update_parent_mapID');
	var ann = query2annotation(queryrepo.value);
	//ann.imgdom = swapMapSrc(src);
	//PanZoomers['panzoom1'].loadImage(ann);

	chooseNewMap($('mappatch_update_parent_mapID'), ann);

	PanZoomers['panzoom1'].permlink = queryrepo;
	connect(PanZoomers['panzoom1'],'frame_update',PanZoomers['panzoom1'],'updatePermLink');	
 
	connect('mappatch_update_parent_mapID', 'onchange', chooseNewMap);
	//queryrepo.setAttribute('type','hidden');
	//hideElement(queryrepo.parentNode.parentNode);
	return true;
    }
    else {
	/* for the Then View */
	//query is really the hash
	var qstr = String(document.location.hash).substring(1);
	var map_cookie = String(document.cookie).match(/map=[^;]*/);
	if (qstr.length < 5 && map_cookie) {
	    qstr = map_cookie[0];
	}
	var ann = query2annotation(qstr); //query string in location
	var args = parseQueryString(qstr);
	var name = ('map' in args) ? args.map : 'NYPL54670'; //default probably has a better place to go
	swapMapAdvanced(name,ann);
	/* UPDATE DETAILS */
	addElementClass(name,'mapmeta_show');
	if ('view' in args && args['view']) {
	    current_maplist_view = args['view'];
	    selectView('maplist', current_maplist_view, false);
	}
	else {
	    current_maplist_view = 'map_marks';
	}
    }
    var move_left = $('move_map_left');
    if (move_left) {
	connect(move_left,'onclick',partial(moveView,-555));
	connect('move_map_right','onclick',partial(moveView,555));
	forEach(getElementsByTagAndClassName(null,'mapmeta_option','map_marks'), function(e) {
	    connect(e,'onmouseenter',showMapBubble);
	    connect(e,'onmouseleave',hideMapBubble);
	});
	forEach(getElementsByTagAndClassName(null,'mapmeta_option','smallmapthumbs'), function(e) {
	    connect(e,'onmouseenter',showMapBubble);
	    connect(e,'onmouseleave',hideMapBubble);
	});
    }
    return false;
}

function hideMapBubble() {
    hideElement('map_info_bubble');
}

function showMapBubble(evt) {
    var src = evt.src();
    var map_name = viewSelector_dom2name(src,'mapmeta');

    var bubble = $('map_info_bubble');
    var pos = getElementPosition(src);

    pos.x = pos.x - 100; //bubble width/2
    pos.y = pos.y - 187; //bubble height
    if (/MSIE 6/.test(navigator.userAgent)) {
	pos.y -= 7;
    }
    setElementPosition(bubble,pos);
    var bubble_image = getFirstElementByTagAndClassName(null,'bubble_image',bubble);
    bubble_image.src = mapData[map_name].images.bigthumb;

    //other data here
    $('bubbledate').innerHTML = mapData[map_name].year;
    $('bubbletitle').innerHTML = mapData[map_name].title;

    showElement(bubble);

    /*go ahead and pre-load place thumbs for when the person clicks:*/
    forEach(getElementsByTagAndClassName('img',map_name+'_map_patch_thumb','place_list'),
	    function(thumb) {
	if (!thumb.src) {
	    thumb.src = getNodeAttribute(thumb,'href');
	}
    });

}

function getRealWidth(dom) {
    var max=0;
    forEach(getElementsByTagAndClassName('td',null,dom),
	    function(e) {
	//logDebug('w',e.offsetLeft,e.offsetWidth);
	max = Math.max(max,e.offsetLeft+e.offsetWidth);
    });
    return max;
}

var view_widths = {};
var view_pos = {};
function moveView(dx) {
    var cur_view = getFirstElementByTagAndClassName(null,'maplist_show');

    var pos = (cur_view.id in view_pos) ? view_pos[cur_view.id]
	    : view_pos[cur_view.id]=cur_view.offsetLeft;
    //logDebug('1',-cur_view.offsetLeft+dx);
    if (-pos+dx < 0) {
	dx = pos;
    }
    else {
	var w = (cur_view.id in view_widths)? view_widths[cur_view.id]
	    : view_widths[cur_view.id]=getRealWidth(cur_view);
	var farthest = w-cur_view.parentNode.offsetWidth;
	//logDebug('2',-pos+dx, farthest, pos);
	if (-pos+dx > farthest) {
	    dx = pos+farthest;
	}
    }
    view_pos[cur_view.id] = pos - dx;
    var x = Move(cur_view,{x:-dx,queue:'break'});
}

connect(PanZoomers,'new',initMaapPanZoomForm);


function chooseNewMap(evt_or_selectDom, ann) {
    var src;
    if (typeof(evt_or_selectDom.src) == 'function') {
	src = evt_or_selectDom.src();
    }
    else {
	src = evt_or_selectDom;
    }
    var name = src.options[src.selectedIndex].text;
    swapMapAdvanced(name, ann);
}

function swapFromClick(name,obj) {
    //var src = evt.src();
    //var name = src.id;
    swapMapAdvanced(name);
}

var current_maplist_view;

if (typeof(ViewSelectors) != 'undefined') {
    update(ViewSelectors,{
	'mapmeta':{},
	'maplist':{}
    });
    connect(ViewSelectors['mapmeta'],'change_view' ,swapFromClick);
    connect(ViewSelectors['maplist'],'change_view' ,function(name,obj) {

	if (name === 'map_marks') {
	    hideElement('move_map_left','move_map_right');
	} else {
	    showElement('move_map_left','move_map_right');
	}
	current_maplist_view = name;
	PanZoomers['panzoom1'].updatePermLink();
    });
}


function swapMapAdvanced(name, ann) {
    var fitContainer=false;
    if (!ann || objEmpty(ann)) {
	ann = {center:{x:0.5,y:0.5},zoom:1};
	fitContainer=true;
    }
    /* IMAGE SWAP
       this is moderately complex:
     */
    //0. update name:
    PanZoomers['panzoom1'].name = name;

    //1. create new <img> tags and put them in array imgdoms[]
    var imgdoms = [];
    var images_avail = mapData[name].images;
    imgdoms.push(IMG({'src':images_avail['preview']}));
    imgdoms.push(IMG({'src':images_avail['big'],'style':'width:0;height:0;'}));
    imgdoms.push(IMG({'src':images_avail['gigantic'],'style':'width:0;height:0;'}));

    //2. take the current <DIV> that wraps the images inside panzoom and zero out positioning
    PanZoomers['panzoom1'].imgdom.style.width = null;
    PanZoomers['panzoom1'].imgdom.style.height = null;
    PanZoomers['panzoom1'].imgdom.style.left = null;
    PanZoomers['panzoom1'].imgdom.style.top = null;

    //3. replace all children of that <DIV> with our new <img>'s
    replaceChildNodes(PanZoomers['panzoom1'].imgdom, imgdoms);
    //oncomplete do this:

    //4. when the first (smallest 550x550) img loads, tell PanZoomer to update its context
    oncomplete(imgdoms[0],PanZoomers['panzoom1'],function() {
	setElementDimensions(PanZoomers['panzoom1'].imgdom,
			     elementDimensions(imgdoms[0])
			     );
	PanZoomers['panzoom1'].loadImage(ann);

	//5. after the image's height/width is used to determine the new dimensions for 
	//   PanZoomer in loadImage() above, make it defer to the <DIV> wrapper's size
	imgdoms[0].style.width = '100%';
	imgdoms[0].style.height = '100%';
	if (fitContainer) {
	    PanZoomers['panzoom1'].fitToContainer();
	}
    });

    /* OVERVIEW IMAGE SWAP */
    var overview = $('panzoom1_overview_image');
    if (overview) {
	var needsReload = overview.src;
	//logDebug(overview.src,images_avail['bigthumb']);
	setNodeAttribute(overview,'src',images_avail['bigthumb']);
	//logDebug('overview position:',ann.center.x,ann.center.y);
	overview.style.top = '';
	overview.style.left = '';
	overview.style.width = '';
	overview.style.height = '';

	if (needsReload) {
	    //logDebug('needsReload',needsReload);
	    /*needsReload qualifies because if the src attribute was not already set,
	      then there is already a listener on the loadImage
	      this might cause issues with the addressable function
	      we need to work on this more.
	     */
	    oncomplete(overview,
		       PanZoomers['panzoom1_overview'], function() {
		/*I originally had loadImageDetails directly here, though not sure why:*/
		PanZoomers['panzoom1_overview'].loadImage(ann);
		PanZoomers['panzoom1_overview'].fitToContainer();
		//disable panning
		PanZoomers['panzoom1_overview'].img.destroy();
		
	    });
	}
    }
    /* UPDATE PLACES */
    var place_list = $('place_list');
    if (place_list) {
	forEach(getElementsByTagAndClassName(null,'place_link',place_list),
		function(e) {
	    if (hasElementClass(e,name+'_map_patch')) {
		showElement(e);
		var thumb = getFirstElementByTagAndClassName('img',null,e);
		if (thumb && !thumb.src) {
		    thumb.src = getNodeAttribute(thumb,'href');
		}
	    } else {
		hideElement(e);
	    }
	});
    }
}

function initDifferentResolutions() {
    ///microformat style.  not used right now
    var imgs = getElementsByTagAndClassName(null,'image_size_options');
    forEach(imgs, function(img) {
	
    });
}

function initLoadThumbsAfterLoad() {
    /*
      this assumes a whole lot--specifically, 
      -- that the list in mapmeta is in the same order as:
      -- the list of images in the bigmapthumbs and smallmapthumbs view
         --note that this means the images in these sections must be the ONLY images 
	 (at least starting from the front)
      -- that getElementsByTagAndClassName and getElementsByTagName all return an ORDERED list
    */
    var map_list = getElementsByTagAndClassName('div','mapmeta_view','mapmeta');
    var small_thumbs = getElementsByTagAndClassName('img',null,'smallmapthumbs');
    //disabled due to issues in loading the overview window (and bubble window)
    var big_thumbs = getElementsByTagAndClassName('img',null,'bigmapthumbs');
    for(var i=0;i < map_list.length;i++) {
	var mid = map_list[i].id;
	big_thumbs[i].src = mapData[mid].images.bigthumb;
    }
    for(var i=0;i < map_list.length;i++) {
	var mid = map_list[i].id;
	small_thumbs[i].src = mapData[mid].images.smallthumb;
    }
}

if (/place\/then/.test(String(document.location))) {
    connect(window,'onload',initLoadThumbsAfterLoad);

    //override updatePermLink to behave with hashes
    PanZoom.prototype.updatePermLink = function() {
	var self = this; 
	//GOOD CODE:
	var qstr = 'map='+self.name+'&'+self.getQueryString()+'&view='+current_maplist_view;
	document.cookie = qstr;
	document.location.replace( '#'+qstr);
	//JUST FOR DEBUGGING (this way when you switch to a diff view you can click back to get to your previous map)
	//document.location = ( '#map='+self.name+'&'+self.getQueryString()+'&view='+current_maplist_view );
	self.permlink.href = String(document.location);
    };
}

function objEmpty(obj) {
    for (a in obj) {
	return false;
    }
    return true;

}
