
var map
var prev_marker
var markers = new Array();

// ***** INIT MAP START ********************************

function initialize() {
    var map_for_landing_page = document.getElementById("map_for_landing_page");
    var map_for_measurement  = document.getElementById("map_for_measurement");
    var map_for_measurement_page  = document.getElementById("map_for_measurement_page");
    if (map_for_landing_page != null){
        initialize_map_for_landing_page(map_for_landing_page);
    } else if (map_for_measurement != null){
        initialize_map_for_measurement(map_for_measurement);
    } else if (map_for_measurement_page != null){
        initialize_map_for_show_measurement(map_for_measurement_page);
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

function initialize_map_for_show_measurement(htmlElement){
    var latlng = loadLatLon();
    var myOptions = {
        zoom: 10,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map(htmlElement, myOptions);
    var marker = new google.maps.Marker({
        position: latlng,
        map: map
    });
}

// ***** INIT MAP STOP ********************************

function create_content(sievert, name, date, link){
    var color = 'style="color:green"';
    if (sievert != null && sievert > 10)
        color = 'style="color:red"'
    else if (sievert != null && sievert > 1)
        color = 'style="color:yellow"';
    var contentString = '<div id="content">'+
       '<span '+color+'>' + sievert + ' µSv/hour</span><br/>' +
       '<span class="timestamp">posted '+ date +' ago</span> | ' +
       '<span class="timestamp">'+link+'</span><br/>' +
       '<span>Measured by</span> '+ name +'<br/><br/><br/></div>';
    return contentString;
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

function placeMarker(contentString, lat, lng){
    var latlng = new google.maps.LatLng(lat, lng);
    var marker = new google.maps.Marker({position: latlng, map: map});
    markers.push(marker);
    var infowindow = new google.maps.InfoWindow({
        content: contentString
    });
    google.maps.event.addListener(marker, 'click', function() {
      infowindow.open(map, marker);
    });
}


// ***** FOR CLUSTERING ********************************

function clusterMarker(){
    var mcOptions = {gridSize: 40, maxZoom: 0};
    new MarkerClusterer(map, markers, mcOptions);
}

function fitMarkers(){
    if(markers.size == 1){
        map.setCenter(markers.getPosition());
    } else {
        var swLat = 90;
        var swLng = 180;
        var neLat = -90;
        var neLng = -180;

        for(var i in markers){
            var marker = markers[i];
            if (marker == null)
                continue
            var latLng = marker.position;
            if (latLng == null)
                continue
            var lat = latLng.lat;
            var lng = latLng.lng;

            if(lat < swLat)
                swLat = lat;
            if(lat > neLat)
                neLat = lat;
            if(lng < swLng)
                swLng = lng;
            if(lng > neLng)
                neLng = lng;
        }
        map.fitBounds(new google.maps.LatLngBounds(
            new google.maps.LatLng(swLat,swLng),
            new google.maps.LatLng(neLat,neLng))
        );
    }
}
