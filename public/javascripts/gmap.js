
var map
var prev_marker

function initialize() {
    var map_for_landing_page = document.getElementById("map_for_landing_page");
    var map_for_measurement  = document.getElementById("map_for_measurement");
    if (map_for_landing_page != null){
        initialize_map_for_landing_page(map_for_landing_page);
    } else if (map_for_measurement != null){
        initialize_map_for_measurement(map_for_measurement);
    }
}

function initialize_map_for_landing_page(htmlElement) {
    var latlng = new google.maps.LatLng(0.0, 20.4666667);
    var myOptions = {
        zoom: 1,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map(htmlElement, myOptions);
    loadMarkers();
}

function initialize_map_for_measurement(htmlElement) {
//    var latlng = new google.maps.LatLng(37.75, 140.4666667); // Japan
    var latlng = new google.maps.LatLng(39.9, -95.223);
    var myOptions = {
        zoom: 3,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map(htmlElement, myOptions);
    google.maps.event.addListener(map, 'click', function(event) {
        placeManualMarker(event.latLng);
    });
}

function placeManualMarker(location) {
    if (prev_marker){
        prev_marker.setMap(null)
        prev_marker = null;
    }
    var marker = new google.maps.Marker({
        position: location,
        map: map
    });
    map.setCenter(location);
    prev_marker = marker;

    document.getElementById("ShowLatLon").style.display = "block";
    document.getElementById("show_lat").value = location.lat();
    document.getElementById("show_lon").value = location.lng();
    document.getElementById("measurement_lat").value = location.lat();
    document.getElementById("measurement_lon").value = location.lng();
}

function create_content(sievert, name, coment){
    var contentString = '<div id="content">'+
       '<h4 id="firstHeading" class="firstHeading">' + sievert + ' µSv/hour</h4>' +
       '<p><b>Measured by:</b> '+ name +'<br/>';
    if (coment != null && coment != ''){
        contentString += '<b>Coment:</b> '+coment+'</p>';
    }
    contentString += '</div>';
    return contentString;
}

function placeMarker(contentString, lat, lng){
    var latlng = new google.maps.LatLng(lat, lng);
    var marker = new google.maps.Marker({
        position: latlng,
        map: map
    });
    var infowindow = new google.maps.InfoWindow({
        content: contentString
    });
    google.maps.event.addListener(marker, 'click', function() {
      infowindow.open(map, marker);
    });
}
