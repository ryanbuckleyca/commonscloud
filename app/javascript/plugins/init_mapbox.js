import mapboxgl from 'mapbox-gl';

// map with all markers, index page
const initMapbox = () => {
  const mapElement = document.getElementById('map');

  const fitMapToMarkers = (map, markers) => {
    const bounds = new mapboxgl.LngLatBounds();
    markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
    map.fitBounds(bounds, { padding: 70, maxZoom: 11.15, duration: 0 });
  };

  // called by filterControllers.js
  // check lines 77-80 below. This function is attached to global window object so its accessible by stimulus.
  const refreshMarkers = (map, markers) => {
    // clear markers from map
    if (map.markers.length > 0) map.markers.forEach(m => m.remove());
    
    // build Marker Objects and attach to map
    if (markers.length > 0) {
      markers.forEach((marker) => {
        var el = document.createElement('i');
        el.className = marker.icon;
        el.style.fontSize = '28px';
        var mapboxMarker = new mapboxgl.Marker(el)
          .setLngLat([ marker.lng, marker.lat ])
          .addTo(map);
        map.markers.push(mapboxMarker);
      });
      // re-center the map and center it based on new filtered markers
      const bounds = new mapboxgl.LngLatBounds();
      markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
      map.fitBounds(bounds, { maxZoom: 11.15, duration: 0.5, animate: true, linear: true });
      map.flyTo({center: [markers[0].lng, markers[0].lat], zoom: 10.5});
    }
  };

  if (mapElement) { // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/light-v10',
      center: [-73.61, 45.50],
      zoom: 11.15,
      scrollZoom: false,
      touchZoom: false,
      doubleClickZoom: false,
      scrollWheelZoom: false,
      keyboard: true,
      tap: false
    });

    // provide array to store Marker Objects on Map Object on line 63.
    map.markers = [];

    const markers = JSON.parse(mapElement.dataset.markers);
    markers.forEach((marker) => {

      var el = document.createElement('i');
      el.className = marker.icon;
      el.style.fontSize = '28px';

      var mapboxMarker = new mapboxgl.Marker(el)
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(map);

      // store all markers inside the map object so you can clear them later with FilterController.js
      map.markers.push(mapboxMarker);
    });

    fitMapToMarkers(map, markers);

    map.addControl(new mapboxgl.NavigationControl());

    // Disable tap handler, if present.
    if (map.tap) map.tap = false;

    // make fitMapToMarkers() available on homepage for filterController.js
    window.refreshMarkers = refreshMarkers;
    // make the map JS object available on homepage for filterController.js
    window.mapbox = map;
  }
};

export { initMapbox };
