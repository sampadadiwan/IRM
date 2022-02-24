import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {

  }

  loadData(event) {
    console.log(`${event.target.hash} .load_data_link`);
    // https://stackoverflow.com/questions/5811122/how-to-trigger-a-click-on-a-link-using-jquery
    $(`${event.target.hash} .load_data_link`).find('span').trigger('click'); // Works
    $(`${event.target.hash} .load_data_link`).remove();
  }
}
