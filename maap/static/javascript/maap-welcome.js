var featuredPlaceData = {};

function loadFeaturedPlaces(placedict) {
    featuredPlaceData = placedict.places;
}

function initFeaturedPlace(place_name) {
    var title = $('featured_title');
    title.innerHTML = featuredPlaceData[place_name].title;

    var then_text = $('featured_then_text');
    then_text.innerHTML = featuredPlaceData[place_name].then_text;

    var featured_place_link = $('featured_place_link');
    featured_place_link.href = '/place/' + featuredPlaceData[place_name].id;

    var then_image = $('featured_then_image');
    then_image.src = featuredPlaceData[place_name].then_image_thumb_url;

    var then_image_link = $('featured_then_image_view');
    then_image_link.href = '/image/view/' + featuredPlaceData[place_name].then_image_id;
}

// Rotate the featured place daily. /places/welcome_places returns a json dict with the data we need.. 
// compute which to show based on the date and modular arithmetic
var MAX_PLACES = 10;
var now = new Date();
var curr_date = now.getDate();
var which_place = curr_date % MAX_PLACES;
connect(window, 'onload', partial(initFeaturedPlace, which_place));
