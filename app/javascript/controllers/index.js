// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.

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
