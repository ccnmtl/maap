/*
  requires mochikit drag&drop

  @author Schuyler Duveen
  @sponsor Columbia Center for New Media Teaching & Learning
  @license ?!?!?>!@#$K#$

  TODO:
   * overview -- more like google
     -recenter
   * check out IE bug on Imager change: the img shifts position
   * onconnect() for PanZoom.loadImage
   * microformat for Imagers
   * zoom in/out controls (more like google)

   Later:
   * support js decoration (e.g. for tucker/wikispaces)

   Use Cases
   ---------
   1. Annotation as an overview selector
      * annotation is draggable 
      * annotation signals to another PanZoom its new location
      * annotation d&d behavior may be site/design specific
      * pan/zooming on the large image needs to update the annotation
   2. Annotation is 'drawn'
      * panning behavior would need to be off
   

   Classes
   -------
   Patch:
      zoom //percent zoom from original
      center //percentage of width/height
         x
	 y
      dimensions //Patch border proportional to original
         w
         h
     @methods
      frameUpdate() run (mostly internally) to signal(self,'frame_update',self)
      updatePatch(patch) moves/zooms the Patch to @param patch


   Overview stuff:
   -draggable box
   -draggable background

     Events:
       overview update
       -onmove annotation:
       * recenter
       * update main
       -ondrag overview:
       * <nothing>

       main update
       -onframe_update main
       *update overview annotation
       -> recenter overview

       Implementation:
       -main PanZoom _is_ the annotation on the overview
       *takes care of onframe_update(main)->update overview
	      
       -todo
       *updateAnnotation -> recenter
       *google-like ghost-catching-uping
*/


/**
 * Global list
 **/

var PanZoomers = {};
var Imagers = {};
/**
 * Helper functions
 **/

function query2annotation(qstr) {
    var ann = {};
    qstr = (qstr) ? qstr : String(document.location);
    if (qstr.indexOf('?') >= 0) {
	qstr= qstr.substring(qstr.indexOf('?')+1)
    }
    var args = parseQueryString(qstr);
    if ('z' in args) {
	ann['zoom'] = args.z;
    }
    if ('cx' in args) {
	ann['center'] = {'x':args.cx,'y':args.cy};
    }
    return ann;
}

function annotation2query(ann) {
    var query = '';
    if ('zoom' in ann) {
	query += "z="+Math.round(ann.zoom*1000)/1000;
    }
    if ('center' in ann) {
	if (query.length > 0) {
	    query += '&';
	}
	query += "cx="+ Math.round(ann.center.x*1000)/1000 +"&cy="+ Math.round(ann.center.y*1000)/1000;
    }
    return query;
}

function is_complete(imgdom) {
    ///ffox does not have the W3C readyState property here, but .complete is reliable
    ///IE does not reliably keep .complete == true, so we use readyState for IE
    //also make sure the src attribute is actually filled in
    var rv = ((imgdom.complete || imgdom.readyState === 'complete') && imgdom.src);
    return rv;
}

function oncomplete(imgdom,self,func) {
    var img;
    if (typeof(imgdom.tagName) == 'undefined'
	|| imgdom.tagName.toLowerCase() == 'img') {
	//logDebug('t1');
	img = imgdom;
    } else {
	//logDebug('t2');
	img = getFirstElementByTagAndClassName('img',null,imgdom);
	//logDebug('t3, complete:',img.complete,img.readyState, img.src);
    }
    if (is_complete(img)) {
	//logDebug('t4');
	//logDebug('complete already',img.src);
	var fake_evt = new function(){this.src = function(){return imgdom;}}();
	func.call(self,fake_evt);
	return null;
    }
    else {
	//logDebug('t5');
	var listener;
	//assumes self,func args can be called
	function run_and_disconnect() {
	    //logDebug('now complete',self.complete);
	    try {//stop memory leak
		disconnect(listener);
	    } catch(e) {/*make sure func still runs*/}
	    func.apply(self,arguments);
	}
	listener = connect(img,'onload',run_and_disconnect);
	return listener;
    }
}

/**
 * Imager: abstracts size changes (for tiling and higher resolutions)
 * when?
 *
 * -start loading in new image hidden, then swap oncomplete
 * -load tiles: 
    - closer to patch first
    - at correct zoom level

 * -what info we need
    -what sizes are available
    -what tilings are available
    -when a new image comes in
    -when frameUpdate

 * -notes informing design
    -tiling a 1.9M jpg to 300px squares results in 5M of tiles
     => big images are better than tiles
    -drags/changes get substantially hampered on zoomed out versions with highres images
     => on zoom out always switch back
     => don't load high res until zoom requires it

 **/

