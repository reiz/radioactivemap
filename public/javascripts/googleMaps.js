
    var map
    var prev_marker

    var contentString = '<div id="content">'+
            '<div id="siteNotice">'+
            '</div>'+
            '<h2 id="firstHeading" class="firstHeading">0.01  µSv/hour</h2>'+
            '<div id="bodyContent">'+
            '<p><b>Robert Reiz</b> </p>'+
            '<p>Voll Normal</p>'+
            '</div>'+
            '</div>';

    var infowindow = new google.maps.InfoWindow({
        content: contentString
    });




    function initialize() {
        var latlng = new google.maps.LatLng(37.75, 140.4666667);
        var latlng2 = new google.maps.LatLng(38.75, 140.4666667);
        var myOptions = {
            zoom: 5,
            center: latlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
        google.maps.event.addListener(map, 'click', function(event) {
            placeMarker(event.latLng);
        });


        var marker = new google.maps.Marker({
            position: latlng,
            map: map
        });

        google.maps.event.addListener(marker, 'click', function() {
          infowindow.open(map, marker);
        });


        var marker2 = new google.maps.Marker({
            position: latlng2,
            map: map
        });

        google.maps.event.addListener(marker2, 'click', function() {
          infowindow.open(map, marker2);
        });
    }

    function placeMarker(location) {
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
    }







