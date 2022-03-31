import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    var urlParams = new URLSearchParams(window.location.search);
    let tab = urlParams.get('tab');
    console.log(`tab_controller switching to #${tab}`);
    $(`a[href="#${tab}"]`).click() // Select tab by name
  }
}
