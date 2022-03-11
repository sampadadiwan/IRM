import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    $("#investment_investor_id").on('select2:select', function () {
        let event = new Event('change', { bubbles: true }) // fire a native event
        this.dispatchEvent(event);
    });
  }

  setCategory(event) {
    let investor_id = $("#investment_investor_id").val();
    $.ajax({
        url: `/investors/${investor_id}.json`
    }).then(function(data) {
        console.log(`Setting category to ${data.category}`);
        $("#investment_category").val(data.category);       
    });
  }
}
