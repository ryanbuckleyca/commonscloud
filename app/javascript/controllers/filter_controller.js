import { initMapbox } from '../plugins/init_mapbox';
import { Controller } from "stimulus"

const getSelected = () => {
  let types = document.querySelectorAll("input[name='type'][type='checkbox']:checked");
  let cats = document.querySelectorAll("input[name='categories'][type='checkbox']:checked");

  let types_values = []
  types.forEach(x => types_values.push(x.value))
  let cats_values = []
  cats.forEach(x => cats_values.push(x.value))

  return `type=${types_values}&categories=${cats_values}`;
}

export default class extends Controller {
  static targets = [ "map", "posts", "request", "offer"];

  clearSelected() {
    let cats = document.querySelectorAll("input[name='categories'][type='checkbox']:checked");
    cats.forEach(cat => cat.checked = false)
    this.refresh();
  }

  selectAll() {
    let cats = document.querySelectorAll("input[name='categories'][type='checkbox']");
    cats.forEach(cat => cat.checked = true)
    this.refresh();
  }

  chooseOffer() {
    this.requestTarget.checked = false;
    this.refresh();
  }

  chooseRequest() {
    this.offerTarget.checked = false;
    this.refresh();
  }

  refresh(event) {
    fetch(`/posts?${getSelected()}`, { headers: { accept: "application/json" } })
      .then(response => response.json())
      .then((data) => {
        this.mapTarget.dataset.markers = JSON.stringify(data.markers);
        window.refreshMarkers(window.mapbox, data.markers); // function is defined in initMapbox.js:15
        this.refreshPosts(data.posts);
      });
  }
  // this is a hold-over until figuring out how to render stimulus data
  posts(event) {
    window.location.replace(`/posts?${getSelected()}#filters`)
  }

  refreshPosts(newPosts) {
    // check posts controller#index:13 to understand what's happening here
    // the posts controller will pre-render the DIV cards and then send them back in a HTTP request
    // when your JS stimulus controller receives the `data` back, the bosy already contains the HTML it needs
    const errorText =
      `<div class="card-group col-12 px-0 pb-5">
        No posts yet based on your filters. Try a broader criteria or come back later when there are more commnunity offers/requests.
       </div>`;

    if (newPosts.length > 0) {
      document.getElementById('postsContainer').innerHTML = newPosts[0];
    } else {
      document.getElementById('postsContainer').innerHTML = errorText;
    }
  }
}