function Imager(panzoomer) {
    var self = this;
    this.pz = panzoomer;

    this.dom = panzoomer.imgdom;//can we avoid this?

    connect(panzoomer, 'frame_update', self, 'frameUpdate');
    connect(panzoomer, 'onload', self, 'init');

    //hopefully this will not be per-image data
    //                        big  giganto
    this.zoomThreshold = [-1, 2.1, 8, Infinity];
    
    self.init();
}

Imager.prototype.init = function(initial_patch) {
    //logDebug('init Imager');
    var self = this;
    if (self.imgs) {
	///stop memory leak here if necessary
    }

    this.imgs = this.dom.getElementsByTagName('img');
    this.cur = 0;
    this.ready = [];
    //damn! still haven't used map() in the Mapping project :-(
    //this.ready = map(itemgetter('complete'),this.imgs);

    for (var a=0;a < this.imgs.length; a++) {
	
	this.ready[a] = is_complete(this.imgs[a]);
	if (!this.ready[a]) {
	    oncomplete(self.imgs[a],self,bind(self.imgReady,self,a));
	}
    }
}

Imager.prototype.frameUpdate = function(ann) {
    var self = this;
    var zm = ('zoom' in ann) ? ann.zoom : 1;
    var zt = self.zoomThreshold;
    var c = self.cur;
    //logDebug('frameUpdate: zoom',zm,c,zt[c],zt[c+1]);
    if (zm < zt[c]) {
	while (--c >=0) {
	    if (self.ready[c]) {
		self.swapSize(c);
		break;
	    }
	}
    }
    else if (zm > zt[c+1]) {
	//logDebug('switch to higher');
	while (++c < self.ready.length) {
	    if (self.ready[c]) {
		self.swapSize(c);
		break;
	    }
	}
    }
}

Imager.prototype.imgReady = function(a,evt) {
    //logDebug('imgReady ',a);
    var self = this;
    self.ready[a] = true;
    var zt = self.zoomThreshold;
    var zm = self.pz.zoom;
    signal(self, 'zoomready',a,zt[a]);
    if (self.cur !== a && zt[a] < zm && zm < zt[a+1]) {
	self.swapSize(a);
    }
}

Imager.prototype.swapSize = function(a) {
    //logDebug('swap2Big', a);
    var self = this;
    var before = self.imgs[self.cur];
    var after = self.imgs[a];
    self.cur = a;

    after.style.width = '100%';
    after.style.height = '100%';
    before.style.width = '0';
    before.style.height = '0';

    //fight memory leaks;
    big = null;
    small = null;
}

connect(PanZoomers,'new',function(id,pz) {
    Imagers[id] = new Imager(pz);
    //logDebug('new imager',id);
});

/**
 * PanZoomer
 **/

function PanZoom(controls,patch) {
    var self = this;
    //defaults NOW IN loadImage
    //this.zoom = 1; 
    this.center = {}; //{'x':0.5,'y':0.5};
    this.annotations = [];
    this.img_listeners = [];
    this.complete = false; //whether the image is loaded or not
    this.src = true; //for is_complete()

    if (controls) {
	if ('linkdom' in controls) {
	    this.permlink = controls.linkdom;
	    connect(this,'frame_update',self,'updatePermLink');	    
	}
	if ('zoomin' in controls) {
	    connect(controls.zoomin,'onclick',self,'zoomIn');
	}
	if ('zoomout' in controls) {
	    connect(controls.zoomout,'onclick',self,'zoomOut');
	}
    }

    connect(this, 'frame_update', self, 'updateAnnotations');

    if (patch) {
	self.loadImage(patch);//patch.imgdom);
	//self.updatePatch(patch, /*update*/true); //now done in loadImage
    }
    return this;
}

///returns top left corner coords based on center coords
function c2l(c,self) {
    //logDebug('c2l',self.dimensions);
    return {
	'x':Math.round(-c.x*self.zoom*self.orig_width + self.orig_width*self.dimensions.w/2),
	'y':Math.round(-c.y*self.zoom*self.orig_height + self.orig_height*self.dimensions.h/2)
    };
}

