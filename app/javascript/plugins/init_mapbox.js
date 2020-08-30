import mapboxgl from 'mapbox-gl';

// map with all markers, index page
const initMapbox = () => {
  const mapElement = document.getElementById('map');

  const fitMapToMarkers = (map, markers) => {
        const bounds = new mapboxgl.LngLatBounds();
        markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
        map.fitBounds(bounds, { padding: 70, maxZoom: 11.15, duration: 0 });
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

    const markers = JSON.parse(mapElement.dataset.markers);
    markers.forEach((marker) => {

      var el = document.createElement('i');
      el.className = marker.icon;
      el.style.fontSize = '28px';

      new mapboxgl.Marker(el)
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(map);
    });

    fitMapToMarkers(map, markers);

    map.addControl(new mapboxgl.NavigationControl());

    // Disable tap handler, if present.
    if (map.tap) map.tap = false;

  }
};

export { initMapbox };
