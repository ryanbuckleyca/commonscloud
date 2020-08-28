import {materialSelect} from "mdbootstrap"
import $ from "jquery"

const initmultiselect = () => {
  console.log(materialSelect);
  $(document).ready(function() {
    $('.mdb-select').materialSelect();
  });
};

export {initmultiselect}