PanZoom.prototype.loadImage = function(patch) {
    var self = this;

    patch = (patch) ? patch : self;

    //defaults for new images
    /*.zoom is commented out because it didn't seem necessary
     * and it was stopping the overview window from
     * adjusting to fitToContainer
     */
    //patch.zoom = ('zoom' in patch) ? patch.zoom : 1;
    patch.center = ('center' in patch) ? patch.center : {'x':0.5,'y':0.5};

    self.zoom = 1;

    if ('imgdom' in patch && patch.imgdom !== self.imgdom) {

	self.imgdom = patch.imgdom;

	var listener;
	while (listener = self.img_listeners.pop()) {
	    disconnect(listener);
	}

	/*if you get an error here: 
	  Error: 'funcOrStr' must be a function on 'objOrFunc'...
	  then you have to instantiate the PanZoom obj with _new_ PanZoom(...)
	*/
	self.img_listeners.push(connect(self.imgdom,'onmousedown',self,'cancelEffects'));

	try {
	    self.img.destroy(); //delete preexisting draggable
	} catch(e) {/*who cares*/}

	self.img = new Draggable(self.imgdom, {
	    'starteffect':bind(self.startDrag,self),
	    'endeffect':bind(self.finishDrag,self)
	});
    }
    //if the image isn't loaded yet, we need to wait until width/height are available
    self.complete = false;
    oncomplete(self.imgdom,self,partial(self.loadImageDetails,patch));
}

PanZoom.prototype.loadImageDetails = function(patch) {
    var self = this;

    var x = elementDimensions(self.imgdom);
    //logDebug('imgdom dimensions',x.w,x.h);

    self.orig_width = x.w;//self.imgdom.width;
    self.orig_height = x.h;//self.imgdom.height;

    var container_dim = elementDimensions(self.imgdom.parentNode);
    self.dimensions = {
	'w':container_dim.w/self.orig_width,
	'h':container_dim.h/self.orig_height
    };
    //logDebug('dimensions',self.dimensions.w,self.dimensions.h);
    //IE works better than from Mochi?!?!  MochiKit SUX?
    //self.corner = elementPosition(self.imgdom, self.imgdom.parentNode);
    self.corner = {x:self.imgdom.offsetLeft,
		   y:self.imgdom.offsetTop};

    self.complete = true;
    signal(self,'onload', patch);
    self.updatePatch(patch, /*update*/true);
}

PanZoom.prototype.frameUpdate = function() {
    var self = this;
    //logDebug('frame_update', self===PanZoomers['panzoom1'],self,self.corner.x,self.corner.y,self.center.x,self.center.y);
    signal(self, 'frame_update', self);
}

PanZoom.prototype.cancelEffects = function() {
    Move(this.imgdom,{'duration':0,'queue':'break'});
}

PanZoom.prototype.startDrag = function() {
}

PanZoom.prototype.finishDrag = function() {
    var self = this;
    var left = self.imgdom.offsetLeft;
    var top = self.imgdom.offsetTop;
    //logDebug('finishDrag',self.dimensions);
    self.center = {
	'x':((self.dimensions.w*self.orig_width/2) - left) /self.zoom /self.orig_width,
	'y': ((self.dimensions.h*self.orig_height/2) - top) /self.zoom /self.orig_height
    };
    self.corner = c2l( self.center, self);
    self.frameUpdate();
}

PanZoom.prototype.getQueryString = function() {
    var self = this;
    var query = annotation2query(self);
    return query;
}

PanZoom.prototype.updatePermLink = function() {
    //logDebug('updatepermlink');
    var self = this;
    var query = self.getQueryString();
    if (self.permlink.tagName.toLowerCase() == 'a') {
	//logDebug('a tag',query);
	self.permlink.href = location.pathname+'?' +query;
    }
    else if (self.permlink.tagName.toLowerCase() == 'input') {
	self.permlink.value = query;
    }
}

/*Convenience functions*/
PanZoom.prototype.zoomIn = function(x) {
    var self = this;
    var scale = (typeof(x) == 'number') ? x : 1.30;
    return self.updatePatch({'zoom':scale*self.zoom});
}

PanZoom.prototype.zoomOut = function(x) {
    var self = this;
    var scale = (typeof(x) == 'number') ? x : 0.77;
    return self.updatePatch({'zoom':scale*self.zoom});
}


///sane translation is +-0.3
PanZoom.prototype.translate = function(dx,dy) {
    var self = this;
    dx = (dx)?dx:0;
    dy = (dy)?dy:0;
    var c = self.center;
    return self.updatePatch({'center':{
	'x':c.x*1 + dx/self.zoom,'y':c.y*1 + dy/self.zoom
    }});
}

PanZoom.prototype.recenter = function() {
    return this.updatePatch({'center':{x:0.5,y:0.5}});
}

PanZoom.prototype.fitToContainer = function() {
    var self = this;
    var d = self.dimensions;
    var ann = {'center':{x:0.5,y:0.5},'zoom':1};
    if (d.w > d.h) {
	ann.zoom = d.h;
    } else {
	ann.zoom = d.w;
    }
    return self.updatePatch(ann);
}


