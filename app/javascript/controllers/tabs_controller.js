import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    var urlParams = new URLSearchParams(window.location.search);
    let tab = urlParams.get('tab');
    $(`a[href="#${tab}"]`).tab('show') // Select tab by name
  }
}
