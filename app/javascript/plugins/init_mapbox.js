import mapboxgl from 'mapbox-gl';

// map with all markers, index page
const initMapbox = () => {
  const mapElement = document.getElementById('map');

  const fitMapToMarkers = (map, markers) => {
        const bounds = new mapboxgl.LngLatBounds();
        markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
        map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
      };

  if (mapElement) { // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/light-v10'
    });

    const markers = JSON.parse(mapElement.dataset.markers);
    console.log(mapElement)
    markers.forEach((marker) => {

      var el = document.createElement('i');
      el.className = marker.icon;
      el.style.fontSize = '30px';

      new mapboxgl.Marker(el)
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(map);

        map.scrollZoom.disable();
    });

    fitMapToMarkers(map, markers);
  }
};

export { initMapbox };
