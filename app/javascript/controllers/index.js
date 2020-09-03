// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.

import { csrfToken } from "@rails/ujs";
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("controllers", true, /_controller\.js$/)
application.load(definitionsFromContext(context))


window.addEventListener('scroll', () => {
  console.log("scrolling");
  let banner = document.querySelector('.help-img')
  let cloud = document.querySelector('#cloud')
  cloud.style = `opacity: ${1 - (window.scrollY+1)/350}`;
  banner.style = `opacity: ${1 - (window.scrollY+1)/350}`;
  banner.style = `position:relative; top: -${window.scrollY/20}px;`;
});

const request = document.querySelector('#request')
const offer = document.querySelector('#offer')


if (request){
  request.checked = false
  request.addEventListener('change', (event) => {
    offer.checked = !event.target.checked
  });
};

if (offer){
  offer.checked = false
  offer.addEventListener('change', (event) => {
    request.checked = !event.target.checked
  });
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
