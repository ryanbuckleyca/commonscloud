// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { initMapbox } from '../plugins/init_mapbox';
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "map", "posts" ];

  connect() {
    console.log(this.mapTarget);
    console.log(this.postsTarget);
  }

  refresh(event) {
    fetch(`/posts?query=${event.currentTarget.value}`, { headers: { accept: "application/json" } })
      .then(response => response.json())
      .then((data) => {
        this.mapTarget.dataset.markers = JSON.stringify(data.markers);
        initMapbox();
      });
  }
}


// const browseOffers = document.querySelector(".browse-btn.blue");
// const browseRequests = document.querySelector(".browse-btn.yellow");

// const loadOffers = () => {

// }

// const loadPosts = () => {
//   browseOffers.addEventListener('click', (e) => {
//     console.log(e);
//   });
//   browseRequests.addEventListener('click', (e) => {
//     console.log(e);
//   });
// };

// export { loadPosts };
