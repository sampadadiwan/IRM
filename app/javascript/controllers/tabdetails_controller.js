import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    if( $("#clickOnLoad").length > 0 ) {
      let link = $("#clickOnLoad").val();
      $(`${link} .load_data_link`).find('span').trigger('click'); // Works
      $(`${link} .load_data_link`).remove();  
    }
  }

  loadData(event) {
    console.log(`${event.target.hash} .load_data_link`);
    // https://stackoverflow.com/questions/5811122/how-to-trigger-a-click-on-a-link-using-jquery
    $(`${event.target.hash} .load_data_link`).find('span').trigger('click'); // Works
    $(`${event.target.hash} .load_data_link`).remove();
  }
}
