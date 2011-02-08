function unselectAllTabs() {
    removeElementClass('home', 'selected');
    removeElementClass('places', 'selected');
    removeElementClass('lesson', 'selected');
    removeElementClass('library', 'selected');
}

function highlightCurrentTab() {
    var url_parts = location.href.split('/');

    var isProd = false;

	 if (findValue(url_parts, 'maap.columbia.edu') >= 0) {
	//if (findValue(url_parts, 'kodos.ccnmtl.columbia.edu:9091')) {	
	isProd = true;
    }

    // when wer are not on (static) prod, make admin link invisible    
    // and change color when we are administering
    if (! isProd) {
	admin_anchor = $('admin');
	setStyle(admin_anchor, { 'display' : 'inline' } );

	// first check if we are in the admin section
	if (findValue(url_parts, 'admin') >= 0) {
	    setStyle(admin_anchor, {'color' :'Red'});
	} else {
	    setStyle(admin_anchor, {'color' :'#e1d3c2'});
	}
    }
    if (findValue(url_parts, 'place') >= 0 ) {
	unselectAllTabs();
	setElementClass('places', 'selected');
    } else if (findValue(url_parts, 'lesson') >= 0 || 
	       findValue(url_parts, 'module') >= 0) {
	unselectAllTabs();
	setElementClass('lesson', 'selected');
    } else if (findValue(url_parts, 'library') >= 0) {
	unselectAllTabs();
	setElementClass('library', 'selected');
    } else if (findValue(url_parts, 'welcome') >= 0 ||
	      findValue(url_parts, 'welcome.html') >= 0) {
	unselectAllTabs();
	setElementClass('home', 'selected');
    } else {
	unselectAllTabs();
    }
}

addLoadEvent(highlightCurrentTab);