PanZoom.prototype.updateFromQuery = function(qstr) {
    var self = this;
    self.updatePatch( query2annotation(qstr) );
}

PanZoom.prototype.updatePatch = function(patch, change) {
    var self = this;
    /// avoid recursive updates
    //logDebug('updatePatch',patch.center.x,patch.center.y,patch === self );
    if (!patch ||patch === self && !change) {
	return;
    }
    var oldzoom = self.zoom; //(self.zoom) ? self.zoom : 1;
    if ('zoom' in patch
	&& self.zoom != patch.zoom) 
    {
	self.zoom = patch.zoom;
	change = true;
    }

    if ('center' in patch
	&& (self.center.x != patch.center.x
	    || self.center.y != patch.center.y
	    )
	) 
    {
	self.center.x = patch.center.x;
	self.center.y = patch.center.y;
	change = true;
    }
    if (change) {
	//initialization condition: set self.corner in init()
	var oldpos = {x:self.corner.x,y:self.corner.y};
	//caused a regression on two zooms in quick succession
	//var oldpos = elementPosition(self.imgdom, self.imgdom.parentNode);
	self.corner = c2l( self.center, self);
	return Parallel([
	      /*we need queue:'break' because the Move() function uses some dynamic state,
		and without it, the center gets messed up
		if the UI is icky, might just do duration:0, and forget the fluidity
	      */
	      Move(self.imgdom, {x:self.corner.x-oldpos.x,y:self.corner.y-oldpos.y,queue:'break'}),
	      Scale(self.imgdom, self.zoom*100/oldzoom )
	      ], 
	      {afterFinish:bind(self.frameUpdate,self)}
	     );
    }
}

/* annotate() make a box
 * @param ann {center{x,y}, (proportional to orig)
               zoom,
	       dimensions{w,h} (proportional to orig)
	       (optional) 
	       addClass, 
	       dom}
 * @return an object that's listenable for changes
 */
PanZoom.prototype.annotate = function(ann) {
    /*
      1. connect self, 'frame_update' to annotationAdjust
     */
    var self = this;
    self.annotationAdjust(ann); //just the first time
    self.annotations.push(ann);

    //if the annotation changes, update it here.
    connect(ann, 'frame_update', self, 'updateAnnotations');
}

PanZoom.prototype.updateAnnotations = function() {
    var self = this;
    forEach(iter(self.annotations), self.annotationAdjust, self);
}

///moves the annotation based on any updates in @param ann or panzoom object
PanZoom.prototype.annotationAdjust = function(ann) {
    var self = this;
    //logDebug('annotationAdjust');
    var new_dim = {
	'w':ann.dimensions.w*self.orig_width*self.zoom/ann.zoom,
	'h':ann.dimensions.h*self.orig_height*self.zoom/ann.zoom
    };
    if (!(new_dim.w && new_dim.h)) {
	return;
    }
    //logDebug('before setelementdimensions',new_dim.w,new_dim.h);
    setElementDimensions(ann.dom, new_dim);
    //logDebug('after setelementdimensions',self.dimensions);
    var new_pos = {
	'x':Math.round((self.dimensions.w*self.orig_width/2)
		       -new_dim.w/2
		       -self.center.x*self.zoom*self.orig_width
		       +ann.center.x*self.zoom*self.orig_width
		       ),
	'y':Math.round((self.dimensions.h*self.orig_height/2)
		       -new_dim.h/2
		       -self.center.y*self.zoom*self.orig_height
		       +ann.center.y*self.zoom*self.orig_height
		       )
    }

    ann.dom.style.left = new_pos.x+'px';
    ann.dom.style.top = new_pos.y+'px';
}

//from 'x' in annotationAdjust, we want to get ann.center.%
function l2c(ann,self) {
    var x = ann.dom.offsetLeft;
    var y = ann.dom.offsetTop;
    //logDebug('l2c',ann.dimensions);
    var ann_dim = {
	'w':ann.dimensions.w*self.orig_width*self.zoom/ann.zoom,
	'h':ann.dimensions.h*self.orig_height*self.zoom/ann.zoom
    };

    ann.center.x*self.zoom*self.orig_width;
    var c = {
	'x':( -(self.dimensions.w*self.orig_width/2)
	      +ann_dim.w/2
	      +self.center.x*self.zoom*self.orig_width
	      +x
	      )	/self.zoom /self.orig_width,
	'y':( -(self.dimensions.h*self.orig_height/2)
	      +ann_dim.h/2
	      +self.center.y*self.zoom*self.orig_height
	      +y
	      )	/self.zoom /self.orig_height
    };
    return c;
}

/********************
 Initialization stuff
 ********************/

