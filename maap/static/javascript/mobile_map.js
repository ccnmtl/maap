var jQT = $.jQTouch({
   icon: 'http://ccnmtl.columbia.edu/remote/jqtouch/themes/maap/img/homeicon.png',
   //initializeTouch: 'body, div.touch, a ',
   preloadImages: [
          'http://ccnmtl.columbia.edu/projects/maap/mbl/static/mbl/images/redpin_wide.png',
          'http://ccnmtl.columbia.edu/remote/jqtouch/themes/maap/img/homeicon.png',
          'http://ccnmtl.columbia.edu/remote/jqtouch/themes/maap/img/backButton.png',
          'http://ccnmtl.columbia.edu/remote/jqtouch/themes/maap/img/whiteButton.png',
          'http://ccnmtl.columbia.edu/projects/maap/mbl/images/button_maap_narration.png',
          'http://ccnmtl.columbia.edu/projects/maap/mbl/images/button_maap_video.png',
          'http://ccnmtl.columbia.edu/projects/maap/mbl/images/button_maap_audio.png',
          'http://ccnmtl.columbia.edu/remote/jqtouch/themes/maap/img/toolButton.png',
          'http://ccnmtl.columbia.edu/remote/jqtouch/themes/maap/img/loading.gif'
       ],
});



function getPlace(id){
       placeid= "#"+id;
        // $("#placeholder div.ajax-results").empty();
	//$(placeid+" ).empty();
        // this is the live url
        placeurl = '/mbl_place/'+id+'.html';
        // for testing, on dev
        //placeurl = '/mbl_place/'+id;
        //alert(placeid+ " "+ placeurl);
	$.ajax({
	  	url: placeurl,
		// data: "place=" + id,
		success: function(data) {
			$("#jqt").append(data);
			jQT.goTo(placeid, 'slide');
		}
	});
       
}


// Set up map canvas for single places

function map_initialize(pLat, pLon, entryID) {
    
    var dtitle= 't' + entryID;
    captiontext= 'caption'+ entryID;
    thenimg = "img" + entryID;
    rollovertitle = document.getElementById(dtitle).innerHTML;
    //placeinfo = '<a onclick="getPlace('+entryID+')" href="#'+entryID+'">'
    placeinfo = '<a class="back" style="height:15px; line-height:15px; max-width:150px; -webkit-border-image: none; color:brown; left:0px; text-shadow:none; margin:0px 0px 5px; text-decoration:underline;" href="#">';
    placeinfo += document.getElementById(dtitle).innerHTML + '</a><br />';
    placeinfo += document.getElementById(thenimg).innerHTML;
    placeinfo += '<br /><small>' + document.getElementById(captiontext).innerHTML + '</small>';
    // placeinfo += "<br /><small>("+ pLat + ", " + pLon +")</small>"
    maptitle = document.getElementById('maptitle');
    maptitle.innerHTML = rollovertitle;
    placeinfo = placeinfo.replace('<img', '<img height="100"');

    var pLatlng = new google.maps.LatLng(pLat, pLon);
    var myOptions = {
      zoom: 14,
      center: pLatlng,
      mapTypeId: google.maps.MapTypeId.TERRAIN
    };

   
    var infowindow = new google.maps.InfoWindow(
      {
          content: placeinfo
      });
    
    
    var map = new google.maps.Map(document.getElementById("map_canvas"),myOptions);
    var image = '/static/mbl/images/redpin_wide.png';
    var pinshadow = '/static/mbl/images/shadow-pin.png';
    var cumarker = new google.maps.Marker({
	    position: pLatlng, 
	    map: map,
	    animation: google.maps.Animation.DROP,
	    title: rollovertitle,
	    icon: image,
	    shadow: '/static/mbl/images/shadow-pin.png'
	});
    google.maps.event.addListener(cumarker, 'click', function() {
	    infowindow.open(map,cumarker);
	});
    return map;
}


(function () {

  google.maps.Map.prototype.markers = new Array();
    
  google.maps.Map.prototype.addMarker = function(marker) {
    this.markers[this.markers.length] = marker;
  };
    
  google.maps.Map.prototype.getMarkers = function() {
    return this.markers
  };
    
  google.maps.Map.prototype.clearMarkers = function() {
    if(infowindow) {
      infowindow.close();
    }
    
    for(var i=0; i<this.markers.length; i++){
      this.markers[i].set_map(null);
    }
  };
})();

var infowindow;
function map_initialize_all(myLatitude, myLongitude, z, region) {
    maptitle = document.getElementById('maptitle');
    maptitle.innerHTML = region;
    var myLatlng = new google.maps.LatLng(myLatitude, myLongitude);
    var myOptions = {
      zoom: z,
      center: myLatlng,
      mapTypeId: google.maps.MapTypeId.TERRAIN
    };
    
    map_all = new google.maps.Map(document.getElementById("map_canvas"),myOptions);
    var image = '/static/mbl/images/redpin_wide.png';
    var pinshadow = '/static/mbl/images/shadow-pin.png';
    for (var i = 0; i < places.length; i++) {
           var place = places[i];
           var myLatLng = new google.maps.LatLng(place[1], place[2]);
           map_all.addMarker(createMarker(map_all, place[0], myLatLng, place[3]));
        }
    return map_all;
}

function createMarker(map, name, latlng, id) {
    var image = '/static/mbl/images/redpin_wide.png';
    var pinshadow = '/static/mbl/images/shadow-pin.png';
    var marker = new google.maps.Marker({position: latlng, map: map,shadow: pinshadow,
               // animation: google.maps.Animation.DROP,
               icon: image,
               title: name});
    google.maps.event.addListener(marker, "click", function() {
      if (infowindow) infowindow.close();
      panestr = '<a onclick="getPlace('+id+')" href="#'+id+'"><b>'+name+'</b> </a><br>';
      infowindow = new google.maps.InfoWindow({content: panestr });
      infowindow.open(map, marker);
    });
    return marker;
 }

function recenter_map(myLatitude, myLongitude, z) {    
    var myLatlng = new google.maps.LatLng(myLatitude, myLongitude);
    map_all.setCenter(myLatlng);
    map_all.setZoom(z);
}
