import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {

  }

  loadChats(event) {
    console.log("loadChats");
    // https://stackoverflow.com/questions/5811122/how-to-trigger-a-click-on-a-link-using-jquery
    $('#load_chats_link').find('span').trigger('click'); // Works
    $('#load_chats_link').remove();
  }
}
