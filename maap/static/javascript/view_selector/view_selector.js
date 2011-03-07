/*MICROFORMAT:

  <div id="{{display_id}}" class="selectable_view">
    <div id="{{view_1_id}}" class="{{display_id}}_view">
      View 1
    </div>
    <div id="{{view_2_id}}" class="{{display_id}}_view">
      View 2
    </div>
  </div>
  <div class="{{display_id}}_option {{display_id}}_selector_{{view_1_id}}">
      Click here to choose view 1
  </div>
  <div class="{{display_id}}_option {{display_id}}_selector_{{view_2_id}}">
      Click here to choose view 2
  </div>

  clicking any DOM with classes {{display_id}}_option {{display_id}}_selector_{{view_1_id}} 
       will hide all DOMs with class {{display_id}}_view except for 
       the one with id={{view_1_id}} which it will show

  add a function to ViewSelectors[display_id] to override behavior of how to 
  show and how to hide.

  default CSS should be:
  .{{display_id}}_view {
     display:none;
  }
  .{{display_id}}_view.{{display_id}}_show {
     display:block;
  }

*/
var ViewSelectors = {};

function viewSelector_dom2name(dom,display_id) {
    var rv = [];

    display_id = (display_id) ? display_id : '[^_]*';
    var selector_test = new RegExp('^'+display_id+'_selector_(.*)');
    var cls = dom.className;
    if (!cls) {
	return false;
    }
    var classes = cls.split(" ");
    forEach(classes,function(c) {
	var is_selector = selector_test.exec(c);
	if (is_selector) {
	    rv.push(is_selector[1]);
	}
    });
    return rv;
}

function selectView(display_id, view_name, no_signal) {
    var vid=view_name;
    var hide_func = MochiKit.Style.hideElement;
    var show_func = MochiKit.Style.showElement;
    var obj = $(vid);
    
    if (display_id in ViewSelectors) {
	if ('hide' in ViewSelectors[display_id]) {
	    hide_func = ViewSelectors[display_id]['hide'];
	}
	if ('show' in ViewSelectors[display_id]) {
	    show_func = ViewSelectors[display_id]['show'];
	}
    }
    ///for first time display
    MochiKit.Style.hideElement(obj);
    addElementClass(obj, display_id+'_show');
    show_func(obj);
    forEach(getElementsByTagAndClassName(null,display_id+"_view"),
	    function(v) {
	
	if (v.id !== vid && hasElementClass(v,display_id+'_show')) {
	    hide_func(v);
	    removeElementClass(v,display_id+'_show');
	}
    });

    ///selectors
    forEach(getElementsByTagAndClassName(null,display_id+'_option'), function(selector) {
	if (!hasElementClass(selector,display_id+'_selector_'+vid)) {
	    removeElementClass(selector,display_id+'_option_on');
	}
	else {
	    addElementClass(selector,display_id+'_option_on');
	}
    });

    ///at the end after display has changed
    if (display_id in ViewSelectors && !no_signal) {
	signal(ViewSelectors[display_id],'change_view',vid,obj);
    }
}

function selectViewListener(display_id, evt) {
    var src = evt.src();
    //redundant w/ selector section in selectView(), but here for immediate response
    addElementClass(src,display_id+'_option_on'); 
    forEach(viewSelector_dom2name(src,display_id),function(vid) {
	selectView(display_id, vid, false);
    });
}

function microformatSelector() {
    //logDebug('searching for Selector microformat');
    forEach(getElementsByTagAndClassName(null,'selectable_view'), function(d) {
	var display_id = d.id;
	if (!display_id) {
	    return;
	}
	forEach(getElementsByTagAndClassName(null,display_id+'_option'), function(v) {
	    //logDebug('foreach _option',v.id);
	    connect(v,'onclick',partial(selectViewListener,display_id));
	});
    });
}

connect(window,'onload',microformatSelector);