function initPanZoom(imgdom, ann) {
    //probably doesn't work anymore
    var controls = {
	'linkdom': $('permalink'), //dom obj
	'zoomin':'zoomIn', //dom ID
	'zoomout':'zoomOut' //dom ID
    };
    ann.imgdom = imgdom;
    var pz = new PanZoom(controls,ann);
    //overview = new PanZoom();
    //Ireland test
    pz.annotate({
	'dom':$('ann'),
	'zoom':10,
	'center':{x:0.475,y:0.2},
	'dimensions':{w:0.2,h:0.4} 
    });
}
/*
  <img id="panzoom1" class="panzoom" />
*/
function microformatPanZoom() {
    var imgs = getElementsByTagAndClassName(null,'panzoom');
    forEach(imgs, function(img) {
	if (img.id) {
	    var id = img.id;
	    var controls = {
		'linkdom': $(id+'_permalink'), //dom obj
		'zoomin':$(id+'_zoomIn'), //dom ID
		'zoomout':$(id+'_zoomOut') //dom ID
	    }
	    var ann = {
		'imgdom':img
	    };
	    var qstr;
	    if (!controls['linkdom']) {
		delete controls['linkdom'];
	    } else {
		
		qstr = controls['linkdom'].href;
	    }
	    if (!controls['zoomin'])  delete controls['zoomin'];
	    if (!controls['zoomout']) delete controls['zoomout'];
	    //defaults
	    var ann = {
		imgdom:img,
		center:{'x':0.5,'y':0.5},
		zoom:1
	    }

	    update(ann,query2annotation(qstr));

	    PanZoomers[id] = new PanZoom(controls,ann);
	    /* Overview */
	    var overview_dom = $(id+'_overview');
	    if (overview_dom) {

		var ov_image = getFirstElementByTagAndClassName(null,
								'overviewimage',
								overview_dom);
		var ov_pz = PanZoomers[id+'_overview'] = new PanZoom(null,{'imgdom':ov_image});

		PanZoomers[id].dom = getFirstElementByTagAndClassName(null,
								      'overviewSelector',
								      overview_dom);


		var ann = PanZoomers[id];
		var overviewDrag = new Draggable(ann.dom, {
		    'ghosting':true,
		    'selectclass':'dragging',
		    'starteffect':function(elt) {
			addElementClass(elt,'ghost');
		    },
		    'endeffect':function(elt) {
			removeElementClass(elt,'ghost');
			//update center
			ann.center = l2c(ann,ov_pz);
			ann.updatePatch(ann,true);
			signal(ann,'frame_update',ann);
		    }
		    
		});

		/*
		  here we have to wait until the dimensions for
		  the PanZoomer AND the dimensions for the
		  overview window are available.
		*/
		oncomplete(PanZoomers[id],PanZoomers[id],function() {
		    //logDebug('once in');
		var listener = oncomplete(ov_pz,ov_pz,function() {
		    ////logDebug(getElementDimensions(ov_image));
		    //logDebug('twice in');
		    var ann = PanZoomers[id];
		    
		    /*this disables dragging on the overview and centers it*/
		    /*setup annotator*/
		    ov_pz.img.destroy();
		    
		    //ov_pz.loadImageDetails(ov_pz);
		    
		    //ov_pz.loadImage();
		    
		    /*MYSTERY BUG:currently if we remove this
		      fitToContainer() call, IE fails to load
		      the image properly.

		      This doesn't make any sense
		      BUG #2: Also, onload, the image fits 
		      to the overviewSelector div rather than 
		      the portal dimensions.  This is critical :-(
		     */
		    ov_pz.fitToContainer();

		    ov_pz.annotate(ann);
		    //on end drag, update main frame--NOW done in endeffect()
		    //connect(ann,'frame_update',PanZoomers[id],'updatePatch');

		});
		//ov_pz.img_listeners.push(listener);
		});
		//on main drag, update overview box
		connect(ann,'frame_update',ov_pz,'annotationAdjust');
	    }
	    signal(PanZoomers,'new',id,PanZoomers[id]);
	}
    });
}

connect(window,'onload',microformatPanZoom);

//createLoggingPane(true);

/*Test cases for /place/then page:
http://kodos.ccnmtl.columbia.edu:9088/place/then
http://kodos.ccnmtl.columbia.edu:9088/place/then#map=NYPL434589&z=1.091&cx=0.5&cy=0.5&view=map_marks
http://kodos.ccnmtl.columbia.edu:9088/place/then#map=NYPL1527362&z=1.091&cx=0.5&cy=0.5&view=map_marks

with no cache
clicking from one map to another

*/
