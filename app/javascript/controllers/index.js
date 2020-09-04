// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.

import { csrfToken } from "@rails/ujs";
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("controllers", true, /_controller\.js$/)
application.load(definitionsFromContext(context))

// Scrolling fade in landing page banner
export const secondCloud = () => {
  let banner = document.querySelector('.help-img');
  let cloud = document.querySelector('#cloud');
  let message = document.querySelector('.landing-msg');
  if (banner && cloud && message) {
    window.addEventListener('scroll', (e) => {
      cloud.style.opacity = 1 - (window.scrollY+1)/450;
      banner.style.opacity = 1 - (window.scrollY+1)/300;
      banner.style.top = `-${window.scrollY/20}px`;
      message.style.top = `${window.scrollY/4}px`;
      message.style.opacity = 1 - (window.scrollY+1)/400;
  });
  }
};

// BROWSE - REQUEST buttons
export const requestButtons = () => {
  // let request = document.querySelector('#request')
  // let offer = document.querySelector('#offer')
  // let change_allowed = true

  // if (request){
  //  /*request.checked = false*/
  //   request.addEventListener('change', (event) => {
  //     if (change_allowed) {
  //       change_allowed = false
  //       if (request.checked) {
  //         offer.checked = false
  //       }
  //       else {
  //         offer.checked = true
  //       }
  //       change_allowed = true
  //     }
  //   });
  // };

  // if (offer){
  //   /*offer.checked = false*/
  //   offer.addEventListener('change', (event) => {
  //      if (change_allowed) {
  //       change_allowed = false
  //       if (offer.checked) {
  //         request.checked = false
  //       }
  //       else{
  //         request.checked = true
  //       }
  //       change_allowed = true
  //     }
  //   });
  // };
};
// For use in chat
const fetchWithToken = (url, options) => {
  options.headers = {
    "X-CSRF-Token": csrfToken(),
    ...options.headers
  };
  options.credentials = "same-origin";
  return fetch(url, options);
}

// Send HTTP req to Chatroom
const chat_forms = document.querySelectorAll('.simple_form.new_message')
chat_forms.forEach((form) => {
  const chatroom_id = form.parentElement.dataset.chatroomId;
  const options = {
    method: "POST",
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ message: form.message_content.value })
  }
  form.addEventListener('submit', () => {
    event.preventDefault();
    const url = `users/${gon.current_user_id}/chatroom/${chatroom_id}`;
    fetchWithToken(url, options)
    .then(response => response.json())
    .then(data => {
      console.log(data);
    });
  });
});
